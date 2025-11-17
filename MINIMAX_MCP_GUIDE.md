# 🎯 Hướng Dẫn Config MiniMax MCP (Model Context Protocol)

**Tài liệu chính thức từ MiniMax Platform**  
**Cập nhật:** 2025-11-18 04:13:44

---

## 📌 MCP là gì?

**Model Context Protocol (MCP)** là giao thức mở chuẩn hóa cách ứng dụng cung cấp context cho LLM. Nó hoạt động như một cổng USB-C cho AI - cho phép LLM truy cập databases, APIs, plugins, và các công cụ khác một cách ổn định.

**MiniMax MCP** cung cấp các công cụ đa phương tiện:
- 🎤 **Text-to-Speech (TTS)** - Chuyển text thành giọng nói tự nhiên
- 🔊 **Voice Cloning** - Nhân bản giọng nói từ audio
- 🎨 **Voice Design** - Tạo giọng nói từ mô tả text
- 🖼️ **Image Generation** - Tạo ảnh từ prompt
- 🎬 **Video Generation** - Tạo video từ prompt hoặc ảnh
- 🎵 **Music Generation** - Tạo nhạc từ prompt và lyrics

---

## 🔑 Bước 1: Lấy API Key

### 1.1. Truy cập MiniMax Platform

**Global (Quốc tế):**
```
https://www.minimax.io/platform/user-center/basic-information/interface-key
```

**Mainland China:**
```
https://platform.minimaxi.com/user-center/basic-information/interface-key
```

### 1.2. Tạo API Key

1. Click nút **"Create new secret key"**
2. Nhập tên project
3. **Copy và lưu API key ngay** (chỉ hiện 1 lần!)

### 1.3. Lưu ý quan trọng ⚠️

**API Host và Key phải cùng region:**

| Region | API Host | API Key Source |
|--------|----------|----------------|
| **Global** | `https://api.minimax.io` | https://www.minimax.io/platform |
| **Mainland** | `https://api.minimaxi.com` | https://platform.minimaxi.com |

**Nếu không match → Lỗi "Invalid API key"**

---

## 📦 Bước 2: Chọn MCP Version

MiniMax cung cấp 2 implementations:

### Option 1: Python Version (minimax-mcp)

**Ưu điểm:**
- ✅ Chính thức, được maintain tốt
- ✅ Dễ cài đặt với `uvx`
- ✅ Hỗ trợ stdio và SSE transport

**Phù hợp cho:**
- Claude Desktop
- Cursor
- Windsurf
- Cherry Studio

### Option 2: JavaScript Version (minimax-mcp-js)

**Ưu điểm:**
- ✅ Hỗ trợ nhiều transport modes (stdio, SSE, REST)
- ✅ Flexible configuration
- ✅ Node.js ecosystem

**Phù hợp cho:**
- Web applications
- Node.js projects
- MCP platforms (ModelScope, etc.)

---

## 🐍 Cách 1: Config MiniMax MCP (Python)

### Bước 2.1: Cài đặt uvx

**macOS / Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows:**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Verify:**
```bash
# macOS/Linux
which uvx

# Windows
(Get-Command uvx).source
```

### Bước 2.2: Config cho Claude Desktop

**Mở file config:**
```
Claude > Settings > Developer > Edit Config > claude_desktop_config.json
```

**Thêm config:**
```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-mcp"],
      "env": {
        "MINIMAX_API_KEY": "sk-xxxxxxxxxxxxxxxxxxxxxxxx",
        "MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop",
        "MINIMAX_API_HOST": "https://api.minimax.io",
        "MINIMAX_API_RESOURCE_MODE": "url"
      }
    }
  }
}
```

**Giải thích từng field:**

| Field | Giá trị | Mô tả |
|-------|---------|-------|
| `command` | `uvx` hoặc absolute path | Lệnh chạy MCP server |
| `args` | `["minimax-mcp"]` | Arguments |
| `MINIMAX_API_KEY` | API key của bạn | **Bắt buộc** |
| `MINIMAX_MCP_BASE_PATH` | `/path/to/output` | Nơi lưu file output |
| `MINIMAX_API_HOST` | `https://api.minimax.io` | Global hoặc Mainland |
| `MINIMAX_API_RESOURCE_MODE` | `url` hoặc `local` | Cách expose resources |

**Resource Mode:**
- `url` (default): Trả về URL của file
- `local`: Download file về local path

**Restart Claude Desktop để apply!**

### Bước 2.3: Config cho Cursor

**Mở MCP config:**
```
Cursor -> Preferences -> Cursor Settings -> MCP -> Add new global MCP Server
```

**File location:** `mcp.json`

