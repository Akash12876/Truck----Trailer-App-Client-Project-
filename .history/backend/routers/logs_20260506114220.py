from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.logs.system_log import SystemLog

router = APIRouter(prefix="/logs", tags=["logs"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.get("/")
async def get_logs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SystemLog))
    logs = result.scalars().all()
    return logs
