from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from dependencies import get_db
from models.analytics.company_analytics import CompanyAnalytics
from schemas.analytics import CompanyAnalyticsResponse

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.get("/company", response_model=CompanyAnalyticsResponse | None)
async def get_company_analytics(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(CompanyAnalytics))
    return result.scalars().first()
