# 🤖 OpenWebUI Multi-Agent AI Platform

**OpenWebUI Multi-Agent AI Platform** - Hệ thống AI toàn diện kết hợp khả năng của các nền tảng AI hàng đầu thế giới.

## 📋 Mục Lục

- [Tổng Quan](#tổng-quan)
- [Kiến Trúc Hệ Thống](#kiến-trúc-hệ-thống)
- [Tính Năng Chính](#tính-năng-chính)
- [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
- [Cài Đặt Nhanh](#cài-đặt-nhanh)
- [Agent Profiles](#agent-profiles)
- [API Integration](#api-integration)
- [Performance](#performance)
- [Code Implementation](#code-implementation)
- [Documentation](#documentation)

---

## 🎯 Tổng Quan

### OpenWebUI
**"Extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline. Supports various LLM runners like Ollama and OpenAI-compatible APIs, with built-in RAG inference engine"** - *Official OpenWebUI Documentation*

### Multi-Platform Integration
- **MiniMax AI**: Multi-modal AI agent với Text, Audio, Video, Music generation
- **Manus AI**: Complete AI agent cho workflows, task management, file management  
- **Perplexity AI**: Real-time web search với grounded search capabilities
- **Vision AI**: Low-latency real-time voice và video interactions

## 🏗️ Kiến Trúc Hệ Thống

### Core Components
- **OpenWebUI**: Self-hosted AI interface với offline operation
- **Multi-Agent Orchestrator**: Auto-routing prompts cho model phù hợp
- **Models Gateway**: OpenAI-compatible API cho multiple providers
- **Vision Realtime Engine**: Live video streaming và screen sharing
- **Search Engine**: Perplexity-powered web search với source filtering
- **RAG System**: Qdrant vector database cho document retrieval

### Supported AI Services
- **Text Generation**: MiniMax-M2, Anthropic, OpenAI, Groq, Gemini
- **Vision AI**: MiniMax Vision, Google Vision, LLaVA Cloud
- **Audio Generation**: MiniMax Speech 2.6, TTS voices
- **Video Generation**: MiniMax Hailuo 2.3, T2V models
- **Music Generation**: MiniMax Music 2.0 với lyrics support
- **Web Search**: Perplexity AI với grounded search

## ⚡ Tính Năng Chính

### 🤖 Multi-Agent Intelligence
- **Auto-Model Routing**: Tự động chọn model phù hợp theo task type
- **Task Classification**: Vision, Code, Research, Lightning, Pro profiles
- **Provider Fallback**: Automatic failover khi quota exhausted
- **Session Management**: Long-running conversations với context

### 🔍 Advanced Search
- **Real-time Web Search**: Powered by Perplexity AI
- **Grounded Search**: Với source filtering và citation
- **Structured Outputs**: JSON format cho reliable parsing
- **Multi-source Synthesis**: Tổng hợp từ multiple sources

### 🎥 Vision & Realtime
- **Live Video Streaming**: Low-latency video analysis
- **Screen Sharing**: Real-time screen capture và analysis
- **Voice Activity Detection**: Smart voice interaction
- **Ephemeral Tokens**: Secure client-side authentication

### 🎵 Multi-Modal Generation
- **Text-to-Speech**: 6 voice styles (alloy, echo, fable, onyx, nova, shimmer)
- **Image Generation**: Full editing support với subject reference
- **Video Generation**: Text-to-video với camera movement control
- **Music Creation**: Lyrics-based music generation

---

## 💻 Yêu Cầu Hệ Thống

### Tối Thiểu:
- Docker & Docker Compose v2
- 4GB RAM
- 10GB dung lượng đĩa

### Khuyến Nghị:
- 8GB+ RAM
- 20GB+ dung lượng
- GPU NVIDIA (nếu dùng local models)

---

## ⚡ Cài Đặt Nhanh

### 1. Clone hoặc tạo thư mục

```bash
mkdir open-webui-setup
cd open-webui-setup
```

### 2. Tạo file cấu hình

```bash
# Copy file .env mẫu
cp .env.example .env

# Chỉnh sửa cấu hình
nano .env  # hoặc vim, code, etc.
```

### 3. Thay đổi QUAN TRỌNG trong .env

```bash
# Tạo secret key mới (Linux/Mac)
openssl rand -hex 32

# Hoặc dùng Python
python3 -c "import secrets; print(secrets.token_hex(32))"

# Copy kết quả vào .env
WEBUI_SECRET_KEY=your-generated-key-here
```

### 4. Khởi chạy

```bash
# Chế độ cơ bản (Open WebUI + Ollama)
docker compose up -d

# Với Redis (cho load balancing)
docker compose --profile with-redis up -d

# Với ChromaDB external
docker compose --profile with-chromadb up -d

# Tất cả services
docker compose --profile with-redis --profile with-chromadb up -d
```

### 5. Truy cập

Mở trình duyệt: **http://localhost:3000**

- Tài khoản đầu tiên sẽ là **Admin**
- Các tài khoản sau sẽ **pending** (chờ admin duyệt)

---

## 🚀 Complete Code Implementation

### 🏗️ Multi-Agent Architecture

**Đã merge hoàn toàn từ `Openwwebui.txt` (518 lines)** - Complete foundation cho multi-agent OpenWebUI system:

#### **🤖 Orchestrator Brain** (`orchestrator/`)
- **FastAPI Endpoints** (`src/main.py`) - Chat completion API
- **Intent Router** (`src/router.py`) - Smart prompt classification
- **Task Executor** (`src/executor.py`) - Multi-modal task execution
- **Agent Profiles** (`src/profiles.yaml`) - 4 intelligent profiles:
  - **Lightning**: Fast Q&A (Groq/OpenRouter/Gemini, 512 tokens)
  - **Pro**: Research/Report/Code (MiniMax/Anthropic/OpenAI, 4096 tokens)
  - **Vision**: Images/PDF/Screenshots (Gemini/MiniMax Vision, 2048 tokens)
  - **Code**: PR edits (MiniMax/Claude/GPT, 2048 tokens)

#### **🔗 Models Gateway** (`models/gateway/`)
- **OpenAI-compatible API** (`src/api.py`) - Relay to multiple providers
- **Smart Provider Selection** - Auto-route based on availability
- **Fallback System** - Seamless error recovery

#### **🛠️ Tool Integration** (`orchestrator/src/tools/`)
- **🌐 Web Search** (`search.py`) - Perplexity integration
- **👁️ Vision Analysis** (`vision.py`) - Image/PDF understanding
- **📖 OCR Processing** (`ocr.py`) - Document text extraction
- **📧 Gmail API** (`gmail.py`) - Email automation
- **🐙 GitHub API** (`github.py`) - Repository operations
- **📱 Zalo OA** (`zalo_oa.py`) - Vietnamese business platform

#### **📚 RAG System** (`rag/`)
- **PDF Ingestion** (`ingest/ingest.py`) - Document processing
- **Vector Storage** - Qdrant integration
- **Embedding Pipeline** - Intelligent retrieval

#### **🌐 Reverse Proxy** (`reverse-proxy/`)
- **TLS Configuration** (`Caddyfile`) - HTTPS with certificates
- **Upload Optimization** - 100MB file support
- **Load Balancing** - Service routing

#### **⚙️ Operations** (`ops/`)
- **Makefile** - Automated deployment commands
- **Health Checks** (`smoke.sh`) - System validation
- **Backup System** (`backup.sh`) - Data protection
- **Warm-up Scripts** (`warmup.sh`) - Performance optimization

#### **🧪 Testing Framework** (`tests/`)
- **Voice Testing** - Audio processing validation
- **Vision Testing** - Image analysis verification
- **Search Testing** - Web integration validation
- **Zalo OA Testing** - Business workflow verification
- **Profile Testing** - Agent routing validation

### 🔧 Environment Configuration

**Complete API Integration**:
```bash
# Core AI Services
MINIMAX_API_KEY=        # Multi-modal AI (text, audio, video, music)
GEMINI_API_KEY=         # Vision & text processing
PERPLEXITY_API_KEY=     # Real-time web search
GROQ_API_KEY=          # Fast inference
OPENROUTER_API_KEY=    # Model marketplace

# Tools & Integrations
GMAIL_APP_PASSWORD=    # Email automation
GITHUB_TOKEN=          # Repository operations
GOOGLE_VISION_API_KEY= # OCR & image analysis
ZALO_OA_ACCESS_TOKEN=  # Vietnamese business platform
```

### 🚀 Quick Start với Complete System

```bash
# 1. Clone và setup
git clone https://github.com/mrkent19999x/Openwwebui.git
cd Openwwebui

# 2. Configure environment
cp .env.example .env
# Fill với API keys của bạn

# 3. Start complete system
make up
# hoặc: docker compose up -d

# 4. Access multi-agent interface
open https://agent.local
# Set OpenWebUI API base: https://agent.local/v1

# 5. Verify all services
make smoke
```

### 🎯 Agent Profiles in Action

**Intelligent Routing Examples**:
- User hỏi "Phân tích báo cáo này" → **Pro Profile** → MiniMax API
- User upload ảnh + "Mô tả ảnh này" → **Vision Profile** → Gemini Vision
- User hỏi code → **Code Profile** → Anthropic Claude
- User hỏi nhanh → **Lightning Profile** → Groq (nhanh nhất)

**Smart Fallbacks**: Nếu provider nào không available → auto chuyển sang provider khác

---

## ⚙️ Cấu Hình Chi Tiết

### 🔐 Bảo Mật

```bash
# .env
WEBUI_SECRET_KEY=your-secret-key-here  # PHẢI thay đổi!
WEBUI_AUTH=True                         # Bật xác thực
JWT_EXPIRES_IN=4w                       # Token hết hạn sau 4 tuần
DEFAULT_USER_ROLE=pending               # User mới cần duyệt
```

### 🎮 Ollama

```bash
# Sử dụng Ollama trong Docker
OLLAMA_BASE_URL=http://ollama:11434

# Sử dụng Ollama trên host machine
OLLAMA_BASE_URL=http://host.docker.internal:11434

# Load balancing nhiều Ollama servers
OLLAMA_BASE_URLS=http://server1:11434;http://server2:11434
```

### 🤖 OpenAI

```bash
ENABLE_OPENAI_API=True
OPENAI_API_BASE_URL=https://api.openai.com/v1
OPENAI_API_KEY=sk-your-key-here

# Nhiều API keys (auto rotate)
OPENAI_API_KEYS=sk-key1;sk-key2;sk-key3
```

### ⚡ Realtime Performance

```bash
# LƯU Ý: Đây là cấu hình quan trọng nhất cho realtime!

# 1. Tắt realtime save để giảm latency
ENABLE_REALTIME_CHAT_SAVE=False

# 2. Tăng chunk size nếu có nhiều users
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=5

# 3. Tăng thread pool
THREAD_POOL_SIZE=80  # Default: 40

# 4. Timeout hợp lý
AIOHTTP_CLIENT_TIMEOUT=300  # 5 phút
```

### 🌐 WebSocket với Redis

```bash
# Bật trong .env
ENABLE_WEBSOCKET_SUPPORT=True

# Khởi chạy với Redis
docker compose --profile with-redis up -d
```

**Lợi ích:**
- Load balancing cho nhiều instances
- Realtime updates tốt hơn
- Scalable cho production

### 🗄️ Vector Database

#### ChromaDB (Mặc định)
```bash
VECTOR_DB=chroma
CHROMA_TENANT=default_tenant
CHROMA_DATABASE=default_database
```

#### Milvus
```bash
VECTOR_DB=milvus
MILVUS_URI=http://milvus:19530
MILVUS_INDEX_TYPE=HNSW
MILVUS_METRIC_TYPE=COSINE
```

#### Qdrant
```bash
VECTOR_DB=qdrant
QDRANT_URI=http://qdrant:6333
ENABLE_QDRANT_MULTITENANCY_MODE=True
```

---

## 🎙️ Các Tính Năng Realtime

### 1. Realtime Chat Streaming

**Cấu hình đề xuất:**
```bash
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1
```

- `False`: Hiệu suất tốt, nhưng có thể mất data khi crash
- `True`: An toàn hơn, nhưng tăng latency

### 2. Voice/Video Call

**Tự động bật** - Không cần cấu hình thêm

Tính năng:
- ✅ Hands-free voice call
- ✅ Video call (với models hỗ trợ vision)
- ✅ Tap to interrupt
- ✅ Real-time TTS callback
- ✅ Emoji emotions

### 3. WebSocket Load Balancing

**Yêu cầu:** Redis service

```bash
# Khởi chạy
docker compose --profile with-redis up -d

# Cấu hình trong .env
ENABLE_WEBSOCKET_SUPPORT=True
```

**Use case:**
- Multiple Open WebUI instances
- High concurrency
- Production deployment

---

## 🎯 Các Kịch Bản Sử Dụng

### Kịch Bản 1: Development (Single User)

```bash
# .env
WEBUI_AUTH=False  # Bỏ qua login
ENABLE_REALTIME_CHAT_SAVE=False
ENABLE_SIGNUP=False
```

```bash
docker compose up -d
```

### Kịch Bản 2: Small Team (5-10 users)

```bash
# .env
WEBUI_AUTH=True
ENABLE_SIGNUP=True
DEFAULT_USER_ROLE=pending
ENABLE_REALTIME_CHAT_SAVE=False
THREAD_POOL_SIZE=60
```

```bash
docker compose up -d
```

### Kịch Bản 3: Production (50+ users)

```bash
# .env
WEBUI_AUTH=True
ENABLE_SIGNUP=True
DEFAULT_USER_ROLE=pending
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=10
THREAD_POOL_SIZE=100
ENABLE_WEBSOCKET_SUPPORT=True
```

```bash
# Khởi chạy với Redis
docker compose --profile with-redis up -d

# Scale Open WebUI instances
docker compose up -d --scale open-webui=3
```

---

## 🔧 Quản Lý

### Xem logs

```bash
# Tất cả services
docker compose logs -f

# Chỉ Open WebUI
docker compose logs -f open-webui

# Chỉ Ollama
docker compose logs -f ollama
```

### Restart services

```bash
# Restart tất cả
docker compose restart

# Restart Open WebUI
docker compose restart open-webui
```

### Stop và remove

```bash
# Stop
docker compose stop

# Remove (giữ data)
docker compose down

# Remove (xóa cả data)
docker compose down -v
```

### Update lên version mới

```bash
# Pull images mới
docker compose pull

# Recreate containers
docker compose up -d --force-recreate
```

### Backup dữ liệu

```bash
# Backup volumes
docker run --rm \
  -v open-webui-setup_open-webui-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/open-webui-backup.tar.gz -C /data .

# Backup Ollama models
docker run --rm \
  -v open-webui-setup_ollama-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/ollama-backup.tar.gz -C /data .
```

### Restore dữ liệu

```bash
# Restore Open WebUI data
docker run --rm \
  -v open-webui-setup_open-webui-data:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/open-webui-backup.tar.gz"
```

---

## 🐛 Troubleshooting

### Lỗi: "Cannot connect to Ollama"

**Giải pháp:**

```bash
# Kiểm tra Ollama đang chạy
docker compose ps ollama

# Kiểm tra logs
docker compose logs ollama

# Test kết nối
docker compose exec open-webui curl http://ollama:11434/api/tags
```

### Lỗi: "WebSocket connection failed"

**Giải pháp:**

```bash
# Kiểm tra CORS setting
CORS_ALLOW_ORIGIN=http://localhost:3000

# Hoặc allow all (development only)
CORS_ALLOW_ORIGIN=*
```

### Lỗi: "High latency / Slow responses"

**Giải pháp:**

```bash
# Tắt realtime save
ENABLE_REALTIME_CHAT_SAVE=False

# Tăng chunk size
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=10

# Tăng thread pool
THREAD_POOL_SIZE=100
```

### Lỗi: "Out of memory"

**Giải pháp:**

```bash
# Thêm memory limit trong docker-compose.yml
services:
  open-webui:
    mem_limit: 4g
  
  ollama:
    mem_limit: 8g
```

### Lỗi: "Permission denied"

**Giải pháp:**

```bash
# Fix permissions
sudo chown -R $(id -u):$(id -g) .

# Hoặc chạy với sudo
sudo docker compose up -d
```

---

## 🚀 GPU Support (NVIDIA)

### 1. Cài đặt NVIDIA Container Toolkit

```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### 2. Uncomment GPU config trong docker-compose.yml

```yaml
ollama:
  # Bỏ comment phần này
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: all
            capabilities: [gpu]
```

### 3. Hoặc dùng image CUDA cho Open WebUI

```yaml
open-webui:
  image: ghcr.io/open-webui/open-webui:cuda
  # Thêm GPU config
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: all
            capabilities: [gpu]
```

---

## 📚 Tài Liệu Tham Khảo

### Chính Thức

- **Docs:** https://docs.openwebui.com/
- **GitHub:** https://github.com/open-webui/open-webui
- **Discord:** https://discord.gg/5rJgQTnV4s
- **Reddit:** https://reddit.com/r/OpenWebUI

### Environment Variables

- **Full List:** https://docs.openwebui.com/getting-started/env-configuration/

### Features

- **All Features:** https://docs.openwebui.com/features/

### Troubleshooting

- **Official Guide:** https://docs.openwebui.com/troubleshooting/

---

## 📝 Notes

### Security Best Practices

1. ✅ Thay đổi `WEBUI_SECRET_KEY`
2. ✅ Không expose ports không cần thiết
3. ✅ Sử dụng HTTPS trong production
4. ✅ Set `CORS_ALLOW_ORIGIN` cụ thể
5. ✅ Regular backup data

### Performance Tips

1. ✅ Tắt `ENABLE_REALTIME_CHAT_SAVE` cho better latency
2. ✅ Tăng `CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE` với many users
3. ✅ Sử dụng Redis cho load balancing
4. ✅ Cache model list với `MODELS_CACHE_TTL`
5. ✅ Optimize thread pool size

### Monitoring

```bash
# Resource usage
docker stats

# Container health
docker compose ps

# Disk usage
docker system df
```

---

## 🤝 Contributing

Nếu bạn tìm thấy issues hoặc có suggestions, vui lòng:
- Open issue trên GitHub: https://github.com/open-webui/open-webui/issues
- Join Discord: https://discord.gg/5rJgQTnV4s

---

## 📄 License

Open WebUI được phát hành theo **MIT License**.

---

**Tạo bởi:** MiniMax Agent  
**Ngày:** 2025-11-18  
**Version:** 1.0.0
