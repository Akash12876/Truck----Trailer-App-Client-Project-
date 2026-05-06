from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.history.vehicle_history import VehicleHistory
from ..models.inventory.vehicle import Vehicle
from ..models.jobs.job import Job
from ..models.user import User
from typing import List

router = APIRouter(prefix="/history", tags=["history"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.get("/vehicle/{vehicle_id}")
async def get_vehicle_history(vehicle_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(VehicleHistory).where(VehicleHistory.vehicle_id == vehicle_id))
    history = result.scalars().all()
    return history

@router.post("/log_action")
async def log_vehicle_action(vehicle_id: int, job_id: int, action: str, performed_by_id: int, db: AsyncSession = Depends(get_db)):
    log = VehicleHistory(
        vehicle_id=vehicle_id,
        job_id=job_id,
        action=action,
        performed_by_id=performed_by_id
    )
    db.add(log)
    await db.commit()
    await db.refresh(log)
    return {"msg": "Action logged", "log_id": log.id}
