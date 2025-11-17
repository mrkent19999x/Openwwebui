# 🚀 Deployment Checklist - Open WebUI

**Hướng dẫn deploy từng bước cho Development và Production mode**

---

## 📋 Chọn Mode Deploy

| Mode | Phù hợp cho | Resources | Độ phức tạp |
|------|-------------|-----------|-------------|
| **Development** | 1-20 users, testing, cá nhân | 4GB RAM, 2 CPU | ⭐ Dễ |
| **Production** | 50+ users, enterprise | 16GB RAM, 8 CPU, GPU (khuyến nghị) | ⭐⭐⭐ Cao |

**→ Nếu mới bắt đầu:** Chọn Development  
**→ Nếu cần scale:** Chọn Production

---

# 🟢 DEVELOPMENT MODE DEPLOYMENT

## Bước 1: Chuẩn Bị Môi Trường

### 1.1. Kiểm tra hệ điều hành
```bash
uname -a
# Hỗ trợ: Linux, macOS, Windows (WSL2)
```

### 1.2. Cài đặt Docker
**Ubuntu/Debian:**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
# Logout và login lại
```

**macOS:**
```bash
# Download Docker Desktop từ docker.com
# Hoặc dùng Homebrew:
brew install --cask docker
```

**Windows:**
- Cài WSL2: `wsl --install`
- Cài Docker Desktop for Windows

### 1.3. Verify Docker
```bash
docker --version
# Kết quả: Docker version 24.x.x

docker compose version
# Kết quả: Docker Compose version v2.x.x
```

### 1.4. Check disk space
```bash
df -h
# Cần: ít nhất 20GB trống
```

---

## Bước 2: Cấu Hình Files

### 2.1. Tạo file .env
```bash
cd open-webui-setup
cp .env.example .env
```

### 2.2. Generate secret key
```bash
openssl rand -hex 32
# Copy output
```

### 2.3. Sửa file .env
```bash
nano .env
# Hoặc dùng editor khác: vim, code, etc.
```

**Tìm dòng:**
```env
WEBUI_SECRET_KEY=your-secret-key-here
```

**Thay bằng key vừa generate:**
```env
WEBUI_SECRET_KEY=4180490aa7fbb41bd3634c0397b91f3e366ac6b370793e46f5712c2509b49a71
```

### 2.4. (Optional) Cấu hình thêm

**Nếu có OpenAI API key:**
```env
OPENAI_API_KEY=sk-proj-...
```

**Nếu muốn web search:**
```env
ENABLE_RAG_WEB_SEARCH=True
RAG_WEB_SEARCH_ENGINE=duckduckgo
```

**Nếu muốn Google OAuth:**
```env
ENABLE_OAUTH_SIGNUP=True
OAUTH_CLIENT_ID=your-google-client-id
OAUTH_CLIENT_SECRET=your-google-secret
```

---

## Bước 3: Khởi Động Services

### 3.1. Pull Docker images
```bash
docker compose pull
```

**Thời gian:** 5-10 phút (tùy tốc độ mạng)  
**Dung lượng download:** ~5GB

### 3.2. Start services
```bash
docker compose up -d
```

**Expected output:**
```
[+] Running 4/4
 ✔ Network open-webui-network     Created
 ✔ Container open-webui-qdrant    Started
 ✔ Container open-webui-ollama    Started
 ✔ Container open-webui           Started
```

### 3.3. Xem logs khởi động
```bash
docker compose logs -f
```

**Dấu hiệu thành công:**
```
open-webui  | INFO: Application startup complete
open-webui  | INFO: Uvicorn running on http://0.0.0.0:8080
ollama      | Listening on 0.0.0.0:11434
qdrant      | Qdrant gRPC listening on 6334
```

**Nhấn Ctrl+C để thoát logs**

---

## Bước 4: Truy Cập & Setup

### 4.1. Mở browser
```
http://localhost:3000
```

**Nếu truy cập từ máy khác trong LAN:**
```
http://192.168.x.x:3000
# Thay IP bằng IP máy đang chạy Docker
```

### 4.2. Tạo Admin Account (Lần đầu tiên)
**Form đăng ký sẽ xuất hiện:**
- Email: admin@example.com
- Password: Tối thiểu 8 ký tự
- Confirm Password

**Lưu ý:** Account đầu tiên tự động là Admin!

### 4.3. Download Ollama Models
**Sau khi login:**
1. Click Settings (góc trên phải)
2. Tab "Models"
3. Trong "Pull a model" nhập: `llama2:7b`
4. Click Download

**Hoặc dùng CLI:**
```bash
docker compose exec ollama ollama pull llama2:7b
```

**Thời gian:** 5-10 phút (model ~4GB)

**Các models khuyến nghị:**
- `llama2:7b` - Tổng quát, nhanh (4GB)
- `mistral:7b` - Coding, technical (4GB)
- `codellama:7b` - Chuyên code (4GB)
- `llama2:13b` - Chất lượng cao hơn (7GB)

---

## Bước 5: Test Hoạt Động

### 5.1. Test Chat
1. Click "New Chat"
2. Chọn model `llama2:7b`
3. Gửi: "Hello, how are you?"
4. **Kết quả:** Phải thấy response streaming

### 5.2. Test Document Upload
1. Click icon 📎
2. Upload file PDF hoặc TXT
3. Hỏi: "Summarize this document"
4. **Kết quả:** AI summarize dựa trên content

### 5.3. Check Health
```bash
curl http://localhost:3000/health
# Kết quả: {"status":"ok"}

