from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from contextlib import asynccontextmanager

from core.config import get_settings
from database import engine, Base
from models import User, Vehicle, Job, VehicleHistory, CompanyAnalytics, SystemLog
from routers import analytics, auth, history, inventory, jobs, logs

load_dotenv()
settings = get_settings()

@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield

app = FastAPI(title="Truck & Trailer Repair App Backend", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
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

@app.get("/health")
def health():
    return {"status": "ok"}
