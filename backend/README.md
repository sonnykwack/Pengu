# backend

서버 프로그램 (Python + FastAPI). 지금은 "서버가 살아있는지" 확인하는 최소 기능만 있습니다.

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
