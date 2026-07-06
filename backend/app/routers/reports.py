from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..auth import get_current_user
from ..db import get_db
from ..models_db import SymptomReport, User
from ..notifications import notify_guardians
from ..schemas import SymptomInput
from ..services.report_generator import generate_report, get_client

router = APIRouter(prefix="/reports", tags=["reports"])


@router.post("/symptom")
def create_symptom_report(
    payload: SymptomInput,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    client=Depends(get_client),
):
    report = generate_report(payload.symptom_text, client=client)

    db.add(
        SymptomReport(
            patient_id=current_user.id,
            symptom_text=payload.symptom_text,
            summary=report["summary"],
            severity=report["severity"],
            recommended_action=report["recommended_action"],
        )
    )
    db.commit()

    notify_guardians(
        db,
        current_user,
        subject=f"[Pengu Care] 증상 리포트 ({report['severity']})",
        body=(
            f"{current_user.email}님이 증상을 입력했습니다.\n\n"
            f"요약: {report['summary']}\n"
            f"심각도: {report['severity']}\n"
            f"권장 조치: {report['recommended_action']}"
        ),
    )
    return report
