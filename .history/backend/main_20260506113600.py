from fastapi import FastAPI
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Truck & Trailer Repair App Backend")

@app.get("/")
def root():
    return {"message": "Truck & Trailer Repair App Backend is running."}
