from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dependencies import get_db
from ..models.logs.system_log import SystemLog
from ..schemas.logs import SystemLogResponse

router = APIRouter(prefix="/logs", tags=["logs"])


@router.get("/", response_model=list[SystemLogResponse])
async def get_logs(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(SystemLog))
    return result.scalars().all()
