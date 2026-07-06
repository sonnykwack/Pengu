from datetime import datetime

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..auth import get_current_user
from ..db import get_db
from ..models_db import FallEvent, User
from ..notifications import notify_guardians
from ..schemas import FallEventInput

router = APIRouter(prefix="/events", tags=["events"])


@router.post("/fall")
def report_fall_event(
    payload: FallEventInput,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    db.add(
        FallEvent(
            patient_id=current_user.id,
            peak_magnitude=payload.peak_magnitude,
            detected_at=datetime.fromisoformat(payload.detected_at),
        )
    )
    db.commit()

    notify_guardians(
        db,
        current_user,
        subject="[Pengu Care] 낙상이 감지되었습니다",
        body=(
            f"{current_user.email}님에게서 낙상이 감지되었습니다.\n"
            f"감지 시각: {payload.detected_at}\n"
            f"충격 강도: {payload.peak_magnitude:.1f}"
        ),
    )
    return {"status": "recorded"}
