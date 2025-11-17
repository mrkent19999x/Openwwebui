import os, glob
from qdrant_client import QdrantClient
from qdrant_client.http.models import Distance, VectorParams, PointStruct
from pypdf import PdfReader

QDRANT_URL = os.getenv("QDRANT_URL","http://qdrant:6333")
client = QdrantClient(url=QDRANT_URL)

COLLECTION="docs"
if COLLECTION not in [c.name for c in client.get_collections().collections]:
    client.recreate_collection(COLLECTION, vectors_config=VectorParams(size=768, distance=Distance.COSINE))

def embed(text:str):
    # Placeholder—Cursor can swap with cloud embeddings
    return [0.0]*768

for pdf in glob.glob("/app/data/*.pdf"):
    reader = PdfReader(pdf)
    text = "\n".join(p.extract_text() or "" for p in reader.pages)
    vec = embed(text[:2000])
    client.upsert(collection_name=COLLECTION, points=[PointStruct(id=hash(pdf), vector=vec, payload={"path": pdf})])

print("Ingest complete")