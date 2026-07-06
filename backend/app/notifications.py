from sqlalchemy.orm import Session

from .models_db import Pairing, User
from .services.email_sender import send_email


def notify_guardians(db: Session, patient: User, subject: str, body: str) -> None:
    pairings = (
        db.query(Pairing)
        .filter(Pairing.patient_id == patient.id, Pairing.guardian_id.isnot(None))
        .all()
    )
    for pairing in pairings:
        guardian = db.get(User, pairing.guardian_id)
        if guardian:
            send_email(guardian.email, subject, body)