curl http://localhost:11434/api/tags
# Kết quả: Danh sách models
```

---

## Bước 6: Quản Lý & Bảo Trì

### 6.1. Stop services
```bash
docker compose stop
```

### 6.2. Start lại
```bash
docker compose start
```

### 6.3. Restart (khi thay đổi .env)
```bash
docker compose restart
```

### 6.4. Xem logs
```bash
# Tất cả services
docker compose logs

# Chỉ Open WebUI
docker compose logs open-webui

# Follow real-time
docker compose logs -f
```

### 6.5. Backup data
```bash
./manage.sh backup
# Hoặc thủ công:
tar -czf backup.tar.gz data/
```

### 6.6. Update lên version mới
```bash
./manage.sh update
# Hoặc thủ công:
docker compose pull
docker compose up -d
```

---

## ✅ Checklist Development Mode

- [ ] Docker & Docker Compose đã cài đặt
- [ ] File .env đã tạo và config WEBUI_SECRET_KEY
- [ ] Port 3000, 11434, 6333 không bị chiếm
- [ ] Có ít nhất 20GB disk trống
- [ ] `docker compose pull` thành công
- [ ] `docker compose up -d` thành công
- [ ] Truy cập http://localhost:3000 được
- [ ] Tạo admin account thành công
- [ ] Download ít nhất 1 Ollama model
- [ ] Test chat streaming hoạt động
- [ ] Test upload document hoạt động
- [ ] Backup script hoạt động

---

# 🔴 PRODUCTION MODE DEPLOYMENT

## Bước 1: Chuẩn Bị Hạ Tầng

### 1.1. Server Requirements
**Minimum:**
- CPU: 8 cores
- RAM: 16GB
- Disk: 100GB SSD
- GPU: NVIDIA (khuyến nghị, không bắt buộc)

**Recommended:**
- CPU: 16 cores
- RAM: 32GB
- Disk: 500GB NVMe SSD
- GPU: NVIDIA RTX 3090 / A100

### 1.2. Kiểm tra GPU (nếu có)
```bash
nvidia-smi
# Phải thấy GPU info
```

**Nếu chưa có NVIDIA drivers:**
```bash
# Ubuntu
sudo apt install nvidia-driver-525 nvidia-docker2
sudo systemctl restart docker
```

### 1.3. Domain & DNS (nếu public)
**Setup DNS records:**
```
A Record: openwebui.yourdomain.com → Server IP
```

**Verify:**
```bash
ping openwebui.yourdomain.com
```

---

## Bước 2: SSL/TLS Certificates

### 2.1. Dùng Let's Encrypt
```bash
sudo apt install certbot

# Generate cert
sudo certbot certonly --standalone -d openwebui.yourdomain.com
```

**Certificates sẽ ở:**
```
/etc/letsencrypt/live/openwebui.yourdomain.com/fullchain.pem
/etc/letsencrypt/live/openwebui.yourdomain.com/privkey.pem
```

### 2.2. Update nginx.conf
```nginx
server {
    listen 443 ssl http2;
    server_name openwebui.yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/openwebui.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/openwebui.yourdomain.com/privkey.pem;
    
    # ... rest of config
}
```

### 2.3. Mount certificates vào Docker
**Thêm vào nginx service trong docker-compose.production.yml:**
```yaml
nginx:
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf:ro
    - /etc/letsencrypt:/etc/letsencrypt:ro  # ← Thêm dòng này
```

---

## Bước 3: Cấu Hình Production

### 3.1. Tạo .env từ template
```bash
cp .env.example .env
nano .env
```

### 3.2. Cấu hình Critical Settings

**Secret key:**
```env
WEBUI_SECRET_KEY=$(openssl rand -hex 32)
```

**Enable WebSocket:**
```env
ENABLE_WEBSOCKET_SUPPORT=True
ENABLE_REALTIME_CHAT_SAVE=True  # Nếu cần collaborative editing
```

**Redis:**
```env
REDIS_HOST=redis
REDIS_PORT=6379
```

**Performance tuning:**
```env
# Workers (2 * CPU cores + 1)
WORKERS=17  # Với 8 cores

