from tests.conftest import signup


def test_signup_then_login(client):
    signup(client, "patient@example.com", "pw123456", "patient")

    response = client.post(
        "/auth/login", json={"email": "patient@example.com", "password": "pw123456"}
    )
    assert response.status_code == 200
    assert response.json()["role"] == "patient"


def test_signup_rejects_duplicate_email(client):
    signup(client, "patient@example.com", "pw123456", "patient")

    response = client.post(
        "/auth/signup",
        json={"email": "patient@example.com", "password": "pw123456", "role": "patient"},
    )
    assert response.status_code == 400


def test_login_rejects_wrong_password(client):
    signup(client, "patient@example.com", "pw123456", "patient")

    response = client.post(
        "/auth/login", json={"email": "patient@example.com", "password": "wrong"}
    )
    assert response.status_code == 401
