# 📖 Giải Thích Project Cho Anh Nghĩa

## 🎯 MỤC ĐÍCH PROJECT LÀ GÌ?

**Project này giống như một "trợ lý AI thông minh" có thể:**
- ✅ Nói chuyện với nhiều AI khác nhau (như có nhiều người trợ lý)
- ✅ Tự động chọn AI phù hợp nhất cho từng câu hỏi
- ✅ Xử lý được nhiều thứ: text, ảnh, PDF, giọng nói, video
- ✅ Tìm kiếm thông tin trên web
- ✅ Làm việc với email, GitHub, Zalo OA

**Ví dụ thực tế:**
- Anh hỏi "Thời tiết hôm nay?" → Hệ thống tự động chọn AI nhanh nhất (Groq) để trả lời ngay
- Anh gửi ảnh và hỏi "Đây là gì?" → Hệ thống tự động chọn AI xử lý ảnh (Gemini Vision)
- Anh hỏi "Phân tích báo cáo này" → Hệ thống chọn AI mạnh nhất (MiniMax) để phân tích chi tiết

---

## 🔄 LUỒNG CHẠY CỦA CODE NHƯ THẾ NÀO?

### **Luồng chạy đơn giản (giống như quy trình làm việc):**

```
1. Người dùng gửi câu hỏi
   ↓
2. Orchestrator nhận câu hỏi
   ↓
3. Router phân tích: "Câu hỏi này thuộc loại gì?"
   ↓
4. Chọn AI phù hợp: "Dùng AI nào để trả lời?"
   ↓
5. Executor thực hiện: Gọi AI và xử lý
   ↓
6. Trả kết quả về cho người dùng
```

### **Chi tiết từng bước:**

#### **BƯỚC 1: Người dùng gửi câu hỏi**
- Người dùng mở trình duyệt, vào http://localhost:3000
- Gõ câu hỏi hoặc upload file (ảnh, PDF...)
- Open WebUI nhận yêu cầu

#### **BƯỚC 2: Orchestrator nhận yêu cầu**
**File:** `orchestrator/src/main.py`
- Nhận câu hỏi từ Open WebUI
- Nếu có file đính kèm → lưu vào thư mục tạm
- Gọi hàm `route()` để phân tích

#### **BƯỚC 3: Router phân tích câu hỏi**
**File:** `orchestrator/src/router.py`

**Cách phân tích (giống như phân loại thư):**
- Nếu có file đính kèm (ảnh, PDF) → **"vision"** (xử lý ảnh)
- Nếu có từ "code", "pr", "bug" → **"code"** (xử lý code)
- Nếu có từ "báo cáo", "research", "phân tích" → **"pro"** (nghiên cứu chuyên sâu)
- Còn lại → **"lightning"** (trả lời nhanh)

**Ví dụ:**
- Câu hỏi: "Phân tích báo cáo này" → Loại: **"pro"**
- Câu hỏi: "Đây là ảnh gì?" (có file) → Loại: **"vision"**
- Câu hỏi: "Thời tiết hôm nay?" → Loại: **"lightning"**

#### **BƯỚC 4: Chọn AI phù hợp**
**File:** `orchestrator/src/profiles.yaml`

**Mỗi loại câu hỏi có danh sách AI phù hợp:**

| Loại | AI được dùng | Mục đích |
|------|--------------|----------|
| **lightning** | Groq, OpenRouter, Gemini | Trả lời nhanh, câu hỏi đơn giản |
| **pro** | MiniMax, Anthropic, OpenAI | Nghiên cứu, phân tích, báo cáo |
| **vision** | Gemini Vision, MiniMax Vision | Xử lý ảnh, PDF, screenshot |
| **code** | MiniMax, Anthropic, OpenAI | Viết code, sửa bug, PR |

**Cách chọn:**
- Xem AI nào còn quota (chưa hết lượt)
- Chọn AI đầu tiên trong danh sách còn quota
- Nếu hết → chuyển sang AI tiếp theo (fallback)

#### **BƯỚC 5: Executor thực hiện**
**File:** `orchestrator/src/executor.py`

**Tùy loại câu hỏi, sẽ làm khác nhau:**

