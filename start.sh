#!/bin/bash

# Open WebUI - Quick Start Script
# Tạo bởi: MiniMax Agent

set -e

echo "========================================"
echo "  Open WebUI - Quick Start"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker chưa được cài đặt!${NC}"
    echo "Vui lòng cài đặt Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose chưa được cài đặt!${NC}"
    echo "Vui lòng cài đặt Docker Compose v2"
    exit 1
fi

echo -e "${GREEN}✅ Docker và Docker Compose đã sẵn sàng${NC}"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  File .env chưa tồn tại${NC}"
    echo "Đang tạo từ .env.example..."
    
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ Đã tạo file .env${NC}"
        
        # Generate secret key
        if command -v openssl &> /dev/null; then
            SECRET_KEY=$(openssl rand -hex 32)
            # Replace secret key in .env
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s/WEBUI_SECRET_KEY=your-secret-key-here-change-this/WEBUI_SECRET_KEY=$SECRET_KEY/" .env
            else
                sed -i "s/WEBUI_SECRET_KEY=your-secret-key-here-change-this/WEBUI_SECRET_KEY=$SECRET_KEY/" .env
            fi
            echo -e "${GREEN}✅ Đã tự động generate WEBUI_SECRET_KEY${NC}"
        else
            echo -e "${YELLOW}⚠️  Không tìm thấy openssl. Vui lòng tự tạo WEBUI_SECRET_KEY trong file .env${NC}"
        fi
    else
        echo -e "${RED}❌ Không tìm thấy .env.example${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ File .env đã tồn tại${NC}"
fi

echo ""
echo "========================================"
echo "  Chọn chế độ khởi chạy"
echo "========================================"
echo ""
echo "1) Cơ bản (Open WebUI + Ollama)"
echo "2) Với Redis (Load Balancing)"
echo "3) Với ChromaDB (External Vector DB)"
echo "4) Đầy đủ (All Services)"
echo "5) Chỉ Open WebUI (không có Ollama)"
echo ""
read -p "Nhập lựa chọn (1-5): " choice

case $choice in
    1)
        echo -e "${GREEN}Khởi chạy chế độ Cơ bản...${NC}"
        docker compose up -d
        ;;
    2)
        echo -e "${GREEN}Khởi chạy với Redis...${NC}"
        docker compose --profile with-redis up -d
        ;;
    3)
        echo -e "${GREEN}Khởi chạy với ChromaDB...${NC}"
        docker compose --profile with-chromadb up -d
        ;;
    4)
        echo -e "${GREEN}Khởi chạy tất cả services...${NC}"
        docker compose --profile with-redis --profile with-chromadb up -d
        ;;
    5)
        echo -e "${GREEN}Khởi chạy chỉ Open WebUI...${NC}"
        docker compose up -d open-webui
        ;;
    *)
        echo -e "${RED}Lựa chọn không hợp lệ!${NC}"
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo -e "${GREEN}✅ Đang khởi động...${NC}"
echo "========================================"
echo ""

# Wait for services to be healthy
echo "Đợi services khởi động..."
sleep 10

# Check if services are running
if docker compose ps | grep -q "Up"; then
    echo ""
    echo "========================================"
    echo -e "${GREEN}✅ Open WebUI đã sẵn sàng!${NC}"
    echo "========================================"
    echo ""
    echo "🌐 Truy cập: http://localhost:3000"
    echo ""
    echo "📝 Lưu ý:"
    echo "  - Tài khoản đầu tiên sẽ là Admin"
    echo "  - Các tài khoản sau cần Admin duyệt"
    echo ""
    echo "📚 Xem logs:"
    echo "  docker compose logs -f"
    echo ""
    echo "🛑 Dừng services:"
    echo "  docker compose down"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Có lỗi xảy ra khi khởi động${NC}"
    echo "Xem logs để biết chi tiết:"
    echo "  docker compose logs"
    exit 1
fi
