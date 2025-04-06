## Database setup

### Requirements
- python 3.12
- PostgreSQL
- `.env` file in the server's root directory

### How to setup (Windows)

- Go to the server directory
- Using `.env.example`. Create a `.env` file and fill it with the corresponding information
- (Optional) Create a virtual environment
```shell
python venv .venv
```
- Enter the environment if you have created one
```bash
.venv/Scripts/activate
```
- Install the libraries in requirements.txt
```bash
pip install -r requirements.txt
```
- Run the app file
```bash
python app.py
```