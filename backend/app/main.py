from contextlib import asynccontextmanager

from fastapi import FastAPI

from .db import Base, engine
from .routers import auth, events, pairing, reports


@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(title="Pengu Care Backend", lifespan=lifespan)

app.include_router(auth.router)
app.include_router(pairing.router)
app.include_router(events.router)
app.include_router(reports.router)


@app.get("/")
def root():
    return {"message": "Pengu backend is running"}


@app.get("/health")
def health():
    return {"status": "ok"}
