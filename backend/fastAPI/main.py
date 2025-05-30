from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth import auth_router
from db import client 

app = FastAPI()

# Add CORS middleware
origins = [
    "*"  
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,          
    allow_credentials=True,
    allow_methods=["*"],            
    allow_headers=["*"],            
)

app.include_router(auth_router)

@app.get("/")
async def root():
    return {"message": "Hello, FastAPI with MongoDB, ho ho!"}

@app.on_event("startup")
async def startup_event():
    try:
        
        await client.admin.command('ping')
        print("Connected to MongoDB!")
    except Exception as e:
        print("Could not connect to MongoDB:", e)
