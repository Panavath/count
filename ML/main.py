from fastapi import FastAPI, UploadFile, File
from ultralytics import YOLO
import cv2
import numpy as np
import requests
import io

app = FastAPI()

# Load model once at startup
model = YOLO("yolov8n.pt")
API_KEY = "C63N4f7cCCjCwDSrw4aTnZcuycqJgQwDbTwPE2nR"

def get_nutrition_info_usda(query):
    url = "https://api.nal.usda.gov/fdc/v1/foods/search"
    params = {
        "query": query,
        "api_key": API_KEY,
        "pageSize": 1
    }
    
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        foods = data.get("foods", [])
        if foods:
            food = foods[0]
            description = food.get("description", "Unknown")
            nutrients = {nutrient['nutrientId']: nutrient['value'] for nutrient in food.get("foodNutrients", [])}
            calories = nutrients.get(1008, "N/A")
            protein  = nutrients.get(1003, "N/A")
            fat      = nutrients.get(1004, "N/A")
            carbs    = nutrients.get(1005, "N/A")
            
            return {
                "Description": description,
                "Calories (kcal/100g)": calories,
                "Protein (g/100g)": protein,
                "Fat (g/100g)": fat,
                "Carbohydrates (g/100g)": carbs
            }
        else:
            return {"error": "No food items found for this query."}
    else:
        return {"error": f"Request failed with status code {response.status_code}"}

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
    
    # If food detected, query USDA API for the first detected food
    if detected_foods:
        food_item = detected_foods[0]["class_name"]
        nutrition_data = get_nutrition_info_usda(food_item)
    else:
        nutrition_data = {"error": "No food detected."}
    
    return {
        "detected_foods": detected_foods,
        "nutrition_data": nutrition_data
    }
