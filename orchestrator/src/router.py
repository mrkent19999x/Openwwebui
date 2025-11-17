import os, time
from typing import Dict
from .memory import SessionMemory
from .tools.search import web_search
from .tools.vision import analyze_image
from .tools.ocr import ocr_extract

# Simple intent classifier by keywords; Cursor can expand to LLM
INTENTS = {
    "vision": ["image", "ảnh", "screenshot", "pdf", "scan"],
    "code": ["code", "pr", "bug", "repo"],
    "pro": ["báo cáo", "research", "phân tích", "định hướng"],
    "lightning": []
}

def classify(prompt:str, attachments:list[str]) -> str:
    if attachments:
        return "vision"
    p = prompt.lower()
    for intent, keys in INTENTS.items():
        if any(k in p for k in keys):
            return intent
    return "lightning"

def pick_provider(intent:str, profiles:Dict, quotas:Dict, latency_targets:Dict):
    providers = profiles[intent]["providers"]
    # Choose first provider with quota; Cursor can replace with smarter policy
    for p in providers:
        if quotas.get(p, 1) > 0:
            return p
    return providers[0]

def route(prompt:str, attachments:list[str], profiles, quotas):
    intent = classify(prompt, attachments)
    provider = pick_provider(intent, profiles, quotas, {})
    return intent, provider