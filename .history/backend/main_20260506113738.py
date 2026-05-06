from fastapi import FastAPI
from dotenv import load_dotenv
from routers import auth
from routers import inventory

load_dotenv()

app = FastAPI(title="Truck & Trailer Repair App Backend")


app.include_router(inventory.router)

@app.get("/")
def root():
    return {"message": "Truck & Trailer Repair App Backend is running."}
