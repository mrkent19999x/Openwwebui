import asyncio
from .tools.search import web_search
from .tools.ocr import ocr_extract
from .tools.vision import analyze_image
from .tools.gmail import send_mail
from .tools.github import create_pr

async def execute_task(prompt, intent, provider, attachments):
    if intent == "vision" and attachments:
        ocr_text = []
        for path in attachments:
            ocr_text.append(ocr_extract(path))
        vision_summary = analyze_image(prompt, attachments, "\n".join(ocr_text))
        return {"ocr": ocr_text, "vision": vision_summary}

    if intent == "pro":
        sources = web_search(prompt)
        # Cursor can expand into multi-source synthesis with citations
        return {"summary": f"Tổng hợp theo {provider}", "sources": sources}

    if intent == "code":
        # Placeholder—Cursor can implement real code ops
        pr_url = create_pr("repo", "branch", "Automated change", "diff ...")
        return {"pr": pr_url}

    # lightning default
    return {"answer": f"{provider} trả lời nhanh cho: {prompt[:64]}..."}