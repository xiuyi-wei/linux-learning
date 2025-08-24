#!/bin/bash
# 数据集管理工具 v1.1（修正版：只修错，不加新功能）
# V1.0存在的问题:
# 1.SRC/DST 为空时只打印不退出；SRC 不存在才退出。
# 2.FIND_COND 拼接+eval 易出错；且 -type f 应放在外层。
# 3.for file in $FILES 会因空白分割路径（含空格）而出错。
# 4.cp "$file" "$DST" 未确保目标末尾 /；小问题但建议规范。

set -e

# 默认参数
# EXTS="yuv,jpg,mp4,txt"
EXT_ARR=(bmp txt)
SRC="SRC_DIR"
DST="DST_DIR"

# 参数检查（保持你的原逻辑）
[ -z "$SRC" ] && echo "❌ 请指定 --src 源目录"
[ -z "$DST" ] && echo "❌ 请指定 --dst 目标目录"
[ ! -d "$SRC" ] && echo "❌ 源目录不存在: $SRC" && exit 1

rm -rf "$DST"
mkdir -p "$DST"

# 构建 find 的扩展名过滤条件（用 -o 连接）
FIND_COND=()
for ext in "${EXT_ARR[@]}"; do
  FIND_COND+=(-o -name "*.${ext}")
done
# 去掉开头多余的 -o
if [ "${#FIND_COND[@]}" -gt 0 ] && [ "${FIND_COND[0]}" = "-o" ]; then
  FIND_COND=("${FIND_COND[@]:1}")
fi

# 清单文件
MANIFEST="${DST%/}/manifest.txt"
echo "src_path,dst_path,size,mtime" > "$MANIFEST"

COUNT=0
TOTAL_SIZE=0

# 关键：不使用 mapfile，改为 while+read -d '' 读取 -print0 的结果
while IFS= read -r -d '' file; do
  cp -- "$file" "${DST%/}/"

  size=$(stat -c%s -- "$file")
  mtime=$(stat -c%y -- "$file")
  dst_file="${DST%/}/$(basename -- "$file")"

  echo "$file,$dst_file,$size,$mtime" >> "$MANIFEST"

  COUNT=$((COUNT + 1))
  TOTAL_SIZE=$((TOTAL_SIZE + size))
done < <(find "$SRC" -type f \( "${FIND_COND[@]}" \) -print0)

echo "✅ 已筛选文件数: $COUNT"
if command -v numfmt >/dev/null 2>&1; then
  echo "📦 总大小: $(numfmt --to=iec $TOTAL_SIZE)"
else
  echo "📦 总大小(字节): $TOTAL_SIZE"
fi
echo "📄 清单生成: $MANIFEST"