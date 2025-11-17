# ⚡ QUICKSTART - Open WebUI

## 🚀 Khởi Chạy Ngay (3 Bước)

### Bước 1: Tạo file cấu hình
```bash
cp .env.example .env
```

### Bước 2: Tạo Secret Key
```bash
# Linux/Mac
openssl rand -hex 32

# Copy kết quả và dán vào .env tại dòng WEBUI_SECRET_KEY
```

### Bước 3: Khởi chạy
```bash
docker compose up -d
```

**Truy cập:** http://localhost:3000

---

## 📝 Hoặc Dùng Script

### Khởi chạy tự động:
```bash
chmod +x start.sh
./start.sh
```

### Quản lý:
```bash
chmod +x manage.sh
./manage.sh
```

---

## ⚙️ Cấu Hình Quan Trọng

### Trong file `.env`:

```bash
# BẮT BUỘC thay đổi
WEBUI_SECRET_KEY=your-generated-secret-key

# Realtime performance (khuyến nghị)
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1

# OpenAI (nếu dùng)
OPENAI_API_KEY=sk-your-key
```

---

## 🎯 Các Lệnh Hay Dùng

```bash
# Xem logs
docker compose logs -f

# Restart
docker compose restart

# Stop
docker compose down

# Update
docker compose pull && docker compose up -d --force-recreate

# Backup
docker run --rm \
  -v open-webui-setup_open-webui-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /data .
```

---

## 🆘 Troubleshooting

### "Cannot connect to Ollama"
```bash
# Check trong .env
OLLAMA_BASE_URL=http://ollama:11434
```

### "High latency"
```bash
# Trong .env
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=5
```

### "WebSocket failed"
```bash
# Trong .env
CORS_ALLOW_ORIGIN=*
```

---

## 📚 Đọc Thêm

Xem **README.md** để có hướng dẫn chi tiết!
