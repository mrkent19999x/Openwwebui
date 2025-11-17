# 📁 Cấu Trúc Workspace - Open WebUI Setup

## 📋 Danh Sách Files

```
open-webui-setup/
├── 📄 README.md                          # Hướng dẫn đầy đủ, chi tiết
├── 📄 QUICKSTART.md                      # Hướng dẫn nhanh (3 bước)
├── 📄 STRUCTURE.md                       # File này - Giải thích cấu trúc
│
├── 🐳 docker-compose.yml                 # Cấu hình Docker cơ bản
├── 🐳 docker-compose.production.yml      # Cấu hình Production với Load Balancing
│
├── ⚙️ .env.example                       # Template cấu hình môi trường
├── ⚙️ nginx.conf                         # Nginx load balancer config
│
├── 🔧 start.sh                           # Script khởi chạy tự động
├── 🔧 manage.sh                          # Script quản lý (backup, logs, restart...)
│
└── 📋 .gitignore                         # Git ignore rules
```

---

## 📖 Mô Tả Chi Tiết

### 📄 **README.md**
**Mục đích:** Tài liệu chính, đầy đủ nhất

**Nội dung:**
- Giới thiệu tổng quan Open WebUI
- Yêu cầu hệ thống
- Hướng dẫn cài đặt chi tiết (Docker, GPU, etc.)
- Cấu hình realtime & performance
- Troubleshooting
- Tài liệu tham khảo

**Dùng khi:** Cần hiểu sâu về cấu hình và tính năng

---

### ⚡ **QUICKSTART.md**
**Mục đích:** Khởi chạy nhanh nhất (3 bước)

**Nội dung:**
- Bước 1: Copy .env
- Bước 2: Tạo secret key
- Bước 3: docker compose up

**Dùng khi:** Chỉ cần chạy ngay, không cần hiểu chi tiết

---

### 🐳 **docker-compose.yml**
**Mục đích:** Cấu hình Docker cho môi trường development/small team

**Services:**
- ✅ `open-webui` - WebUI chính
- ✅ `ollama` - Local LLM backend
- ⚠️ `redis` - Cache & WebSocket (optional, profile: with-redis)
- ⚠️ `chromadb` - Vector DB external (optional, profile: with-chromadb)

**Sử dụng:**
```bash
# Cơ bản
docker compose up -d

# Với Redis
docker compose --profile with-redis up -d

# Với ChromaDB
docker compose --profile with-chromadb up -d

# Tất cả
docker compose --profile with-redis --profile with-chromadb up -d
```

**Đặc điểm:**
- Đơn giản, dễ hiểu
- Phù hợp 1-20 users
- Single instance

---

### 🏭 **docker-compose.production.yml**
**Mục đích:** Cấu hình Production với Load Balancing & HA

**Services:**
- ✅ `nginx` - Load balancer
- ✅ `open-webui-1, 2, 3` - 3 instances WebUI
- ✅ `ollama-1, 2` - 2 instances Ollama với GPU
- ✅ `redis` - Required cho WebSocket sync
- ✅ `qdrant` - Vector database (production-ready)
- ⚠️ `postgres` - PostgreSQL với PGVector (optional)

**Sử dụng:**
```bash
docker compose -f docker-compose.production.yml up -d

# Với PostgreSQL
docker compose -f docker-compose.production.yml --profile with-postgres up -d
```

**Đặc điểm:**
- High availability
- Load balancing
- Phù hợp 50+ users
- Scalable

**Yêu cầu:**
- Nhiều CPU/RAM hơn
- Multiple GPUs (cho Ollama instances)
- SSL certificates (cho Nginx)

---

### ⚙️ **.env.example**
**Mục đích:** Template cho file cấu hình môi trường

**Cách dùng:**
```bash
cp .env.example .env
nano .env  # Chỉnh sửa
```

**Các section:**
1. **Cơ bản** - URL, port, tên
2. **Bảo mật** - Secret key, JWT, auth
3. **Ollama** - URL, load balancing
4. **OpenAI** - API key, base URL
5. **Performance** - Realtime, chunk size, thread pool
6. **Timeout** - AIOHTTP timeouts
7. **WebSocket** - Redis support
8. **Vector DB** - Chroma/Milvus/Qdrant config
9. **RAG** - Web search
10. **Features** - Title gen, rating, etc.
11. **Admin** - Export, chat access
12. **CORS** - Origins

**Biến QUAN TRỌNG:**
- `WEBUI_SECRET_KEY` - PHẢI thay đổi!
- `ENABLE_REALTIME_CHAT_SAVE` - False = better performance
- `OLLAMA_BASE_URL` - Kết nối Ollama
- `OPENAI_API_KEY` - Nếu dùng OpenAI

---

### 🌐 **nginx.conf**
**Mục đích:** Load balancer cho production setup

**Tính năng:**
- ✅ Load balancing 3 Open WebUI instances
- ✅ WebSocket support
- ✅ SSL/TLS (HTTPS)
- ✅ Rate limiting
- ✅ Security headers
- ✅ Static file caching
- ✅ Health check endpoint

