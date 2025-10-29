#!/bin/bash

# 快速Git提交脚本
# 使用方法: ./quick-commit.sh "提交信息"
# 或者: ./quick-commit.sh (将使用默认提交信息)

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 获取提交信息
if [ -z "$1" ]; then
    # 如果没有提供提交信息，使用默认信息
    COMMIT_MSG="更新代码 - $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${YELLOW}未提供提交信息，使用默认信息: ${COMMIT_MSG}${NC}"
else
    COMMIT_MSG="$1"
fi

echo -e "${BLUE}开始快速提交流程...${NC}"
echo "----------------------------------------"

# 检查是否在Git仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}错误: 当前目录不是Git仓库${NC}"
    exit 1
fi

# 显示当前状态
echo -e "${BLUE}当前Git状态:${NC}"
git status --short

echo "----------------------------------------"

# 添加所有更改
echo -e "${BLUE}添加所有更改...${NC}"
git add .

# 检查是否有文件被添加
if git diff --cached --quiet; then
    echo -e "${YELLOW}没有检测到更改，无需提交${NC}"
    exit 0
fi

# 显示将要提交的更改
echo -e "${BLUE}将要提交的更改:${NC}"
git diff --cached --name-status

echo "----------------------------------------"

# 提交更改
echo -e "${BLUE}提交更改...${NC}"
if git commit -m "$COMMIT_MSG"; then
    echo -e "${GREEN}✓ 提交成功${NC}"
else
    echo -e "${RED}✗ 提交失败${NC}"
    exit 1
fi

# 推送到远程仓库
echo -e "${BLUE}推送到远程仓库...${NC}"
if git push origin main; then
    echo -e "${GREEN}✓ 推送成功${NC}"
    echo "----------------------------------------"
    echo -e "${GREEN}🎉 代码已成功提交并推送到远程仓库！${NC}"
else
    echo -e "${RED}✗ 推送失败${NC}"
    echo -e "${YELLOW}提示: 代码已在本地提交，但推送到远程仓库失败${NC}"
    echo -e "${YELLOW}请检查网络连接或手动执行: git push origin main${NC}"
    exit 1
fi

echo "----------------------------------------"
echo -e "${BLUE}最新提交信息:${NC}"
git log --oneline -1
