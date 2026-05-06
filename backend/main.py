from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from .core.config import get_settings
from .routers import analytics, auth, history, inventory, jobs, logs

load_dotenv()
settings = get_settings()

app = FastAPI(title="Truck & Trailer Repair App Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(inventory.router)
app.include_router(jobs.router)
app.include_router(history.router)
app.include_router(analytics.router)
app.include_router(logs.router)


@app.get("/")
def root():
    return {"message": "Truck & Trailer Repair App Backend is running."}
