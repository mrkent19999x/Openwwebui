import os, json
import yaml
from fastapi import FastAPI, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from .router import route
from .memory import SessionMemory
from .tools.search import web_search
from .tools.ocr import ocr_extract
from .tools.vision import analyze_image
from .tools.zalo_oa import handle_webhook
from .executor import execute_task

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

with open(os.path.join(os.path.dirname(__file__), "profiles.yaml")) as f:
    profiles = yaml.safe_load(f)["profiles"]
quotas = {k: 1 for k in ["groq","openrouter","gemini","minimax","anthropic","openai","gemini_vision","llava_cloud","minimax_vision"]}

@app.post("/v1/chat/completions")
async def completions(prompt: str = Form(...), files: list[UploadFile] | None = None):
    attachments = []
    if files:
        for f in files:
            content = await f.read()
            path = f"/tmp/{f.filename}"
            with open(path, "wb") as out:
                out.write(content)
            attachments.append(path)

    intent, provider = route(prompt, attachments, profiles, quotas)
    result = await execute_task(prompt, intent, provider, attachments)
    return {"intent": intent, "provider": provider, "result": result}