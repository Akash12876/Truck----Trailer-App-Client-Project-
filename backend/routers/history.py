from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dependencies import get_db
from ..models.history.vehicle_history import VehicleHistory
from ..schemas.history import VehicleActionRequest, VehicleHistoryResponse

router = APIRouter(prefix="/history", tags=["history"])


@router.get("/vehicle/{vehicle_id}", response_model=list[VehicleHistoryResponse])
async def get_vehicle_history(vehicle_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(VehicleHistory).where(VehicleHistory.vehicle_id == vehicle_id)
    )
    return result.scalars().all()


@router.post("/log_action")
async def log_vehicle_action(
    payload: VehicleActionRequest,
    db: AsyncSession = Depends(get_db),
):
    log = VehicleHistory(
        vehicle_id=payload.vehicle_id,
        job_id=payload.job_id,
        action=payload.action,
        performed_by_id=payload.performed_by_id,
    )
    db.add(log)
    await db.commit()
    await db.refresh(log)
    return {"msg": "Action logged", "log_id": log.id}