**Nếu là "vision" (xử lý ảnh):**
1. Dùng OCR để đọc chữ trong ảnh/PDF
2. Dùng Vision AI để phân tích ảnh
3. Trả về: text đã đọc + mô tả ảnh

**Nếu là "pro" (nghiên cứu):**
1. Gọi web_search() để tìm thông tin trên web
2. Tổng hợp thông tin từ nhiều nguồn
3. Trả về: tóm tắt + danh sách nguồn

**Nếu là "code":**
1. Xử lý code (ví dụ: tạo PR trên GitHub)
2. Trả về: link PR hoặc kết quả

**Nếu là "lightning":**
1. Gọi AI nhanh nhất để trả lời
2. Trả về: câu trả lời ngắn gọn

#### **BƯỚC 6: Trả kết quả**
- Kết quả được gửi về Open WebUI
- Hiển thị cho người dùng trên trình duyệt

---

## 📁 CẤU TRÚC CODE (Review Nhanh)

### **1. Orchestrator (`orchestrator/`) - Bộ não của hệ thống**

```
orchestrator/
├── src/
│   ├── main.py          ← Điểm vào chính, nhận request từ Open WebUI
│   ├── router.py        ← Phân tích câu hỏi, chọn loại (vision/code/pro/lightning)
│   ├── executor.py      ← Thực hiện công việc (gọi AI, xử lý)
│   ├── memory.py        ← Lưu trữ lịch sử chat (session memory)
│   ├── profiles.yaml    ← Cấu hình: loại nào dùng AI nào
│   └── tools/           ← Các công cụ hỗ trợ
│       ├── search.py    ← Tìm kiếm web (Perplexity)
│       ├── vision.py    ← Phân tích ảnh
│       ├── ocr.py       ← Đọc chữ trong ảnh/PDF
│       ├── gmail.py     ← Gửi email
│       ├── github.py    ← Làm việc với GitHub
│       └── zalo_oa.py   ← Tích hợp Zalo OA
```

**Giải thích đơn giản:**
- `main.py`: Như người tiếp khách, nhận yêu cầu
- `router.py`: Như người phân loại, quyết định loại công việc
- `executor.py`: Như người thực hiện, làm việc cụ thể
- `tools/`: Như các công cụ hỗ trợ (kính lúp, máy ảnh, email...)

### **2. Models Gateway (`models/gateway/`) - Cổng kết nối AI**

```
models/gateway/
└── src/
    └── api.py    ← API tương thích OpenAI, chuyển tiếp đến các AI khác
```

**Giải thích đơn giản:**
- Giống như một "cổng chuyển tiếp"
- Nhận yêu cầu từ Orchestrator
- Chuyển đến AI phù hợp (Groq, MiniMax, OpenAI...)
- Nếu AI này lỗi → tự động chuyển sang AI khác

### **3. RAG System (`rag/`) - Hệ thống tìm kiếm tài liệu**

```
rag/
└── ingest/
    └── ingest.py    ← Xử lý PDF, tạo vector database để tìm kiếm
```

**Giải thích đơn giản:**
- Giống như thư viện thông minh
- Upload PDF → hệ thống đọc và lưu vào database
- Khi hỏi → tìm trong database và trả về đoạn liên quan

### **4. Docker Compose - Cấu hình chạy hệ thống**

**File:** `docker-compose.yml`

**Các service (dịch vụ) chạy:**
1. **open-webui**: Giao diện web (như cửa hàng mặt tiền)
2. **ollama**: AI chạy local (như máy tính riêng)
3. **redis**: Cache và WebSocket (tùy chọn, cho nhiều người dùng)
4. **chromadb**: Database lưu vector (tùy chọn)

**Giải thích đơn giản:**
- Docker Compose giống như "bản vẽ xây nhà"
- Mỗi service là một "phòng" trong nhà
- Khi chạy `docker compose up` → xây cả ngôi nhà cùng lúc

---

## 🔍 ĐIỂM MẠNH CỦA CODE

### ✅ **1. Tự động chọn AI phù hợp**
- Không cần người dùng chọn AI nào
- Hệ thống tự phân tích và chọn tốt nhất

