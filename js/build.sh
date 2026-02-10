#!/bin/bash
# ==========================================================================
# zk-symmetric-crypto/js 构建脚本
# 清除旧 lib/ → tsc 重新编译
#
# 注意: 运行时需要 ../resources/ 目录下的 .wasm/.zkey 文件
#       本脚本只编译 JS 代码，不重新编译 circom 电路
#
# 产物: lib/ (TypeScript 编译输出)
# ==========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "[zk-symmetric-crypto] 步骤 1: 清除旧构建产物和缓存"
echo "=========================================="
rm -rf lib 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
rm -f tsconfig.build.tsbuildinfo 2>/dev/null || true
echo "  已清除 lib/ 和缓存"

echo ""
echo "=========================================="
echo "[zk-symmetric-crypto] 步骤 2: 检查依赖"
echo "=========================================="
if [ ! -d "node_modules" ]; then
    echo "  npm install..."
    npm install
else
    echo "  node_modules 已存在"
fi

echo ""
echo "=========================================="
echo "[zk-symmetric-crypto] 步骤 3: 检查 resources/"
echo "=========================================="
RESOURCES_DIR="$SCRIPT_DIR/../resources"
if [ ! -d "$RESOURCES_DIR" ] || [ -z "$(ls -A "$RESOURCES_DIR" 2>/dev/null)" ]; then
    echo "警告: ../resources/ 目录为空或不存在"
    echo "  ZK 证明文件缺失，运行时可能出错"
    echo "  如需下载，请在 attestor-core 中运行: npm run download:zk-files"
else
    echo "  resources/ 存在 ($(du -sh "$RESOURCES_DIR" | cut -f1))"
fi

echo ""
echo "=========================================="
echo "[zk-symmetric-crypto] 步骤 4: TypeScript 编译"
echo "=========================================="
npm run build

echo ""
echo "=========================================="
echo "[zk-symmetric-crypto] 步骤 5: 验证产物"
echo "=========================================="
if [ ! -f "lib/index.js" ]; then
    echo "错误: lib/index.js 不存在"
    exit 1
fi
if [ ! -f "lib/index.d.ts" ]; then
    echo "错误: lib/index.d.ts 不存在"
    exit 1
fi
echo "  lib/ 产物完整 ✓"

echo ""
echo "[zk-symmetric-crypto] 构建完成"
