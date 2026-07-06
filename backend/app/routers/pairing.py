import secrets

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..auth import get_current_user
from ..db import get_db
from ..models_db import Pairing, User, UserRole
from ..schemas import InviteCodeResponse, RedeemInput

router = APIRouter(prefix="/pairings", tags=["pairings"])


def _generate_invite_code() -> str:
    return secrets.token_hex(3).upper()


@router.post("/invite", response_model=InviteCodeResponse)
def create_invite(
    current_user: User = Depends(get_current_user), db: Session = Depends(get_db)
):
    if current_user.role != UserRole.patient:
        raise HTTPException(status_code=403, detail="환자 계정만 초대 코드를 만들 수 있습니다")

    pairing = Pairing(invite_code=_generate_invite_code(), patient_id=current_user.id)
    db.add(pairing)
    db.commit()

    return InviteCodeResponse(invite_code=pairing.invite_code)


@router.post("/redeem")
def redeem_invite(
    payload: RedeemInput,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if current_user.role != UserRole.guardian:
        raise HTTPException(status_code=403, detail="보호자 계정만 초대 코드를 사용할 수 있습니다")

    pairing = (
        db.query(Pairing)
        .filter(Pairing.invite_code == payload.invite_code, Pairing.guardian_id.is_(None))
        .first()
    )
    if pairing is None:
        raise HTTPException(status_code=404, detail="유효하지 않은 초대 코드입니다")

    pairing.guardian_id = current_user.id
    db.commit()

    return {"status": "connected"}
