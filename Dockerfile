# 使用官方Node.js 20的镜像作为基础镜像
FROM node:20-slim

# 设置阿里云的Debian镜像源
RUN echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" > /etc/apt/sources.list \
  && echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list \
  && echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list \
  && echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list \
  && echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list

# 设置工作目录
WORKDIR /app

# 安装Puppeteer所需的依赖
RUN apt-get update && apt-get install -y \
  wget \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdbus-1-3 \
  libgdk-pixbuf2.0-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  xdg-utils \
  libpango-1.0-0 \
  libcairo2 \
  libgbm1 \
  libxshmfence1 \
  chromium \
  --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置环境变量，跳过Puppeteer的Chromium下载
ENV PUPPETEER_SKIP_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 将你的package.json和package-lock.json文件复制到工作目录
COPY package*.json ./

# 安装项目依赖，包括TypeScript
RUN npm install

# 将项目源码复制到容器
COPY . .

# 编译TypeScript代码到JavaScript
RUN npm run build

# 暴露端口3000
EXPOSE 3001

# 设置环境变量，以确保Puppeteer无需沙盒运行
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# 运行构建后的应用
CMD ["node", "dist/server.js"]
