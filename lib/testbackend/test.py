import asyncio
import json
import secrets
import psutil
import shutil
from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect, Body
from pydantic import BaseModel
from starlette.middleware.cors import CORSMiddleware
import uvicorn
from fastapi import File, UploadFile
import os
from fastapi.responses import JSONResponse
from datetime import datetime

app = FastAPI()

origins = [
    "http://localhost",
    "http://127.0.0.1",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_DIRECTORY = os.path.join(BASE_DIR, 'uploads')
DEPLOY_DIRECTORY = os.path.join(BASE_DIR, 'deploy')

if not os.path.exists(UPLOAD_DIRECTORY):
    os.makedirs(UPLOAD_DIRECTORY)

if not os.path.exists(DEPLOY_DIRECTORY):
    os.makedirs(DEPLOY_DIRECTORY)

class LoginRequest(BaseModel):
    username: str
    password: str

sessions = {}

@app.post("/login")
async def login(request: LoginRequest):
    if request.username == "test" and request.password == "test":
        session_id = secrets.token_hex(16)
        otp = secrets.randbelow(8999) + 1000
        sessions[session_id] = otp
        return {
            "login_status": "pending",
            "id": session_id,
            "otp": str(otp),
            "message": "OTP sent"
        }
    else:
        raise HTTPException(status_code=401, detail="Invalid username or password")

@app.post("/verify_otp")
async def verify_otp(session_id: str = Body(...), otp: int = Body(...)):
    if session_id in sessions:
        expected_otp = sessions[session_id]
        if expected_otp == otp:
            del sessions[session_id]
            return {"login_status": "success", "message": "Login successful"}
        else:
            raise HTTPException(status_code=401, detail="Invalid OTP")
    else:
        raise HTTPException(status_code=404, detail="Session ID not found")

async def get_system_info():
    cpu_usage = psutil.cpu_percent(interval=1)
    total, used, free = shutil.disk_usage("/")
    cloud_usage_percentage = (used / total) * 100
    memory = psutil.virtual_memory()

    return {
        'cpu_usage': cpu_usage,
        'cloud_usage_total': f"{total / (1024.0 ** 3):.2f} GB",
        'cloud_usage_used': f"{used / (1024.0 ** 3):.2f} GB",
        'cloud_usage_percentage': cloud_usage_percentage,
        'memory_usage_total': f"{memory.total / (1024.0 ** 3):.2f} GB",
        'memory_usage_used': f"{memory.used / (1024.0 ** 3):.2f} GB",
        'memory_usage_percentage': memory.percent,
    }
@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    try:
        print(f"[DEBUG] Received file for upload: {file.filename}")
        
        # Construct file paths
        original_filename = os.path.join(UPLOAD_DIRECTORY, file.filename)
        zip_filename = f"{original_filename}.zip"
        
        # Save file in chunks
        with open(original_filename, "wb") as f:
            while chunk := await file.read(1024 * 1024):
                f.write(chunk)
        print(f"[DEBUG] File saved successfully: {original_filename}")
        
        # Rename to zip
        os.rename(original_filename, zip_filename)
        print(f"[DEBUG] File renamed to: {zip_filename}")
        
        return JSONResponse(content={"message": "Upload completed", "filename": f"{file.filename}.zip"})
    except Exception as e:
        print(f"[ERROR] Error during file upload: {e}")
        raise HTTPException(status_code=500, detail=f"File upload failed: {e}")

@app.get("/deploy/{file_name}")
async def deploy_file(file_name: str):
    try:
        # Ensure file_name does not append .zip again if it already has it
        if not file_name.endswith(".zip"):
            file_name += ".zip"
        
        file_path = os.path.join(UPLOAD_DIRECTORY, file_name)
        print(f"[DEBUG] Checking for file at: {file_path}")
        
        if not os.path.exists(file_path):
            print(f"[ERROR] File not found: {file_path}")
            raise HTTPException(status_code=404, detail="File not found in uploads folder")
        
        # Deployment folder setup
        name_without_extension = os.path.splitext(file_name)[0]
        deployment_folder = os.path.join(DEPLOY_DIRECTORY, name_without_extension)
        
        if not os.path.exists(deployment_folder):
            os.makedirs(deployment_folder)
        print(f"[DEBUG] Deployment folder created: {deployment_folder}")
        
        # Move file
        target_path = os.path.join(deployment_folder, file_name)
        shutil.move(file_path, target_path)
        print(f"[DEBUG] File moved to deployment folder: {target_path}")
        
        # Create JSON metadata
        json_data = {
            "id": secrets.token_hex(8),
            "name": name_without_extension,
            "application": f"www.{name_without_extension}",
            "listen_to": "127.0.0.1:8081",
            "real_web_s": "actual.server.ip",
            "status": "Waiting for zip",
            "init_status": True,
            "mode": "disabled",
            "timestamp": datetime.now().isoformat()
        }
        
        json_file_path = os.path.join(deployment_folder, f"{name_without_extension}.json")
        with open(json_file_path, "w") as json_file:
            json.dump(json_data, json_file, indent=4)
        print(f"[DEBUG] Metadata JSON created at: {json_file_path}")
        
        # Log creation
        log_data = {
            "file_name": file_name,
            "deployed_at": datetime.now().isoformat()
        }
        log_file_path = os.path.join(deployment_folder, "log.json")
        with open(log_file_path, "w") as log_file:
            json.dump(log_data, log_file, indent=4)
        print(f"[DEBUG] Deployment log created at: {log_file_path}")
        
        return JSONResponse(content={
            "message": "Deployment completed",
            "file": file_name,
            "deployment_folder": deployment_folder,
            "json_file": json_file_path,
            "log_file": log_file_path
        })
    except Exception as e:
        print(f"[ERROR] Error during deployment: {e}")
        raise HTTPException(status_code=500, detail=f"Deployment failed: {e}")

@app.get("/app_list")
async def app_list():
    app_data = []
    for folder_name in os.listdir(DEPLOY_DIRECTORY):
        folder_path = os.path.join(DEPLOY_DIRECTORY, folder_name)
        if os.path.isdir(folder_path):
            json_file_path = os.path.join(folder_path, f"{folder_name}.json")
            if os.path.exists(json_file_path):
                with open(json_file_path, "r") as json_file:
                    data = json.load(json_file)
                    app_data.append({
                        "name": data["name"],
                        "application": data["application"],
                        "status": data["status"],
                        "init_status": data["init_status"],
                        "timestamp": data.get("timestamp")
                    })

    return JSONResponse(content={"applications": app_data})

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    is_sending_info = False
    try:
        while True:
            message = await websocket.receive_text()
            data = json.loads(message)
            message_type = data.get("type")

            if message_type == "system_info" and not is_sending_info:
                is_sending_info = True
                while is_sending_info:
                    system_info = await get_system_info()
                    await websocket.send_text(json.dumps({"type": "system_info", "payload": system_info}))
                    await asyncio.sleep(5)

            elif message_type == "user_info":
                user_info = {"username": "test_user", "role": "admin"}
                await websocket.send_text(json.dumps({"type": "user_info", "payload": user_info}))

            elif message_type == "notification":
                notification = {"title": "New message", "content": "You have a new notification."}
                await websocket.send_text(json.dumps({"type": "notification", "payload": notification}))

    except WebSocketDisconnect:
        is_sending_info = False

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8081)