**Config:**
```json
{
  "mcpServers": {
    "MiniMax": {
      "command": "uvx",
      "args": ["minimax-mcp"],
      "env": {
        "MINIMAX_API_KEY": "sk-xxxxxxxxxxxxxxxxxxxxxxxx",
        "MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop",
        "MINIMAX_API_HOST": "https://api.minimax.io",
        "MINIMAX_API_RESOURCE_MODE": "url"
      }
    }
  }
}
```

**Save và restart Cursor!**

### Bước 2.4: Config cho Cherry Studio

**Mở Cherry Studio:**
```
Settings -> MCP Settings -> Add Server -> Import from JSON
```

**Config:**
```json
{
  "name": "minimax-mcp",
  "isActive": true,
  "command": "uvx",
  "args": ["minimax-mcp"],
  "env": {
    "MINIMAX_API_KEY": "sk-xxxxxxxxxxxxxxxxxxxxxxxx",
    "MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop",
    "MINIMAX_API_HOST": "https://api.minimax.io",
    "MINIMAX_API_RESOURCE_MODE": "url"
  }
}
```

**Trong chat panel:**
- Click "MCP Settings"
- Select "MiniMax MCP"
- Bắt đầu sử dụng!

---

## 🟨 Cách 2: Config MiniMax MCP-JS (JavaScript)

### Bước 2.1: Cài đặt Node.js

**Download từ:**
```
https://nodejs.org/en/download
```

**Verify:**
```bash
node -v
npm -v
```

### Bước 2.2: Config cho Claude Desktop

**File:** `claude_desktop_config.json`

```json
{
  "mcpServers": {
    "minimax-mcp-js": {
      "command": "npx",
      "args": ["-y", "minimax-mcp-js"],
      "env": {
        "MINIMAX_API_HOST": "https://api.minimax.io",
        "MINIMAX_API_KEY": "sk-xxxxxxxxxxxxxxxxxxxxxxxx",
        "MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop",
        "MINIMAX_RESOURCE_MODE": "url"
      },
      "transport": "studio"
    }
  }
}
```

**Transport modes:**
- `studio` (default): Standard stdio
- `REST`: HTTP-based
- `SSE`: Server-sent events

### Bước 2.3: Config cho Cursor

**File:** `mcp.json`

```json
{
  "mcpServers": {
    "MiniMax-MCP-JS": {
      "command": "npx",
      "args": ["-y", "minimax-mcp-js"],
      "env": {
        "MINIMAX_API_KEY": "sk-xxxxxxxxxxxxxxxxxxxxxxxx",
        "MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop",
        "MINIMAX_API_HOST": "https://api.minimax.io",
        "MINIMAX_API_RESOURCE_MODE": "url"
      },
      "transport": "studio"
    }
  }
}
```

### Bước 2.4: Dùng như Node.js module

**Install:**
```bash
pnpm add minimax-mcp-js
# hoặc
npm install minimax-mcp-js
```

**Code:**
```javascript
import { startMiniMaxMCP } from 'minimax-mcp-js';

await startMiniMaxMCP({
  apiKey: 'sk-xxxxxxxxxxxxxxxxxxxxxxxx',
  apiHost: 'https://api.minimax.io',
  basePath: '/path/to/output',
  resourceMode: 'url'
});
```

### Bước 2.5: Dùng CLI

**Install globally:**
```bash
pnpm install -g minimax-mcp-js
```

**Run:**
```bash
minimax-mcp-js \
  --api-key sk-xxxxxxxxxxxxxxxxxxxxxxxx \
  --api-host https://api.minimax.io \
  --base-path /Users/yourname/Desktop \
  --resource-mode url
```

### Bước 2.6: Environment Variables

**Tạo file `.env`:**
```env
MINIMAX_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxx
MINIMAX_MCP_BASE_PATH=~/Desktop
MINIMAX_API_HOST=https://api.minimax.io
MINIMAX_RESOURCE_MODE=url
```

**Configuration Priority (từ cao xuống thấp):**
1. Request parameters (`meta.auth` trong API call)
2. Command line arguments
3. Environment variables
4. Config file
5. Default values

---

## 🎯 Bước 3: Sử Dụng MCP Tools

### 3.1. Text-to-Speech (TTS)

**Prompt example:**
```
Choose a suitable voice and broadcast a segment of the evening news.
```

**MiniMax sẽ:**
1. List available voices
2. Chọn voice phù hợp (ví dụ: `female-shaonv`)
3. Generate audio từ text
4. Trả về file hoặc URL

**Parameters:**
- `text`: Nội dung (max 10,000 ký tự)
- `voice_id`: ID giọng nói (default: `female-shaonv`)
- `model`: `speech-02-hd`, `speech-02-turbo`, v.v.
- `speed`: Tốc độ [0.5, 2.0]
- `emotion`: `happy`, `sad`, `angry`, `calm`, v.v.
- `format`: `mp3`, `wav`, `flac`, `pcm`