### ✅ **2. Có fallback (dự phòng)**
- Nếu AI này lỗi → tự động chuyển sang AI khác
- Đảm bảo luôn có câu trả lời

### ✅ **3. Hỗ trợ nhiều loại công việc**
- Text, ảnh, PDF, code, nghiên cứu...
- Mỗi loại có cách xử lý riêng

### ✅ **4. Dễ mở rộng**
- Thêm AI mới → chỉ cần thêm vào `profiles.yaml`
- Thêm công cụ mới → thêm file trong `tools/`

---

## ⚠️ ĐIỂM CẦN CẢI THIỆN

### 🔧 **1. Router đơn giản quá**
**Hiện tại:** Chỉ dựa vào từ khóa
```python
if "ảnh" in prompt:
    return "vision"
```

**Nên cải thiện:** Dùng AI để phân tích câu hỏi chính xác hơn
- Ví dụ: "Bạn có thể mô tả hình ảnh này không?" → Cũng là vision nhưng không có từ "ảnh"

### 🔧 **2. Chưa có xử lý lỗi chi tiết**
**Hiện tại:** Nếu lỗi → trả về error message đơn giản

**Nên cải thiện:** 
- Log lỗi chi tiết để debug
- Retry tự động khi lỗi tạm thời
- Thông báo lỗi thân thiện cho người dùng

### 🔧 **3. Chưa có monitoring**
**Hiện tại:** Không biết AI nào đang dùng nhiều, chậm ở đâu

**Nên cải thiện:**
- Dashboard để xem: AI nào được dùng nhiều nhất
- Thời gian phản hồi của từng AI
- Số lượng request mỗi ngày

### 🔧 **4. Chưa có rate limiting**
**Hiện tại:** Người dùng có thể gửi request không giới hạn

**Nên cải thiện:**
- Giới hạn số request mỗi phút/giờ
- Tránh spam và tốn tiền API

---

## 📊 TÓM TẮT LUỒNG CHẠY (Sơ đồ đơn giản)

```
┌─────────────┐
│  Người dùng │
│  (Browser)  │
└──────┬──────┘
       │ Gửi câu hỏi
       ↓
┌─────────────────┐
│   Open WebUI    │  ← Giao diện web
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Orchestrator  │  ← Nhận request
│   (main.py)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│     Router      │  ← Phân tích: "Loại gì?"
│  (router.py)    │     - vision? code? pro? lightning?
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Pick Provider │  ← Chọn AI: "Dùng AI nào?"
│  (profiles.yaml)│     - Groq? MiniMax? Gemini?
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Executor     │  ← Thực hiện: Gọi AI + xử lý
│  (executor.py)  │     - OCR? Search? Vision?
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Models Gateway │  ← Chuyển tiếp đến AI
│   (api.py)      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  AI Providers   │  ← Groq, MiniMax, OpenAI...
│  (External API) │
└────────┬────────┘
         │
         ↓ Trả kết quả
┌─────────────────┐
│   Open WebUI    │  ← Hiển thị cho người dùng
└─────────────────┘
```

---

## 🎓 KẾT LUẬN CHO ANH NGHĨA

### **Project này làm gì?**
Một hệ thống AI thông minh tự động chọn AI phù hợp để trả lời câu hỏi của người dùng.

### **Code chạy như thế nào?**
1. Nhận câu hỏi
2. Phân tích loại câu hỏi
3. Chọn AI phù hợp
4. Thực hiện và trả kết quả

### **Có gì đặc biệt?**
- ✅ Tự động, không cần người dùng chọn AI
- ✅ Hỗ trợ nhiều loại: text, ảnh, PDF, code...
- ✅ Có dự phòng nếu AI lỗi
- ✅ Dễ mở rộng thêm AI mới

### **Cần cải thiện gì?**
- 🔧 Router thông minh hơn (dùng AI để phân tích)
- 🔧 Xử lý lỗi tốt hơn
- 🔧 Monitoring để theo dõi hiệu suất
- 🔧 Rate limiting để tránh spam

---

**Tạo bởi:** Cipher (Trợ lý của anh Nghĩa)  
**Ngày:** 2025-01-27  
**Mục đích:** Giải thích đơn giản cho anh Nghĩa hiểu project
