from fastapi import FastAPI
from dotenv import load_dotenv
from routers import auth, inventory, jobs, history

load_dotenv()

app = FastAPI(title="Truck & Trailer Repair App Backend")




app.include_router(history.router)

@app.get("/")
def root():
    return {"message": "Truck & Trailer Repair App Backend is running."}
