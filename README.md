# DuanHpt9t9 + BotpressV12 Docker Setup

Hệ thống tích hợp DuanHpt9t9 (Next.js) và BotpressV12 với Docker containerization và giao diện admin tích hợp.

## 🏗️ Cấu trúc dự án

```
/workspace/
├── docker-compose.yml          # Docker Compose chính
├── DuanHpt9t9/                # Ứng dụng Next.js
│   ├── Dockerfile             # Docker config cho Next.js
│   ├── next.config.mjs        # Cấu hình standalone build
│   └── app/admin/adminbot/    # Giao diện quản lý AdminBot
└── BotpressV12/               # Botpress chatbot
    └── Dockerfile             # Docker config cho Botpress
```

## 🚀 Khởi chạy hệ thống

### 1. Khởi động tất cả services
```bash
cd /workspace
docker-compose up -d
```

### 2. Kiểm tra trạng thái
```bash
docker-compose ps
```

### 3. Xem logs
```bash
# Xem tất cả logs
docker-compose logs -f

# Xem logs của service cụ thể
docker-compose logs -f duan_hpt
docker-compose logs -f botpress
```

## 🌐 Truy cập ứng dụng

- **DuanHpt9t9 (Next.js)**: http://localhost:12000
- **Botpress Admin**: http://localhost:12001
- **AdminBot trong DuanHpt9t9**: http://localhost:12000/admin/adminbot

## 🔧 Cấu hình Services

### DuanHpt9t9 (Port 12000)
- **Container**: `duan_hpt_container`
- **Environment**: Production mode
- **Volumes**: 
  - Prisma database
  - Reports directory
  - Templates directory

### Botpress (Port 12001)
- **Container**: `botpress_container`
- **Database**: PostgreSQL
- **Volumes**: Botpress data persistence

### PostgreSQL
- **Container**: `postgres_container`
- **Database**: `botpress`
- **User/Password**: `botpress/botpress`

## 📋 Quản lý AdminBot

### Truy cập giao diện AdminBot
1. Đăng nhập vào DuanHpt9t9: http://localhost:12000
2. Vào Admin Panel
3. Chọn "AdminBot" từ sidebar
4. Kiểm tra trạng thái Botpress
5. Sử dụng các tùy chọn:
   - **Mở trong tab mới**: Mở Botpress trong cửa sổ riêng
   - **Mở trong trang này**: Nhúng Botpress vào giao diện admin

### API Endpoints
- `GET /api/botpress/status` - Kiểm tra trạng thái Botpress

## 🛠️ Lệnh Docker hữu ích

### Dừng hệ thống
```bash
docker-compose down
```

### Dừng và xóa volumes
```bash
docker-compose down -v
```

### Rebuild containers
```bash
docker-compose up --build -d
```

### Restart service cụ thể
```bash
docker-compose restart duan_hpt
docker-compose restart botpress
```

### Truy cập container shell
```bash
# DuanHpt9t9 container
docker-compose exec duan_hpt sh

# Botpress container
docker-compose exec botpress sh

# PostgreSQL container
docker-compose exec postgres psql -U botpress -d botpress
```

## 🔍 Troubleshooting

### Kiểm tra logs lỗi
```bash
docker-compose logs duan_hpt | grep -i error
docker-compose logs botpress | grep -i error
```

### Kiểm tra kết nối mạng
```bash
docker network ls
docker network inspect workspace_app_network
```

### Reset toàn bộ hệ thống
```bash
docker-compose down -v
docker-compose up --build -d
```

### Kiểm tra port conflicts
```bash
netstat -tulpn | grep :12000
netstat -tulpn | grep :12001
```

## 📝 Environment Variables

### DuanHpt9t9
- `NODE_ENV=production`
- `DATABASE_URL=file:./prisma/dev.db`
- `BOTPRESS_URL=http://botpress:3000`

### Botpress
- `NODE_ENV=production`
- `BP_HOST=0.0.0.0`
- `PORT=3000`
- `DATABASE_URL=postgres://botpress:botpress@postgres:5432/botpress`

## 🔐 Security Notes

- PostgreSQL sử dụng credentials mặc định (chỉ cho development)
- Botpress data được persist trong Docker volumes
- Network isolation giữa các containers

## 📚 Tài liệu tham khảo

- [Next.js Docker Documentation](https://nextjs.org/docs/deployment#docker-image)
- [Botpress V12 Documentation](https://v12.botpress.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**Lưu ý**: Đây là setup cho môi trường development. Cho production, cần cấu hình thêm SSL, security headers, và environment variables phù hợp.