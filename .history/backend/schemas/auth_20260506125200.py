from pydantic import BaseModel, EmailStr

from ..models.user import UserRole


class SignupRequest(BaseModel):
    username: str
    email: EmailStr
    password: str
    role: UserRole


class LoginRequest(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
