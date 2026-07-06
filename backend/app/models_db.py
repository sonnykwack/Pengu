import enum
import uuid

from sqlalchemy import Column, DateTime, Enum as SqlEnum, Float, ForeignKey, String

from .db import Base


class UserRole(str, enum.Enum):
    patient = "patient"
    guardian = "guardian"


def _uuid() -> str:
    return str(uuid.uuid4())


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=_uuid)
    email = Column(String, unique=True, nullable=False, index=True)
    hashed_password = Column(String, nullable=False)
    role = Column(SqlEnum(UserRole), nullable=False)


class Pairing(Base):
    """Links one guardian to one patient via a one-time invite code."""

    __tablename__ = "pairings"

    id = Column(String, primary_key=True, default=_uuid)
    invite_code = Column(String, unique=True, nullable=False, index=True)
    patient_id = Column(String, ForeignKey("users.id"), nullable=False)
    guardian_id = Column(String, ForeignKey("users.id"), nullable=True)


class FallEvent(Base):
    __tablename__ = "fall_events"

    id = Column(String, primary_key=True, default=_uuid)
    patient_id = Column(String, ForeignKey("users.id"), nullable=False)
    peak_magnitude = Column(Float, nullable=False)
    detected_at = Column(DateTime, nullable=False)


class SymptomReport(Base):
    __tablename__ = "symptom_reports"

    id = Column(String, primary_key=True, default=_uuid)
    patient_id = Column(String, ForeignKey("users.id"), nullable=False)
    symptom_text = Column(String, nullable=False)
    summary = Column(String, nullable=False)
    severity = Column(String, nullable=False)
    recommended_action = Column(String, nullable=False)