### 3.2. Voice Cloning

**Prompt example:**
```
Clone the voice from the audio file named Marketing_Voice.wav, 
the ID is custom_voice_001.
```

**MiniMax sẽ:**
1. Đọc file audio
2. Clone voice
3. Tạo voice ID
4. Generate demo audio

**Parameters:**
- `voice_id`: ID cho voice mới (8-256 ký tự, unique)
- `file`: Audio file (mp3, m4a, wav)
- `text`: Demo text (max 2000 ký tự)
- `is_url`: File là URL hay local?

### 3.3. Voice Design

**Prompt example:**
```
Design a voice with requirement: "Mysterious narrator with a deep, 
magnetic voice, suspenseful tone, moderate pace, subtle reverb". 
Use sample text: "In the shadows of the old manor, secrets whisper 
through the walls. Beware what you seek…"
```

**MiniMax sẽ:**
1. Tạo voice từ mô tả
2. Generate preview audio với sample text
3. Trả về voice ID và audio

**Parameters:**
- `prompt`: Mô tả voice cần tạo
- `preview_text`: Text để tạo preview
- `voice_id`: Custom ID (optional, auto-gen nếu không có)

### 3.4. Image Generation

**Prompt example:**
```
Generate a hyperreal style picture: "Ultra-detailed digital painting 
of a serene mountain lake at sunrise, ultra-realistic, soft golden 
light, mist over the water"
```

**Parameters:**
- `prompt`: Mô tả ảnh (max 1500 ký tự)
- `model`: `image-01`, `image-01-live`
- `aspect_ratio`: `1:1`, `16:9`, `4:3`, `3:2`, `9:16`, v.v.
- `n`: Số lượng ảnh [1, 9]
- `prompt_optimizer`: Auto-optimize prompt (True/False)

### 3.5. Video Generation

**Prompt example:**
```
From the existing image of a kitten perched on a diving board, 
create a short video showing the kitten crouching, leaping off 
into the pool, and making a small splash. Use MiniMax-Hailuo-02 
model, resolution 1080P.
```

**Parameters:**
- `prompt`: Mô tả video (max 2000 ký tự)
- `model`: `MiniMax-Hailuo-02`, `T2V-01`, `I2V-01`, v.v.
- `first_frame_image`: Ảnh đầu tiên (Base64 hoặc URL)
- `duration`: 6 hoặc 10 giây
- `resolution`: `512P`, `768P`, `1080P` (tùy model)
- `async_mode`: True = trả task_id, False = đợi hoàn tất

**Model comparison:**

| Model | Duration | Resolution | Use case |
|-------|----------|------------|----------|
| MiniMax-Hailuo-02 | 6s, 10s | 512P, 768P, 1080P | High quality, latest |
| T2V-01 | 6s | 720P | Text-to-video |
| I2V-01 | 6s | 720P | Image-to-video |

### 3.6. Music Generation

**Prompt example:**
```
Generate a song with gentle ambient piano and warm pad synth, 
soft reverb and subtle field recordings of wind chimes. 
Musical style: calm and reflective. 
Lyrics: 'In the stillness of the midnight air, 
Find the echoes of dreams we share. 
Softly drifting 'neath pale moonlight, 
Whispering hearts drifting into night.'
```

**Parameters:**
- `prompt`: Style, mood, scene (10-300 ký tự)
- `lyrics`: Lời bài hát với structure markers (10-600 ký tự)
- `sample_rate`: 16000, 24000, 32000, 44100
- `format`: `mp3`, `wav`, `pcm`

**Lyrics structure:**
```
[Intro]
In the stillness of the midnight air,

[Verse]
Find the echoes of dreams we share.
Softly drifting 'neath pale moonlight,

[Chorus]
Whispering hearts drifting into night.

[Outro]
...
```

---

## 🔧 Troubleshooting

### Issue 1: "Invalid API key"

**Nguyên nhân:** API key và host không cùng region

**Fix:**
```json
// Global key → Global host
"MINIMAX_API_HOST": "https://api.minimax.io"

// Mainland key → Mainland host
"MINIMAX_API_HOST": "https://api.minimaxi.com"
```

### Issue 2: "spawn uvx ENOENT"

**Nguyên nhân:** uvx chưa cài hoặc không trong PATH

**Fix:**
```bash
# Tìm absolute path
which uvx
# Output: /usr/local/bin/uvx

# Update config
"command": "/usr/local/bin/uvx"
```

### Issue 3: Path không tồn tại

**Nguyên nhân:** `MINIMAX_MCP_BASE_PATH` không tồn tại

