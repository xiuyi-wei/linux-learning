#!/bin/bash
# 数据集管理工具 v1.0

set -e

# 默认参数
# EXTS="yuv,jpg,mp4,txt"
EXTS="bmp"
SRC="SRC_DIR"
DST="DST_DIR"

# 参数检查
[ -z "$SRC" ] && echo "❌ 请指定 --src 源目录" 
[ -z "$DST" ] && echo "❌ 请指定 --dst 目标目录"
[ ! -d "$SRC" ] && echo "❌ 源目录不存在: $SRC" && exit 1

mkdir -p "$DST"

# 构建 find 的扩展名过滤条件
IFS=',' read -ra EXT_ARR <<< "$EXTS"
FIND_COND=""
for ext in "${EXT_ARR[@]}"; do
    FIND_COND="$FIND_COND -o -type f -name \"*.$ext\""
done
FIND_COND=${FIND_COND# -o } # 去掉开头多余的 -o

# 查找文件
FILES=$(eval find "\"$SRC\""  $FIND_COND )

if [ -z "$FILES" ]; then
    echo "⚠️ 未找到符合条件的文件 ($EXTS)"
    exit 0
fi

# 清单文件
MANIFEST="$DST/manifest.txt"
echo "src_path,dst_path,size,mtime" > "$MANIFEST"

COUNT=0
TOTAL_SIZE=0

# 处理每个文件
for file in $FILES; do
    cp "$file" "$DST"
    COUNT=$((COUNT+1))
    TOTAL_SIZE=$((TOTAL_SIZE+size))
done

# 输出统计
echo "✅ 已筛选文件数: $COUNT"
echo "📦 总大小: $(numfmt --to=iec $TOTAL_SIZE)"
echo "📄 清单生成: $MANIFEST"
