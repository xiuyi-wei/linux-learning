#!/bin/bash
# 1. 进入一个目录（假设你要在家目录创建）
cd ~

# 2. 创建一个文件
echo "My first GitHub project with Linux" > README.md

# 3. 初始化 git 仓库
git init

# 4. 绑定远程仓库
git remote add origin git@github.com:xiuyi-wei/linux-learning.git

# 5. 添加文件并提交
git add .
git commit -m "first commit"

# 6. 推送到 GitHub
git branch -M main
git push -u origin main
