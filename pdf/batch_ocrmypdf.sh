#!/usr/bin/env bash
# batch_ocrmypdf.sh
#
# 对当前工作目录中的所有 PDF 批量执行 OCRmyPDF。
#
# 内置功能：
#   - 仅扫描当前目录中的 .pdf / .PDF 文件，不递归处理子目录
#   - 使用简体中文 + 英文识别模型（chi_sim+eng）
#   - 自动旋转页面、倾斜校正，并输出 PDF/A 格式
#   - 输出到当前目录的 ./output/ 子目录
#   - 输出文件命名为 <原文件名>_ocr.pdf，例如 invoice.pdf -> output/invoice_ocr.pdf
#   - 若对应的 _ocr.pdf 已存在，自动跳过，便于中断后重复运行
#   - 若转换失败，自动删除可能残留的不完整目标文件，避免下次误跳过
#   - 最后显示成功、跳过和失败数量
#
# 用法：
#   cd /path/to/pdf-folder
#   bash /path/to/batch_ocrmypdf.sh
#
# 依赖：
#   - ocrmypdf
#   - Tesseract 的 chi_sim（简体中文）和 eng（英文）语言包

set -euo pipefail

# 只检查主命令是否可用；语言包缺失会由 ocrmypdf 在实际处理时提示。
if ! command -v ocrmypdf >/dev/null 2>&1; then
  cat <<'EOF'
错误：未检测到 ocrmypdf，请先安装 OCRmyPDF 和中英文 Tesseract 语言包。

Linux（Debian / Ubuntu）：
  sudo apt update
  sudo apt install ocrmypdf tesseract-ocr-chi-sim tesseract-ocr-eng

macOS（Homebrew）：
  brew install ocrmypdf tesseract-lang
EOF
  exit 1
fi

OUTPUT_DIR="$(pwd)/output"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
pdf_files=(*.pdf *.PDF)

if [ ${#pdf_files[@]} -eq 0 ]; then
  echo "当前目录没有 PDF 文件：$(pwd)"
  exit 0
fi

echo "发现 ${#pdf_files[@]} 个 PDF，开始 OCR…"

skipped=0
processed=0
failed=0

for f in "${pdf_files[@]}"; do
  # 去除原始扩展名，统一将输出扩展名设为 .pdf。
  filename="${f%.*}"
  output_file="${OUTPUT_DIR}/${filename}_ocr.pdf"

  # 已有完整命名的输出文件则跳过。
  if [ -f "$output_file" ]; then
    echo "  [skip]  $f（已存在：output/$(basename "$output_file")）"
    ((skipped += 1))
    continue
  fi

  echo "  [ocr]   $f -> output/$(basename "$output_file")"

  if ocrmypdf \
    -l chi_sim+eng \
    --rotate-pages \
    --deskew \
    --output-type pdfa \
    "$f" "$output_file"; then
    echo "  [done]  output/$(basename "$output_file")"
    ((processed += 1))
  else
    # ocrmypdf 失败时清理半成品，确保后续运行能够重试该文件。
    rm -f "$output_file"
    echo "  [fail]  $f（已删除失败产生的目标文件）"
    ((failed += 1))
  fi
done

echo
echo "完成：${processed} 个成功，${skipped} 个跳过，${failed} 个失败"
echo "输出目录：$OUTPUT_DIR"