**Cấu hình:**
- Algorithm: `least_conn` (least connection)
- Rate limit: 10 req/s general, 30 req/s API
- Timeouts: 300s (5 phút)
- Client max body: 100MB

**Cần chỉnh sửa:**
- SSL certificate paths (nếu dùng HTTPS)
- Server name
- Rate limits (tùy use case)

---

### 🔧 **start.sh**
**Mục đích:** Script khởi chạy tự động với menu

**Tính năng:**
- ✅ Check Docker installed
- ✅ Auto tạo .env từ .env.example
- ✅ Auto generate WEBUI_SECRET_KEY
- ✅ Menu chọn profile (basic, redis, chromadb, all)
- ✅ Wait & check services health

**Sử dụng:**
```bash
chmod +x start.sh
./start.sh
```

**Output:**
- Thông báo status
- URL truy cập
- Hướng dẫn xem logs

---

### 🛠️ **manage.sh**
**Mục đích:** Script quản lý toàn diện

**Menu:**
1. 📊 Xem trạng thái
2. 📋 Xem logs (all/webui/ollama)
3. 🔄 Restart services
4. 🛑 Stop/Start
5. 💾 Backup data
6. 📦 Restore data
7. 🔄 Update version
8. 🗑️ Remove all (với confirm)
9. 📊 Resource usage
10. 🧹 Docker cleanup

**Sử dụng:**
```bash
chmod +x manage.sh
./manage.sh
```

**Backup location:**
- `./backups/open-webui-TIMESTAMP.tar.gz`
- `./backups/ollama-TIMESTAMP.tar.gz`

---

### 📋 **.gitignore**
**Mục đích:** Loại trừ files không cần commit

**Excluded:**
- `.env` và variants
- `backups/` directory
- `*.log` files
- OS files (`.DS_Store`, `Thumbs.db`)
- IDE config
- Docker volumes data
- Temporary files

---

## 🎯 Quy Trình Sử Dụng

### Kịch Bản 1: Người mới bắt đầu

1. Đọc **QUICKSTART.md**
2. Chạy `./start.sh` hoặc manual:
   ```bash
   cp .env.example .env
   # Sửa WEBUI_SECRET_KEY
   docker compose up -d
   ```
3. Truy cập http://localhost:3000
4. Dùng `./manage.sh` để quản lý

---

### Kịch Bản 2: Developer/Power User

1. Đọc **README.md** đầy đủ
2. Custom `.env` theo nhu cầu
3. Chọn profile phù hợp:
   ```bash
   docker compose --profile with-redis up -d
   ```
4. Monitor với `docker stats`, logs
5. Tune performance settings

---

### Kịch Bản 3: Production Deployment

1. Đọc **README.md** section Production
2. Chuẩn bị:
   - Multiple servers/VMs
   - SSL certificates
   - Domain name
3. Chỉnh sửa:
   - `.env` với production values
   - `nginx.conf` với SSL paths
   - `docker-compose.production.yml` resource limits
4. Deploy:
   ```bash
   docker compose -f docker-compose.production.yml up -d
   ```
5. Setup monitoring (Prometheus, Grafana)
6. Regular backups với `manage.sh`

---

## 🔄 Update Workflow

### Update cấu hình:
```bash
# 1. Sửa .env
nano .env

# 2. Recreate containers
docker compose up -d --force-recreate

# Hoặc dùng manage.sh > Option 6
```

### Update Open WebUI version:
```bash
# 1. Pull image mới
docker compose pull

# 2. Recreate
docker compose up -d --force-recreate

# Hoặc dùng manage.sh > Option 11
```

### Update Docker Compose config:
```bash
# 1. Sửa docker-compose.yml
nano docker-compose.yml

# 2. Apply changes
docker compose up -d
```

---

## 💾 Backup Strategy

### Manual backup:
```bash
./manage.sh  # Option 9
```

### Automated backup (cron):
```bash
# Thêm vào crontab
crontab -e

# Backup hàng ngày lúc 2am
0 2 * * * cd /path/to/open-webui-setup && docker run --rm -v open-webui-setup_open-webui-data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/open-webui-$(date +\%Y\%m\%d).tar.gz -C /data .

# Xóa backup cũ hơn 7 ngày
0 3 * * * find /path/to/open-webui-setup/backups -name "*.tar.gz" -mtime +7 -delete
```

---

## 🆘 Troubleshooting Guide

### Không thể khởi động
```bash
# Check logs
docker compose logs

# Check disk space
df -h

# Check Docker status
docker ps -a
```

### Performance issues
```bash
# Check resource usage
docker stats

# Tune .env settings:
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=10
THREAD_POOL_SIZE=100
```

### Data corruption
```bash
# Restore from backup
./manage.sh  # Option 10
```

---

## 📚 Tài Liệu Thêm

- **README.md** - Hướng dẫn đầy đủ
- **Official Docs** - https://docs.openwebui.com/
- **GitHub** - https://github.com/open-webui/open-webui
- **Discord** - https://discord.gg/5rJgQTnV4s

---

**Tạo bởi:** MiniMax Agent  
**Ngày:** 2025-11-18  
**Version:** 1.0.0
