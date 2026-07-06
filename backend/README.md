# backend

서버 프로그램 (Python + FastAPI).

- `GET /health` : 서버가 살아있는지 확인
- `POST /auth/signup`, `POST /auth/login` : 회원가입/로그인 (환자·보호자 역할 구분)
- `POST /pairings/invite` : (환자) 보호자 초대 코드 생성
- `POST /pairings/redeem` : (보호자) 초대 코드로 환자와 연결
- `POST /events/fall` : (환자) 낙상 이벤트 기록 → 연결된 보호자에게 이메일 발송
- `POST /reports/symptom` : (환자) 증상 텍스트 → Claude API로 리포트 생성 → 연결된 보호자에게 이메일 발송

데이터는 `backend/pengu.db`라는 SQLite 파일에 저장됩니다 (자동 생성, git에는 올라가지 않음).

## 환경 변수

| 변수 | 설명 |
|---|---|
| `ANTHROPIC_API_KEY` | 증상 리포트 생성에 필요 (console.anthropic.com에서 발급) |
| `JWT_SECRET` | 로그인 토큰 서명에 쓰는 비밀 키. 배포할 때는 반드시 임의의 긴 문자열로 바꿔주세요 |
| `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`, `FROM_EMAIL` | 이메일 발송 설정. 비워두면 실제로 보내지 않고 콘솔에만 로그를 남깁니다 (로컬 개발용) |

로컬에서 실행할 때:

```bash
export ANTHROPIC_API_KEY=여기에_본인_키_입력
```

## 지금 당장은 실행 안 해도 됩니다

이 서버는 Claude가 클라우드 세션 안에서 이미 실행해서 검증했습니다. 나중에 본인 컴퓨터에서
직접 실행해보고 싶을 때를 위해 방법을 남겨둡니다 (Python 3.11+ 필요):

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate   # 윈도우는: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

브라우저에서 http://localhost:8000 접속하면 `{"message": "Pengu backend is running"}` 이 보이면 성공.
