# 停止当前运行的容器
docker stop url2md

# 删除已停止的容器
docker rm url2md

# 拉取最新的镜像
docker pull registry.cn-hangzhou.aliyuncs.com/dzhk-tech/url2md

# 使用最新的镜像启动新的容器
docker run -d --name url2md -p 3001:3001 --restart=always registry.cn-hangzhou.aliyuncs.com/dzhk-tech/url2md
