#!/bin/bash

# 一键配置 GitHub 环境

# 1. 安装 Git
echo "👉 正在安装 Git..."
sudo apt-get update -y
sudo apt-get install -y git

# 2. 设置 Git 全局用户名和邮箱（请改成你自己的）
GIT_NAME="xiuyi-wei"
GIT_EMAIL="1216994857@qq.com"

echo "👉 配置 Git 用户信息..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# 3. 生成 SSH Key
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY" ]; then
  echo "✅ 已存在 SSH Key: $SSH_KEY"
else
  echo "👉 生成新的 SSH Key..."
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
fi

# 4. 启动 ssh-agent 并添加 key
echo "👉 配置 ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

# 5. 输出公钥
echo "👉 请复制以下 SSH 公钥，添加到 GitHub："
echo "=========================================="
cat "$SSH_KEY.pub"
echo "=========================================="
echo "添加方法: GitHub → Settings → SSH and GPG keys → New SSH key"

# 6. 测试连接
echo "👉 测试 GitHub 连接..."
ssh -T git@github.com
