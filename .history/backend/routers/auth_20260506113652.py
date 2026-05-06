from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta
from ..database import SessionLocal
from ..models.user import User, UserRole
import os

router = APIRouter(prefix="/auth", tags=["auth"])

SECRET_KEY = os.getenv("SECRET_KEY", "secret")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def get_db():
    async with SessionLocal() as session:
        yield session

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

@router.post("/signup")
async def signup(username: str, email: str, password: str, role: UserRole, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where((User.username == username) | (User.email == email)))
    user = result.scalar_one_or_none()
    if user:
        raise HTTPException(status_code=400, detail="Username or email already registered")
    hashed_password = get_password_hash(password)
    new_user = User(username=username, email=email, hashed_password=hashed_password, role=role)
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return {"msg": "User created successfully"}

@router.post("/login")
async def login(username: str, password: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.username == username))
    user = result.scalar_one_or_none()
    if not user or not verify_password(password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    access_token = create_access_token(data={"sub": user.username, "role": user.role.value})
    return {"access_token": access_token, "token_type": "bearer"}
