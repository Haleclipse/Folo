#!/bin/bash

# ============================================
# Folo 企业版 Windows x64 构建脚本
# Folo Enterprise Edition Windows x64 Build Script
# ============================================

set -e

echo "🏢 开始构建 Folo 企业版 (Windows x64) / Building Folo Enterprise Edition (Windows x64)..."
echo ""

# 检查是否存在企业版配置文件
if [ ! -f ".env.enterprise" ]; then
  echo "❌ 错误: 找不到 .env.enterprise 文件"
  echo "❌ Error: .env.enterprise file not found"
  exit 1
fi

# 备份当前的 .env 文件(如果存在)
if [ -f ".env" ]; then
  echo "📦 备份当前 .env 文件 / Backing up current .env file..."
  cp .env .env.backup
  echo "✅ 已备份到 .env.backup / Backed up to .env.backup"
  echo ""
fi

# 使用企业版配置
echo "🔧 应用企业版配置 / Applying enterprise configuration..."
cp .env.enterprise .env
echo "✅ 企业版配置已应用 / Enterprise configuration applied"
echo ""

# 显示企业版模式状态
echo "📋 企业版配置详情 / Enterprise Configuration Details:"
echo "   VITE_ENTERPRISE_MODE=$(grep VITE_ENTERPRISE_MODE .env | cut -d '=' -f2)"
echo ""

# 构建前先构建 packages
echo "🔨 构建依赖包 / Building packages..."
cd ../..
pnpm run build:packages
cd apps/desktop
echo "✅ 依赖包构建完成 / Packages build completed"
echo ""

# 构建 Electron 应用 (仅 Windows x64)
echo "🪟 开始构建 Windows x64 版本 / Building Windows x64 version..."
echo ""

# 执行构建 - 使用 electron-forge make 指定平台
pnpm run build:electron-vite

echo ""
echo "📦 打包 Windows x64 安装包 / Packaging Windows x64 installer..."

# 使用 electron-forge 打包 Windows 版本
npx electron-forge make --platform=win32 --arch=x64

echo ""
echo "✅ 企业版 Windows x64 构建完成! / Enterprise edition Windows x64 build completed!"
echo ""
echo "📦 构建产物位于 / Build artifacts located at:"
echo "   apps/desktop/out/make/"
ls -lh out/make/ 2>/dev/null || echo "   (检查 out/make/ 目录)"
echo ""

# 询问是否恢复原配置
read -p "是否恢复原 .env 配置? (y/n) / Restore original .env? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -f ".env.backup" ]; then
    mv .env.backup .env
    echo "✅ 已恢复原配置 / Original configuration restored"
  else
    echo "⚠️  没有找到备份文件 / No backup file found"
  fi
else
  echo "✅ 保留企业版配置 / Keeping enterprise configuration"
  rm -f .env.backup 2>/dev/null
fi

echo ""
echo "🎉 完成! / Done!"
