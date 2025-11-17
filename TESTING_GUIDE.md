# 🧪 Hướng Dẫn Test Toàn Diện - Open WebUI

**Mục đích:** Test từng chức năng realtime và verify cấu hình hoạt động đúng

---

## 📌 Chuẩn Bị Môi Trường Test

### Bước 1: Deploy Open WebUI
```bash
cd open-webui-setup
docker compose up -d
```

### Bước 2: Đợi services khởi động
```bash
# Xem logs real-time
docker compose logs -f

# Check health của từng service
docker compose ps
```

**Dấu hiệu sẵn sàng:**
- ✅ `open-webui` status: `healthy`
- ✅ `ollama` status: `running`
- ✅ `qdrant` status: `running`

### Bước 3: Truy cập Web UI
**Mở browser:** http://localhost:3000

**Lần đầu tiên:**
1. Tạo admin account (email + password)
2. Login vào hệ thống

---

## 🎯 Test 1: Streaming Chat (Realtime Response)

### Mục tiêu
Verify chat response được stream real-time với độ trễ thấp

### Các bước test

#### 1.1. Test Basic Streaming
**Trong Chat UI:**
1. Chọn model Ollama (ví dụ: `llama2`)
2. Gửi prompt: "Viết một câu chuyện dài về con mèo"
3. **Quan sát:**
   - ✅ Chữ xuất hiện từng từ một (streaming)
   - ✅ Không bị lag hoặc freeze
   - ✅ Progress indicator hiển thị

**Kiểm tra bằng Console (F12 > Network):**
```
WebSocket/EventSource connection
Status: 200
Type: text/event-stream
```

#### 1.2. Test Chunk Size Configuration
**Đang dùng:** `CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1`

**So sánh:**
| Chunk Size | Trải nghiệm |
|------------|-------------|
| 1 | Mượt nhất, từng từ | ← Đang dùng
| 5 | Từng cụm 5 từ |
| 10 | Từng cụm 10 từ |

**Để thay đổi:**
```bash
# Sửa trong .env
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=5

# Restart
docker compose restart open-webui
```

#### 1.3. Test Realtime Chat Save
**Đang dùng:** `ENABLE_REALTIME_CHAT_SAVE=False`

**Hành vi mong đợi:**
- ❌ Chat KHÔNG được lưu trong khi streaming
- ✅ Chat chỉ lưu khi response hoàn tất
- ✅ Latency thấp nhất

**Test:**
1. Gửi prompt dài
2. **Trong khi đang streaming**, mở tab mới → vào lại chat
3. **Kết quả:** Message mới CHƯA xuất hiện (vì chưa hoàn tất)

**Nếu bật `True`:**
```bash
# Sửa trong .env
ENABLE_REALTIME_CHAT_SAVE=True

# Restart
docker compose restart open-webui
```

**Test lại:**
1. Gửi prompt dài
2. Trong khi streaming, mở tab mới
3. **Kết quả:** Thấy partial message (đang lưu real-time)

---

## 🔌 Test 2: WebSocket Support (Multi-Instance)

### Chỉ áp dụng cho Production Mode

**Điều kiện:** 
- Chạy `docker-compose.production.yml`
- `ENABLE_WEBSOCKET_SUPPORT=True`
- Redis đang chạy

### Các bước test

#### 2.1. Deploy Production Mode
```bash
cd open-webui-setup
docker compose -f docker-compose.production.yml up -d
```

#### 2.2. Verify Redis Connection
```bash
# Check Redis logs
docker compose -f docker-compose.production.yml logs redis

# Test Redis ping
docker compose -f docker-compose.production.yml exec redis redis-cli ping
# Kết quả: PONG
```

#### 2.3. Test WebSocket Sync Across Instances
**Kịch bản:** User mở 2 tab browser, load balancer route đến 2 instance khác nhau

**Các bước:**
1. **Tab 1:** Login vào http://localhost
2. **Tab 2:** Login cùng account http://localhost (Ctrl+Shift+N nếu cần incognito)
3. **Tab 1:** Tạo chat mới với title "Test WebSocket"
4. **Tab 2:** Refresh → **Phải thấy chat mới**

**Kiểm tra console:**
```javascript
// F12 > Console > Network > WS
// Phải thấy WebSocket connection
ws://localhost/ws
```

#### 2.4. Test Load Balancing
**Xem logs để check instance nào xử lý:**
```bash
docker compose -f docker-compose.production.yml logs -f open-webui-1
docker compose -f docker-compose.production.yml logs -f open-webui-2
docker compose -f docker-compose.production.yml logs -f open-webui-3
```

**Gửi nhiều requests → Phải thấy cả 3 instances xử lý luân phiên**

---

## 🎤 Test 3: Voice & Audio Features

### Chuẩn bị
**Cần API key OpenAI:**
```bash
# Thêm vào .env
OPENAI_API_KEY=sk-...

# Restart
docker compose restart open-webui
```

### Các bước test

#### 3.1. Speech-to-Text (STT)
**Trong Chat UI:**
1. Click icon microphone 🎤
2. Cho phép browser truy cập micro
3. Nói: "Hello, how are you?"
4. **Kết quả:** Text xuất hiện trong chat input

