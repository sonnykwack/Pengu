import os
import smtplib
from email.message import EmailMessage

SMTP_HOST = os.environ.get("SMTP_HOST")
SMTP_PORT = int(os.environ.get("SMTP_PORT", "587"))
SMTP_USER = os.environ.get("SMTP_USER")
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD")
FROM_EMAIL = os.environ.get("FROM_EMAIL", SMTP_USER)


def send_email(to: str, subject: str, body: str) -> None:
    if not SMTP_HOST:
        # SMTP가 설정되지 않은 로컬 개발/테스트 환경. 실제로 보내지 않고 콘솔에만 남깁니다.
        print(f"[email skipped: SMTP not configured] to={to} subject={subject}")
        return

    message = EmailMessage()
    message["From"] = FROM_EMAIL
    message["To"] = to
    message["Subject"] = subject
    message.set_content(body)

    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)
        server.send_message(message)