# Chunk size cho streaming
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1
```

**Security:**
```env
# Chỉ cho phép trusted domains
CORS_ALLOW_ORIGIN=https://openwebui.yourdomain.com

# Rate limiting
RATE_LIMIT_ENABLED=True
RATE_LIMIT_MAX_REQUESTS=100
RATE_LIMIT_WINDOW=60
```

### 3.3. Review docker-compose.production.yml

**Check replicas:**
```yaml
open-webui-1:
  # Instance 1
open-webui-2:
  # Instance 2
open-webui-3:
  # Instance 3
```

**GPU config (nếu có):**
```yaml
ollama-gpu-1:
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            device_ids: ['0']  # GPU 0
            capabilities: [gpu]

ollama-gpu-2:
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            device_ids: ['1']  # GPU 1 (nếu có)
            capabilities: [gpu]
```

---

## Bước 4: Deploy Production Stack

### 4.1. Pull images
```bash
docker compose -f docker-compose.production.yml pull
```

### 4.2. Start stack
```bash
docker compose -f docker-compose.production.yml up -d
```

**Expected output:**
```
[+] Running 8/8
 ✔ Container open-webui-redis       Started
 ✔ Container open-webui-qdrant      Started
 ✔ Container open-webui-ollama-1    Started
 ✔ Container open-webui-ollama-2    Started
 ✔ Container open-webui-1           Started
 ✔ Container open-webui-2           Started
 ✔ Container open-webui-3           Started
 ✔ Container open-webui-nginx       Started
```

### 4.3. Monitor startup
```bash
# Watch all logs
docker compose -f docker-compose.production.yml logs -f

# Check specific services
docker compose -f docker-compose.production.yml logs nginx
docker compose -f docker-compose.production.yml logs redis
```

---

## Bước 5: Verify Production Setup

### 5.1. Check health của từng service
```bash
docker compose -f docker-compose.production.yml ps
```

**Tất cả phải `healthy` hoặc `running`**

### 5.2. Test load balancer
```bash
# Test HTTP
curl http://localhost/health

# Test HTTPS (nếu có)
curl https://openwebui.yourdomain.com/health
```

### 5.3. Test WebSocket
**Mở browser console (F12):**
```javascript
// Phải thấy WebSocket connection
ws://localhost/ws
hoặc
wss://openwebui.yourdomain.com/ws
```

### 5.4. Test Redis
```bash
docker compose -f docker-compose.production.yml exec redis redis-cli ping
# Kết quả: PONG
```

### 5.5. Test Load Distribution
**Gửi nhiều requests và xem logs:**
```bash
# Terminal 1
docker compose -f docker-compose.production.yml logs -f open-webui-1

# Terminal 2
docker compose -f docker-compose.production.yml logs -f open-webui-2

# Terminal 3
docker compose -f docker-compose.production.yml logs -f open-webui-3

# Terminal 4: Gửi requests
for i in {1..30}; do
  curl http://localhost/health
  sleep 0.5
done
```

**Kết quả:** Phải thấy cả 3 instances xử lý requests

---

## Bước 6: Monitoring & Alerting

### 6.1. Setup logging
```bash
# Tạo thư mục logs
mkdir -p logs

# Cấu hình log rotation
sudo nano /etc/logrotate.d/openwebui
```

**Nội dung:**
```
/workspace/open-webui-setup/logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 root root
}
```

### 6.2. Resource monitoring
```bash
# Install monitoring tools
docker stats

# Hoặc dùng Prometheus + Grafana (advanced)
```

### 6.3. Health check script
**Tạo file `health-check.sh`:**
```bash
#!/bin/bash
SERVICES=(
  "http://localhost/health"
  "http://localhost:6333/health"
  "http://localhost:11434/api/tags"
)

for service in "${SERVICES[@]}"; do
  if curl -sf "$service" > /dev/null; then
    echo "✅ $service OK"
  else
    echo "❌ $service FAILED"
    # Send alert (email, Slack, etc.)
  fi
done
```

**Thêm vào cron:**
```bash
chmod +x health-check.sh
crontab -e

# Chạy mỗi 5 phút
*/5 * * * * /workspace/open-webui-setup/health-check.sh
```

---

## Bước 7: Backup Strategy

### 7.1. Automated backup
**Tạo script backup định kỳ:**
```bash
crontab -e

# Backup hàng ngày lúc 2AM
0 2 * * * cd /workspace/open-webui-setup && ./manage.sh backup

# Cleanup backups cũ hơn 30 ngày
0 3 * * * find /workspace/open-webui-setup/backups -mtime +30 -delete
```

### 7.2. Off-site backup
```bash
# Upload backup lên cloud (AWS S3 example)
aws s3 sync backups/ s3://your-bucket/openwebui-backups/

