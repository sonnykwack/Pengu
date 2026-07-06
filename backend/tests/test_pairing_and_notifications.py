from datetime import datetime, timezone
from unittest.mock import patch

from tests.conftest import signup


def _pair_patient_and_guardian(client):
    patient_token = signup(client, "patient@example.com", "pw123456", "patient")
    guardian_token = signup(client, "guardian@example.com", "pw123456", "guardian")

    invite_response = client.post(
        "/pairings/invite", headers={"Authorization": f"Bearer {patient_token}"}
    )
    assert invite_response.status_code == 200
    invite_code = invite_response.json()["invite_code"]

    redeem_response = client.post(
        "/pairings/redeem",
        json={"invite_code": invite_code},
        headers={"Authorization": f"Bearer {guardian_token}"},
    )
    assert redeem_response.status_code == 200

    return patient_token, guardian_token


def test_guardian_can_redeem_patient_invite_code(client):
    _pair_patient_and_guardian(client)


def test_redeeming_unknown_code_fails(client):
    guardian_token = signup(client, "guardian@example.com", "pw123456", "guardian")

    response = client.post(
        "/pairings/redeem",
        json={"invite_code": "NOPE00"},
        headers={"Authorization": f"Bearer {guardian_token}"},
    )
    assert response.status_code == 404


def test_fall_event_notifies_paired_guardian(client):
    patient_token, _ = _pair_patient_and_guardian(client)

    with patch("app.notifications.send_email") as mock_send_email:
        response = client.post(
            "/events/fall",
            json={
                "peak_magnitude": 30.5,
                "detected_at": datetime.now(timezone.utc).isoformat(),
            },
            headers={"Authorization": f"Bearer {patient_token}"},
        )

    assert response.status_code == 200
    mock_send_email.assert_called_once()
    called_to = mock_send_email.call_args.args[0]
    assert called_to == "guardian@example.com"
