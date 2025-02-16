from fastapi import FastAPI, UploadFile, File
from ultralytics import YOLO
import cv2
import numpy as np
import requests
import os

# Initialize FastAPI app
app = FastAPI()

# Load YOLOv8 model once when the app starts
model = YOLO("yolov8n.pt")

# Edamam API Key and App ID (replace with your actual API key and App ID)
EDAMAM_API_KEY = "22805abcf1441f12113db820df00139a"
EDAMAM_APP_ID = "c422ee64"

# Function to fetch nutrition info from the Edamam Food Database API
def get_nutrition_info_edamam(food_item):
    url = "https://api.edamam.com/api/food-database/v2/parser"
    params = {
        "ingr": food_item,  # The food item to search for
        "app_id": EDAMAM_APP_ID,
        "app_key": EDAMAM_API_KEY,
        "nutrition-type": "cooking"  # Optional: Include if needed
    }
    
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        if "hints" in data and data["hints"]:
            # Pick the first result
            food = data["hints"][0]["food"]
            label = food.get("label", "Unknown")
            nutrients = food.get("nutrients", {})
            
            return {
                "Description": label,
                "Calories (kcal/100g)": nutrients.get("ENERC_KCAL", "N/A"),
                "Protein (g/100g)": nutrients.get("PROCNT", "N/A"),
                "Fat (g/100g)": nutrients.get("FAT", "N/A"),
                "Carbohydrates (g/100g)": nutrients.get("CHOCDF", "N/A")
            }
        else:
            return {"error": f"No food items found for '{food_item}'."}
    else:
        return {"error": f"Request failed with status code {response.status_code}"}

# Endpoint to analyze images and detect food items
@app.post("/analyze")
async def analyze_image(file: UploadFile = File(...)):
    # Read image file into memory
    contents = await file.read()
    np_img = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)
    
    # Run inference using YOLOv8
    results = model(img)
    result = results[0]
    
    detected_foods = []
    for box in result.boxes:
        bbox = box.xyxy[0].tolist()
        conf = box.conf.item()
        class_id = int(box.cls.item())
        class_name = model.names[class_id]
        
        detected_foods.append({
            "class_name": class_name,
            "confidence": conf, 
            "bbox": bbox
        })
    
    # If food detected, query Edamam API for the first detected food
    if detected_foods:
        food_item = detected_foods[0]["class_name"]
        nutrition_data = get_nutrition_info_edamam(food_item)
    else:
        nutrition_data = {"error": "No food detected."}
    
    return {
        "detected_foods": detected_foods,
        "nutrition_data": nutrition_data
    }

# Run the FastAPI app locally (useful for development and testing)
if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 5000))  # Use the PORT env variable, default to 5000 locally
    uvicorn.run(app, host="0.0.0.0", port=port)