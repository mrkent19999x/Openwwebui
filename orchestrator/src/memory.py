# Placeholder for session memory management
import redis
import json
import os

class SessionMemory:
    def __init__(self):
        redis_url = os.getenv("REDIS_URL", "redis://redis:6379")
        self.redis = redis.from_url(redis_url)
    
    def store(self, session_id: str, key: str, value):
        self.redis.hset(f"session:{session_id}", key, json.dumps(value))
    
    def get(self, session_id: str, key: str):
        result = self.redis.hget(f"session:{session_id}", key)
        return json.loads(result) if result else None
    
    def clear(self, session_id: str):
        self.redis.delete(f"session:{session_id}")