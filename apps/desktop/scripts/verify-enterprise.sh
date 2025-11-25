#!/bin/bash

# ============================================
# Folo 企业版验证脚本
# Folo Enterprise Edition Verification Script
# ============================================

echo "🔍 验证企业版配置 / Verifying Enterprise Configuration..."
echo ""

# 检查环境变量
echo "📋 检查环境变量 / Checking Environment Variables:"
echo "─────────────────────────────────────────────────"

if [ -f ".env" ]; then
  ENTERPRISE_MODE=$(grep "^VITE_ENTERPRISE_MODE" .env | cut -d '=' -f2)
  if [ "$ENTERPRISE_MODE" = "true" ]; then
    echo "✅ VITE_ENTERPRISE_MODE = true (企业版已启用)"
  else
    echo "⚠️  VITE_ENTERPRISE_MODE = $ENTERPRISE_MODE (企业版未启用)"
  fi

  API_URL=$(grep "^VITE_API_URL" .env | cut -d '=' -f2)
  echo "📡 VITE_API_URL = $API_URL"
else
  echo "❌ 未找到 .env 文件 / .env file not found"
  echo ""
  echo "提示: 使用以下命令创建企业版配置:"
  echo "   cp .env.enterprise .env"
  exit 1
fi

echo ""

# 检查关键源码文件
echo "📂 检查关键源码文件 / Checking Key Source Files:"
echo "─────────────────────────────────────────────────"

# 检查 constants.ts
if grep -q "IS_ENTERPRISE_MODE" ../../packages/internal/shared/src/constants.ts; then
  echo "✅ constants.ts - IS_ENTERPRISE_MODE 常量已定义"
else
  echo "❌ constants.ts - IS_ENTERPRISE_MODE 常量未找到"
fi

# 检查 env.desktop.ts
if grep -q "VITE_ENTERPRISE_MODE" ../../packages/internal/shared/src/env.desktop.ts; then
  echo "✅ env.desktop.ts - VITE_ENTERPRISE_MODE 环境变量已声明"
else
  echo "❌ env.desktop.ts - VITE_ENTERPRISE_MODE 环境变量未声明"
fi

# 检查 user store
if grep -q "IS_ENTERPRISE_MODE" ../../packages/internal/store/src/modules/user/store.ts; then
  echo "✅ user/store.ts - 企业版模式逻辑已实现"
else
  echo "❌ user/store.ts - 企业版模式逻辑未找到"
fi

echo ""

# 检查企业版配置文件
echo "📄 检查企业版配置文件 / Checking Enterprise Config Files:"
echo "─────────────────────────────────────────────────"

if [ -f ".env.enterprise" ]; then
  echo "✅ .env.enterprise 文件存在"
  if grep -q "^VITE_ENTERPRISE_MODE=true" .env.enterprise; then
    echo "   ✅ 包含正确的企业版配置"
  else
    echo "   ⚠️  配置可能不正确"
  fi
else
  echo "❌ .env.enterprise 文件不存在"
fi

if [ -f "scripts/build-enterprise.sh" ]; then
  echo "✅ 企业版构建脚本存在"
  if [ -x "scripts/build-enterprise.sh" ]; then
    echo "   ✅ 脚本具有执行权限"
  else
    echo "   ⚠️  脚本没有执行权限,运行: chmod +x scripts/build-enterprise.sh"
  fi
else
  echo "❌ 企业版构建脚本不存在"
fi

if [ -f "ENTERPRISE.md" ]; then
  echo "✅ 企业版文档存在"
else
  echo "⚠️  企业版文档不存在"
fi

echo ""

# 检查 package.json 脚本
echo "🛠️  检查构建脚本 / Checking Build Scripts:"
echo "─────────────────────────────────────────────────"

if grep -q "build:enterprise" package.json; then
  echo "✅ npm script 'build:enterprise' 已添加"
else
  echo "❌ npm script 'build:enterprise' 未找到"
fi

if grep -q "dev:enterprise" package.json; then
  echo "✅ npm script 'dev:enterprise' 已添加"
else
  echo "❌ npm script 'dev:enterprise' 未找到"
fi

echo ""
echo "─────────────────────────────────────────────────"

# 总结
echo ""
echo "📊 验证总结 / Verification Summary:"
echo "─────────────────────────────────────────────────"

if [ "$ENTERPRISE_MODE" = "true" ] && \
   [ -f ".env.enterprise" ] && \
   [ -f "scripts/build-enterprise.sh" ] && \
   grep -q "IS_ENTERPRISE_MODE" ../../packages/internal/shared/src/constants.ts; then
  echo "✅ 企业版配置完整,可以构建!"
  echo "✅ Enterprise configuration is complete, ready to build!"
  echo ""
  echo "下一步 / Next Steps:"
  echo "  1. 开发模式测试: pnpm run dev:enterprise"
  echo "  2. 构建企业版: pnpm run build:enterprise"
else
  echo "⚠️  企业版配置不完整,请检查上述错误"
  echo "⚠️  Enterprise configuration incomplete, please check errors above"
fi

echo ""
echo "🎉 验证完成! / Verification Complete!"
