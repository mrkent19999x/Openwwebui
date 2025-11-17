#!/bin/bash

# Open WebUI - Management Scripts
# Tạo bởi: MiniMax Agent

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_menu() {
    echo ""
    echo "========================================"
    echo "  Open WebUI - Management"
    echo "========================================"
    echo ""
    echo "1)  📊 Xem trạng thái services"
    echo "2)  📋 Xem logs (tất cả)"
    echo "3)  📋 Xem logs (Open WebUI)"
    echo "4)  📋 Xem logs (Ollama)"
    echo "5)  🔄 Restart services"
    echo "6)  🔄 Restart Open WebUI"
    echo "7)  🛑 Stop services"
    echo "8)  ▶️  Start services"
    echo "9)  💾 Backup dữ liệu"
    echo "10) 📦 Restore dữ liệu"
    echo "11) 🔄 Update lên version mới"
    echo "12) 🗑️  Xóa tất cả (bao gồm data)"
    echo "13) 📊 Xem resource usage"
    echo "14) 🧹 Dọn dẹp Docker"
    echo "0)  ❌ Thoát"
    echo ""
}

check_docker() {
    if ! docker compose ps &> /dev/null; then
        echo -e "${RED}❌ Không thể kết nối với Docker${NC}"
        exit 1
    fi
}

status() {
    echo -e "${BLUE}📊 Trạng thái services:${NC}"
    docker compose ps
}

logs_all() {
    echo -e "${BLUE}📋 Logs (tất cả services):${NC}"
    docker compose logs -f
}

logs_webui() {
    echo -e "${BLUE}📋 Logs (Open WebUI):${NC}"
    docker compose logs -f open-webui
}

logs_ollama() {
    echo -e "${BLUE}📋 Logs (Ollama):${NC}"
    docker compose logs -f ollama
}

restart_all() {
    echo -e "${YELLOW}🔄 Đang restart tất cả services...${NC}"
    docker compose restart
    echo -e "${GREEN}✅ Đã restart xong!${NC}"
}

restart_webui() {
    echo -e "${YELLOW}🔄 Đang restart Open WebUI...${NC}"
    docker compose restart open-webui
    echo -e "${GREEN}✅ Đã restart xong!${NC}"
}

stop_services() {
    echo -e "${YELLOW}🛑 Đang dừng services...${NC}"
    docker compose stop
    echo -e "${GREEN}✅ Đã dừng!${NC}"
}

start_services() {
    echo -e "${YELLOW}▶️  Đang khởi động services...${NC}"
    docker compose up -d
    echo -e "${GREEN}✅ Đã khởi động!${NC}"
}

backup_data() {
    echo -e "${BLUE}💾 Backup dữ liệu${NC}"
    BACKUP_DIR="./backups"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    mkdir -p "$BACKUP_DIR"
    
    echo "Đang backup Open WebUI data..."
    docker run --rm \
        -v open-webui-setup_open-webui-data:/data \
        -v "$(pwd)/$BACKUP_DIR":/backup \
        alpine tar czf "/backup/open-webui-${TIMESTAMP}.tar.gz" -C /data .
    
    echo "Đang backup Ollama models..."
    docker run --rm \
        -v open-webui-setup_ollama-data:/data \
        -v "$(pwd)/$BACKUP_DIR":/backup \
        alpine tar czf "/backup/ollama-${TIMESTAMP}.tar.gz" -C /data .
    
    echo -e "${GREEN}✅ Backup hoàn tất!${NC}"
    echo "File lưu tại: $BACKUP_DIR/"
    ls -lh "$BACKUP_DIR"/*${TIMESTAMP}*
}

restore_data() {
    echo -e "${BLUE}📦 Restore dữ liệu${NC}"
    BACKUP_DIR="./backups"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}❌ Không tìm thấy thư mục backup${NC}"
        return
    fi
    
    echo "Các file backup có sẵn:"
    ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "Không có file backup"
    echo ""
    read -p "Nhập tên file backup Open WebUI: " webui_file
    
    if [ -f "$BACKUP_DIR/$webui_file" ]; then
        echo "Đang restore Open WebUI data..."
        docker run --rm \
            -v open-webui-setup_open-webui-data:/data \
            -v "$(pwd)/$BACKUP_DIR":/backup \
            alpine sh -c "cd /data && tar xzf /backup/$webui_file"
        echo -e "${GREEN}✅ Restore hoàn tất!${NC}"
    else
        echo -e "${RED}❌ File không tồn tại${NC}"
    fi
}

update_services() {
    echo -e "${YELLOW}🔄 Đang update lên version mới...${NC}"
    
    echo "1. Pull images mới..."
    docker compose pull
    
    echo "2. Recreate containers..."
    docker compose up -d --force-recreate
    
    echo -e "${GREEN}✅ Update hoàn tất!${NC}"
}

remove_all() {
    echo -e "${RED}⚠️  CẢNH BÁO: Điều này sẽ xóa TẤT CẢ dữ liệu!${NC}"
    read -p "Bạn có chắc chắn? (yes/no): " confirm
    
    if [ "$confirm" == "yes" ]; then
        echo "Đang xóa..."
        docker compose down -v
        echo -e "${GREEN}✅ Đã xóa tất cả!${NC}"
    else
        echo "Đã hủy."
    fi
}

resource_usage() {
    echo -e "${BLUE}📊 Resource Usage:${NC}"
    docker stats --no-stream
}

cleanup_docker() {
    echo -e "${YELLOW}🧹 Dọn dẹp Docker...${NC}"
    echo "Xóa containers đã dừng..."
    docker container prune -f
    echo "Xóa images không dùng..."
    docker image prune -f
    echo "Xóa volumes không dùng..."
    docker volume prune -f
    echo -e "${GREEN}✅ Dọn dẹp hoàn tất!${NC}"
}

# Main loop
check_docker

while true; do
    show_menu
    read -p "Nhập lựa chọn: " choice
    
    case $choice in
        1) status ;;
        2) logs_all ;;
        3) logs_webui ;;
        4) logs_ollama ;;
        5) restart_all ;;
        6) restart_webui ;;
        7) stop_services ;;
        8) start_services ;;
        9) backup_data ;;
        10) restore_data ;;
        11) update_services ;;
        12) remove_all ;;
        13) resource_usage ;;
        14) cleanup_docker ;;
        0) 
            echo -e "${GREEN}👋 Tạm biệt!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Lựa chọn không hợp lệ!${NC}"
            ;;
    esac
    
    echo ""
    read -p "Nhấn Enter để tiếp tục..."
done
