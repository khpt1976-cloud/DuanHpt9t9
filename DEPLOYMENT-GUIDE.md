# 🌐 Hướng dẫn tạo Link Công khai cho DuanHpt9t9 + BotpressV12

## 🚀 Các phương pháp Deploy

### 1. ⚡ Quick Deploy (Ngrok) - Nhanh nhất
```bash
cd /workspace
./deploy-config/quick-deploy.sh
```
**Ưu điểm:** Nhanh, miễn phí, không cần đăng ký
**Nhược điểm:** Link thay đổi mỗi lần restart

### 2. 🚂 Railway (Khuyến nghị)
```bash
# 1. Tạo tài khoản tại https://railway.app
# 2. Install Railway CLI
npm install -g @railway/cli

# 3. Login và deploy
railway login
railway project:create duanhpt9t9-botpress
railway up --service duanhpt9t9 --dockerfile DuanHpt9t9/Dockerfile
railway up --service botpress --dockerfile BotpressV12/Dockerfile
```
**Link:** `https://duanhpt9t9.railway.app`

### 3. ⚡ Vercel (Chỉ DuanHpt9t9)
```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Deploy
cd DuanHpt9t9
vercel --prod
```
**Link:** `https://duanhpt9t9.vercel.app`

### 4. 🎨 Render
```bash
# 1. Tạo tài khoản tại https://render.com
# 2. Connect GitHub repo
# 3. Sử dụng file render.yaml đã tạo
```
**Link:** `https://duanhpt9t9.onrender.com`

### 5. 🟣 Heroku
```bash
./deploy-config/heroku-setup.sh
```
**Link:** `https://duanhpt9t9-app.herokuapp.com`

## 🔧 Cấu hình cho từng platform

### Railway Configuration
- File: `deploy-config/railway.json`
- Auto-scaling: ✅
- Database: PostgreSQL included
- SSL: ✅
- Custom domain: ✅

### Vercel Configuration  
- File: `deploy-config/vercel.json`
- Serverless functions: ✅
- Edge network: ✅
- SSL: ✅
- Custom domain: ✅

### Render Configuration
- File: `deploy-config/render.yaml`
- Docker support: ✅
- Database: PostgreSQL included
- SSL: ✅
- Auto-deploy: ✅

### Heroku Configuration
- Script: `deploy-config/heroku-setup.sh`
- Container registry: ✅
- Add-ons: PostgreSQL
- SSL: ✅
- Custom domain: ✅ (paid)

## 🌐 Ngrok - Tạo link công khai ngay lập tức

### Cách 1: Script tự động
```bash
cd /workspace
./deploy-config/quick-deploy.sh
```

### Cách 2: Manual
```bash
# 1. Đăng ký tại https://ngrok.com (miễn phí)
# 2. Lấy auth token
# 3. Cài đặt ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok

# 4. Setup auth token
ngrok authtoken YOUR_TOKEN_HERE

# 5. Start services
docker compose up -d

# 6. Create tunnels
ngrok http 12000 --subdomain=duanhpt9t9 &  # DuanHpt9t9
ngrok http 12001 --subdomain=botpress &    # Botpress
```

## 📊 So sánh các phương pháp

| Platform | Miễn phí | Setup Time | Tính năng | Link cố định |
|----------|----------|------------|-----------|--------------|
| Ngrok    | ✅       | 2 phút     | Cơ bản    | ❌           |
| Railway  | ✅       | 5 phút     | Đầy đủ    | ✅           |
| Vercel   | ✅       | 3 phút     | Chỉ FE    | ✅           |
| Render   | ✅       | 10 phút    | Đầy đủ    | ✅           |
| Heroku   | ✅       | 15 phút    | Đầy đủ    | ✅           |

## 🎯 Khuyến nghị

### Cho Demo nhanh:
```bash
./deploy-config/quick-deploy.sh
```

### Cho Production:
1. **Railway** - Tốt nhất cho fullstack
2. **Vercel** - Tốt cho Next.js
3. **Render** - Alternative tốt

## 🔗 Links mẫu sau khi deploy

- **DuanHpt9t9:** `https://duanhpt9t9.railway.app`
- **Botpress:** `https://botpress-duanhpt9t9.railway.app`  
- **AdminBot:** `https://duanhpt9t9.railway.app/admin/adminbot`

## 🛠️ Troubleshooting

### Lỗi thường gặp:
1. **Port conflict:** Đổi port trong docker-compose.yml
2. **Memory limit:** Upgrade plan hoặc optimize Docker image
3. **Build timeout:** Tăng timeout trong platform settings
4. **Database connection:** Check DATABASE_URL environment variable

### Debug commands:
```bash
# Check containers
docker compose ps
docker compose logs

# Check ngrok status
curl http://localhost:4040/api/tunnels

# Test endpoints
curl http://localhost:12000/api/health
curl http://localhost:12001/health
```

## 📞 Support

Nếu gặp vấn đề, check:
1. Docker containers đang chạy: `docker compose ps`
2. Logs: `docker compose logs`
3. Network connectivity: `curl localhost:12000`
4. Platform-specific documentation