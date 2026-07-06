from pydantic import BaseModel, EmailStr

from .models_db import UserRole


class SignupInput(BaseModel):
    email: EmailStr
    password: str
    role: UserRole


class LoginInput(BaseModel):
    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    role: UserRole


class InviteCodeResponse(BaseModel):
    invite_code: str


class RedeemInput(BaseModel):
    invite_code: str


class SymptomInput(BaseModel):
    symptom_text: str


class FallEventInput(BaseModel):
    peak_magnitude: float
    detected_at: str
