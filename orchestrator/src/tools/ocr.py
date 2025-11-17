# Placeholder for OCR functionality
import pytesseract
from PIL import Image
import os

def ocr_extract(image_path: str) -> str:
    # OCR using Tesseract or Google Vision API
    api_key = os.getenv("GOOGLE_VISION_API_KEY")
    
    try:
        image = Image.open(image_path)
        text = pytesseract.image_to_string(image, lang='vie+eng')
        return text.strip()
    except Exception as e:
        return f"OCR Error: {str(e)}"