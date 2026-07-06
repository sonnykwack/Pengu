from fastapi import FastAPI

app = FastAPI(title="Pengu Care Backend")


@app.get("/")
def root():
    return {"message": "Pengu backend is running"}


@app.get("/health")
def health():
    return {"status": "ok"}