**Fix:**
```bash
# Tạo folder trước
mkdir -p ~/Desktop/minimax-output

# Config
"MINIMAX_MCP_BASE_PATH": "/Users/yourname/Desktop/minimax-output"
```

### Issue 4: Permission denied

**Nguyên nhân:** Không có quyền write vào folder

**Fix:**
```bash
# Check permissions
ls -la ~/Desktop

# Fix permissions
chmod 755 ~/Desktop/minimax-output
```

### Issue 5: Video generation quá lâu

**Giải pháp:** Dùng async mode

```javascript
// Async mode
{
  "async_mode": true
}

// MiniMax trả về task_id ngay
// Sau đó query result:
query_video_generation(task_id)
```

---

## 🎨 Use Cases & Examples

### Use Case 1: AI Voice Assistant

**Workflow:**
1. User nói → STT → text
2. LLM xử lý → response text
3. **MiniMax TTS** → audio
4. Play audio cho user

**Config:**
```json
{
  "tool": "text_to_audio",
  "voice_id": "female-shaonv",
  "model": "speech-02-hd",
  "emotion": "happy",
  "speed": 1.2
}
```

### Use Case 2: Content Marketing

**Workflow:**
1. Generate script với LLM
2. **MiniMax Voice Clone** → brand voice
3. **MiniMax TTS** → narration
4. **MiniMax Video** → promotional video
5. Export & publish

### Use Case 3: Podcast Generator

**Workflow:**
1. Input: Topic + outline
2. LLM generate script
3. **MiniMax Voice Design** → tạo 2 host voices
4. **MiniMax TTS** → generate dialogue
5. **MiniMax Music** → background music
6. Mix audio → export podcast

### Use Case 4: Educational Videos

**Workflow:**
1. LLM generate lesson content
2. **MiniMax Image** → diagrams & illustrations
3. **MiniMax Video** → animations
4. **MiniMax TTS** → voiceover
5. Combine → educational video

---

## 📊 Pricing & Limits

**Lưu ý:** Sử dụng MCP tools **có thể phát sinh chi phí**

**Check pricing:**
- Global: https://www.minimax.io/platform/pricing
- Mainland: https://platform.minimaxi.com/pricing

**Limits:**
- Text-to-Speech: Max 10,000 ký tự/request
- Voice Clone: File < 50MB
- Image Generation: Max 9 ảnh/request
- Video: Max 2000 ký tự prompt
- Music: Max 600 ký tự lyrics

---

## 🔗 Resources

### Official Links
- **MiniMax Platform:** https://www.minimax.io/platform
- **MCP Guide:** https://platform.minimax.io/docs/guides/mcp-guide
- **GitHub Python:** https://github.com/MiniMax-AI/MiniMax-MCP
- **GitHub JS:** https://github.com/MiniMax-AI/MiniMax-MCP-JS
- **MiniMax Search:** https://github.com/MiniMax-AI/minimax_search
- **Mini-Agent:** https://github.com/MiniMax-AI/Mini-Agent

### Community
- **Discord:** Check MiniMax website
- **GitHub Issues:** Report bugs, request features
- **WeChat:** QR code on GitHub repo

### Related Tools
- **Claude Desktop:** https://claude.ai/download
- **Cursor:** https://cursor.com/
- **Cherry Studio:** https://www.cherry-ai.com/
- **Windsurf:** https://codeium.com/windsurf

---

## ✅ Quick Start Checklist

### Setup Checklist
- [ ] Đã có API key từ MiniMax Platform
- [ ] Verify API key và host cùng region
- [ ] Cài đặt uvx (Python) hoặc Node.js (JS)
- [ ] Chọn MCP client (Claude, Cursor, etc.)
- [ ] Config file đã tạo đúng format
- [ ] Base path tồn tại và có quyền write
- [ ] Restart MCP client

### Test Checklist
- [ ] List voices → verify connection
- [ ] Generate simple TTS → verify output
- [ ] Test image generation
- [ ] Test video generation (async mode nếu chậm)
- [ ] Check output files trong base_path

---

## 🚀 Next Steps

**Sau khi config xong:**

1. **Experiment với tools:**
   - Thử từng tool để hiểu capabilities
   - Test với different parameters
   - Save best configurations

2. **Integrate vào workflow:**
   - Build automation scripts
   - Chain multiple tools
   - Create templates

3. **Optimize costs:**
   - Cache generated assets
   - Use appropriate models
   - Batch requests khi có thể

4. **Contribute:**
   - Report bugs trên GitHub
   - Share use cases
   - Contribute code/docs

---

**Prepared by:** MiniMax Agent  
**Based on:** Official MiniMax MCP Documentation  
**Last updated:** 2025-11-18 04:13:44  
**Version:** 1.0