**Kiểm tra Network (F12):**
```
POST /api/audio/transcriptions
Request: audio/webm hoặc audio/wav
Response: {"text": "Hello, how are you?"}
```

**Nếu lỗi:** Check logs
```bash
docker compose logs open-webui | grep -i audio
```

#### 3.2. Text-to-Speech (TTS)
**Trong Chat UI:**
1. Gửi prompt: "Tell me a joke"
2. Khi có response, click icon speaker 🔊
3. **Kết quả:** Nghe thấy giọng đọc

**Config voice đang dùng:** `AUDIO_TTS_VOICE=alloy`

**Thử các giọng khác:**
```bash
# Trong .env, thử từng giọng:
AUDIO_TTS_VOICE=alloy   # Neutral
AUDIO_TTS_VOICE=echo    # Male
AUDIO_TTS_VOICE=fable   # British accent
AUDIO_TTS_VOICE=onyx    # Deep male
AUDIO_TTS_VOICE=nova    # Female
AUDIO_TTS_VOICE=shimmer # Soft female
```

---

## 📁 Test 4: RAG & Document Processing

### Test Upload & Embed Documents

#### 4.1. Upload Document
**Trong Chat UI:**
1. Click icon paperclip 📎
2. Upload file PDF hoặc TXT
3. **Quan sát:**
   - ✅ Upload progress bar
   - ✅ File xuất hiện trong chat
   - ✅ "Processing..." indicator

#### 4.2. Verify Embedding Process
**Check logs:**
```bash
docker compose logs open-webui | grep -i embedding
docker compose logs qdrant | grep -i collection
```

**Expected logs:**
```
Embedding document with ollama...
Created collection in Qdrant
Indexed 15 chunks
```

#### 4.3. Test RAG Query
**Trong Chat UI:**
1. Sau khi upload doc, hỏi: "Summarize this document"
2. **Kết quả:** AI trả lời dựa trên nội dung doc

**Verify context được inject:**
```
F12 > Network > /api/chat
Request payload chứa:
{
  "messages": [...],
  "context": "Content from document..."
}
```

#### 4.4. Test Chunk Size
**Đang dùng:** `CHUNK_SIZE=1500`, `CHUNK_OVERLAP=100`

**Test với doc lớn:**
- File 10 pages PDF
- Mỗi page ~500 từ
- **Expected:** ~20-25 chunks

**Check trong Qdrant:**
```bash
docker compose exec qdrant curl http://localhost:6333/collections
```

---

## 🌐 Test 5: Web Search Integration

### Chuẩn bị
**Enable Web Search:**
```bash
# Trong .env
ENABLE_RAG_WEB_SEARCH=True
RAG_WEB_SEARCH_ENGINE=searxng  # hoặc google, duckduckgo

# Nếu dùng SearXNG, cần thêm service vào docker-compose
```

### Các bước test

#### 5.1. Test Search Query
**Trong Chat UI:**
1. Prompt: "Search for latest news about AI"
2. **Kết quả:** 
   - ✅ Indicator "Searching web..."
   - ✅ Response chứa thông tin từ web
   - ✅ Citations (nguồn)

#### 5.2. Test Search với RAG
**Prompt:** "Search for Python tutorial and summarize"

**Expected workflow:**
1. Search web → lấy URLs
2. Fetch content từ URLs
3. Embed content vào Qdrant
4. Generate summary từ embeddings

---

## 🎨 Test 6: Model Management

### Test Download Ollama Models

#### 6.1. List Available Models
**Trong Admin Panel:**
1. Settings > Models
2. Xem danh sách models

**Hoặc qua API:**
```bash
curl http://localhost:11434/api/tags
```

#### 6.2. Pull New Model
**Trong UI:**
1. Settings > Models > Pull Model
2. Nhập: `llama2:7b`
3. **Quan sát:** Progress bar

**Hoặc qua CLI:**
```bash
docker compose exec ollama ollama pull llama2:7b
```

**Monitor:**
```bash
docker compose logs -f ollama
```

#### 6.3. Test Model Switch
**Trong Chat:**
1. Dropdown model selector
2. Chọn model khác
3. Gửi prompt
4. **Verify:** Response từ model mới

---

## 🔐 Test 7: Authentication & Authorization

### Test OAuth Login (Optional)

**Nếu đã config Google OAuth:**
```bash
# Trong .env
ENABLE_OAUTH_SIGNUP=True
OAUTH_CLIENT_ID=your-client-id
OAUTH_CLIENT_SECRET=your-secret
```

**Test:**
1. Logout
2. Click "Sign in with Google"
3. **Kết quả:** Redirect → authorize → login thành công

### Test Role-Based Access

#### 7.1. Create Multiple Users
**Admin Panel:**
1. Settings > Users > Add User
2. Tạo user với roles: `admin`, `user`, `pending`

#### 7.2. Test Permissions
**Admin có thể:**
- ✅ Manage users
- ✅ Configure settings
- ✅ Access all chats

**User chỉ có thể:**
- ✅ Chat
- ✅ Upload docs
- ❌ Không access admin panel