# Hoặc rsync đến remote server
rsync -avz backups/ user@backup-server:/backups/openwebui/
```

---

## Bước 8: Security Hardening

### 8.1. Firewall rules
```bash
# Ubuntu UFW
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp  # SSH
sudo ufw enable

# Block direct access to internal ports
sudo ufw deny 11434
sudo ufw deny 6333
```

### 8.2. Fail2ban (anti bruteforce)
```bash
sudo apt install fail2ban

# Configure filter for Open WebUI
sudo nano /etc/fail2ban/filter.d/openwebui.conf
```

### 8.3. Rate limiting (đã có trong nginx.conf)
**Verify trong nginx.conf:**
```nginx
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
limit_req zone=api_limit burst=20 nodelay;
```

---

## Bước 9: Update & Rollback Plan

### 9.1. Update procedure
```bash
# 1. Backup trước
./manage.sh backup

# 2. Pull images mới
docker compose -f docker-compose.production.yml pull

# 3. Rolling update (từng instance một)
docker compose -f docker-compose.production.yml up -d --no-deps --build open-webui-1
# Đợi healthy
docker compose -f docker-compose.production.yml up -d --no-deps --build open-webui-2
docker compose -f docker-compose.production.yml up -d --no-deps --build open-webui-3
```

### 9.2. Rollback plan
```bash
# Tag image hiện tại trước khi update
docker tag ghcr.io/open-webui/open-webui:main openwebui:backup-$(date +%Y%m%d)

# Nếu cần rollback
docker compose -f docker-compose.production.yml down
# Sửa docker-compose.yml: image: openwebui:backup-YYYYMMDD
docker compose -f docker-compose.production.yml up -d
```

---

## ✅ Checklist Production Mode

### Pre-deployment
- [ ] Server đủ resources (CPU, RAM, Disk)
- [ ] GPU drivers + nvidia-docker (nếu có GPU)
- [ ] Domain đã point đến server
- [ ] SSL certificates đã generate
- [ ] File .env đã config đầy đủ
- [ ] ENABLE_WEBSOCKET_SUPPORT=True
- [ ] Redis service trong docker-compose
- [ ] nginx.conf đã review

### Deployment
- [ ] `docker compose -f docker-compose.production.yml pull` OK
- [ ] `docker compose -f docker-compose.production.yml up -d` OK
- [ ] Tất cả 8 services đều healthy
- [ ] Truy cập https://domain OK
- [ ] WebSocket connection OK
- [ ] Redis ping OK
- [ ] Load balancing hoạt động (requests phân tán)

### Post-deployment
- [ ] Monitoring setup (logs, stats)
- [ ] Health check script + cron
- [ ] Backup automation
- [ ] Firewall configured
- [ ] Rate limiting enabled
- [ ] SSL auto-renewal (certbot renew)
- [ ] Documentation cập nhật
- [ ] Team training

### Performance
- [ ] First token latency < 500ms
- [ ] Handle 50+ concurrent users
- [ ] CPU usage < 80%
- [ ] Memory usage < 90%
- [ ] Disk I/O không bottleneck
- [ ] Uptime > 99.5%

---

## 🆘 Troubleshooting Production

### Issue: Service không start
```bash
# Check logs chi tiết
docker compose -f docker-compose.production.yml logs service-name

# Check resource
docker stats

# Check disk space
df -h
```

### Issue: Load balancer không phân tán
```bash
# Check nginx config
docker compose -f docker-compose.production.yml exec nginx nginx -t

# Reload nginx
docker compose -f docker-compose.production.yml exec nginx nginx -s reload

# Check upstream health
docker compose -f docker-compose.production.yml logs nginx | grep upstream
```

### Issue: WebSocket disconnect liên tục
```bash
# Check Redis
docker compose -f docker-compose.production.yml logs redis

# Check WebSocket config
grep ENABLE_WEBSOCKET .env

# Increase timeout trong nginx.conf
proxy_read_timeout 300s;
proxy_connect_timeout 300s;
```

### Issue: OOM (Out of Memory)
```bash
# Check memory usage
docker stats

# Giảm số workers trong .env
WORKERS=9  # Thay vì 17

# Restart services
docker compose -f docker-compose.production.yml restart
```

---

## 📞 Support & Resources

**Documentation:**
- Official: https://docs.openwebui.com
- GitHub: https://github.com/open-webui/open-webui

**Community:**
- Discord: https://discord.gg/openwebui
- Reddit: r/OpenWebUI

**Emergency contacts:**
- System admin: [your-email]
- On-call engineer: [phone]

---

**Prepared by:** MiniMax Agent  
**Version:** 1.0  
**Last updated:** 2025-11-18 03:57:19
