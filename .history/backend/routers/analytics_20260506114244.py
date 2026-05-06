from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from ..database import SessionLocal
from ..models.analytics.company_analytics import CompanyAnalytics

router = APIRouter(prefix="/analytics", tags=["analytics"])

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.get("/company")
async def get_company_analytics(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(CompanyAnalytics))
    analytics = result.scalars().first()
    return analytics