---

## 📊 Test 8: Performance & Monitoring

### Test Response Time

#### 8.1. Benchmark Chat Latency
**Tools:** Browser DevTools

**Các bước:**
1. F12 > Network > Clear
2. Gửi prompt: "Hello"
3. **Đo thời gian:**
   - Time to first token: < 500ms
   - Total response time: < 5s (với llama2:7b)

#### 8.2. Test Concurrent Users
**Tools:** Artillery, k6, hoặc Apache Bench

**Example với curl:**
```bash
# Test 100 requests
for i in {1..100}; do
  curl -X POST http://localhost:3000/api/chat \
    -H "Content-Type: application/json" \
    -d '{"message":"Test"}' &
done
```

**Monitor resource:**
```bash
docker stats
```

**Expected:**
- CPU: 50-80% (khi inference)
- RAM: 4-8GB (llama2:7b)
- Network: < 100MB/s

---

## 🧹 Test 9: Backup & Recovery

### Test Backup Script

#### 9.1. Create Backup
```bash
./manage.sh backup
```

**Check:**
```bash
ls -lh backups/
# Phải thấy file: backup_YYYYMMDD_HHMMSS.tar.gz
```

#### 9.2. Test Restore
**Kịch bản:** Xóa data → restore lại

```bash
# 1. Backup hiện tại
./manage.sh backup

# 2. Stop services
docker compose down

# 3. Xóa data (CẨNTHẬN!)
rm -rf data/

# 4. Restore
./manage.sh restore backups/backup_XXXXXX.tar.gz

# 5. Start lại
docker compose up -d
```

**Verify:** Chats, users, models vẫn còn

---

## 📋 Checklist Test Tổng Hợp

### Development Mode
- [ ] **Streaming chat** hoạt động mượt
- [ ] **Model switching** không lỗi
- [ ] **Document upload** và embedding thành công
- [ ] **Voice input/output** hoạt động (nếu có API key)
- [ ] **User management** đầy đủ chức năng
- [ ] **Backup/restore** không mất data

### Production Mode
- [ ] **Load balancing** phân tán requests
- [ ] **WebSocket sync** giữa instances
- [ ] **Redis** kết nối ổn định
- [ ] **Health checks** của tất cả services
- [ ] **SSL/TLS** (nếu có)
- [ ] **Auto-restart** khi crash

### Realtime Features
- [ ] `ENABLE_REALTIME_CHAT_SAVE` hoạt động đúng
- [ ] `CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE` streaming mượt
- [ ] `ENABLE_WEBSOCKET_SUPPORT` sync đa instance
- [ ] Voice call latency < 1s
- [ ] Document embedding < 30s (file 10 pages)

---

## 🐛 Troubleshooting Common Issues

### Issue 1: Streaming bị giật lag
**Nguyên nhân:** Chunk size quá lớn hoặc network chậm

**Fix:**
```bash
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1  # Giảm xuống 1
```

### Issue 2: WebSocket không connect
**Check:**
```bash
# 1. Redis có chạy không?
docker compose ps redis

# 2. Env var đúng chưa?
grep ENABLE_WEBSOCKET_SUPPORT .env

# 3. Nginx config WebSocket?
grep -i upgrade nginx.conf
```

### Issue 3: Voice không hoạt động
**Check:**
```bash
# 1. API key đúng chưa?
grep OPENAI_API_KEY .env

# 2. Browser có quyền micro?
# Chrome > Settings > Privacy > Site settings > Microphone

# 3. Check logs
docker compose logs open-webui | grep -i audio
```

### Issue 4: Embedding quá chậm
**Nguyên nhân:** CPU embedding, không dùng GPU

**Fix:**
```bash
# Thay đổi trong .env
RAG_EMBEDDING_ENGINE=openai  # Dùng OpenAI API thay vì Ollama
OPENAI_API_KEY=sk-...
```

---

## 📊 Expected Performance Metrics

### Development Mode (Single Instance)
| Metric | Target | Cách đo |
|--------|--------|---------|
| First token latency | < 500ms | Network tab |
| Full response (100 tokens) | < 5s | Network tab |
| Document embedding (10 pages) | < 30s | Logs |
| WebUI load time | < 2s | Lighthouse |
| Memory usage | < 8GB | `docker stats` |

### Production Mode (3 Instances + LB)
| Metric | Target | Cách đo |
|--------|--------|---------|
| Load balancer overhead | < 50ms | Nginx logs |
| WebSocket sync delay | < 100ms | Console logs |
| Concurrent users | 50+ | Load testing |
| Uptime | 99.9% | Health checks |

---

## ✅ Test Sign-Off

**Khi nào coi như hoàn tất?**
- ✅ 90% checklist items PASS
- ✅ Không có critical bugs
- ✅ Performance đạt targets
- ✅ Backup/restore thành công

**Ghi chú thêm:**
- Lưu logs trong folder `logs/test_YYYYMMDD/`
- Screenshot các lỗi để debug sau
- Document các config đã thử nghiệm

---

**Prepared by:** MiniMax Agent  
**Last updated:** 2025-11-18 03:57:19
