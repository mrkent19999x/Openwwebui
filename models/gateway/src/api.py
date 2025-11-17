import os
from fastapi import FastAPI, Request
import httpx

app = FastAPI()

# Example: forward to first available cloud provider—Cursor can enrich this
PROVIDERS = ["groq", "openrouter", "gemini", "minimax", "perplexity"]

def provider_url(name:str):
    # Stub mapping; fill with your endpoints
    return {
        "groq": "https://api.groq.com/openai/v1",
        "openrouter": "https://openrouter.ai/api/v1",
        "gemini": "https://generativelanguage.googleapis.com/v1beta/openai",
        "minimax": "https://api.minimax.chat/v1",
        "perplexity": "https://api.perplexity.ai/openai/v1"
    }[name]

def provider_key(name:str):
    return os.getenv(f"{name.upper()}_API_KEY","")

@app.post("/v1/chat/completions")
async def relay(req: Request):
    body = await req.json()
    # Choose provider by simple priority if the orchestrator didn't embed one
    for p in PROVIDERS:
        key = provider_key(p)
        if not key:
            continue
        url = provider_url(p) + "/chat/completions"
        headers = {"Authorization": f"Bearer {key}"}
        async with httpx.AsyncClient(timeout=30) as client:
            r = await client.post(url, json=body, headers=headers)
            if r.status_code < 500:
                return r.json()
    return {"error": "no provider available"}