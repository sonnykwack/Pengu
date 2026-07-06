import json

from app.services.report_generator import get_client
from tests.conftest import signup


class _FakeContentBlock:
    def __init__(self, text: str):
        self.text = text


class _FakeMessage:
    def __init__(self, text: str):
        self.content = [_FakeContentBlock(text)]


class _FakeMessages:
    def __init__(self, response_text: str):
        self._response_text = response_text

    def create(self, **kwargs):
        return _FakeMessage(self._response_text)


class _FakeAnthropicClient:
    def __init__(self, response_text: str):
        self.messages = _FakeMessages(response_text)


def test_create_symptom_report_returns_parsed_json(client):
    from app.main import app

    token = signup(client, "patient@example.com", "pw123456", "patient")

    fake_response = json.dumps(
        {
            "summary": "환자가 허리 통증을 호소함",
            "severity": "중등도",
            "recommended_action": "보호자에게 연락하고 안정을 취하게 하세요",
        }
    )
    app.dependency_overrides[get_client] = lambda: _FakeAnthropicClient(fake_response)
    try:
        response = client.post(
            "/reports/symptom",
            json={"symptom_text": "허리가 너무 아파요"},
            headers={"Authorization": f"Bearer {token}"},
        )
    finally:
        del app.dependency_overrides[get_client]

    assert response.status_code == 200, response.text
    body = response.json()
    assert body["severity"] == "중등도"
    assert "허리" in body["summary"]


def test_create_symptom_report_requires_auth(client):
    response = client.post("/reports/symptom", json={"symptom_text": "허리가 아파요"})
    assert response.status_code == 403
