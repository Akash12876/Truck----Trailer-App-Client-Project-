from fastapi import FastAPI
from dotenv import load_dotenv
from routers import auth, inventory, jobs, history, analytics, logs

load_dotenv()

app = FastAPI(title="Truck & Trailer Repair App Backend")





app.include_router(analytics.router)
app.include_router(logs.router)

@app.get("/")
def root():
    return {"message": "Truck & Trailer Repair App Backend is running."}
