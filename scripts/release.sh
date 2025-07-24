#!/bin/bash

# 参数检查
if [ -z "$1" ]; then
    echo "Usage: $0 <VERSION> [SCHEME_NAME]"
    exit 1
fi

VERSION="$1"
SCHEME="$2"  # 可选参数
PODSPEC_FILE=$(find . -name "*.podspec" -maxdepth 1 -type f | head -n 1)
TAG_PREFIX="v"

# 自动检测项目名称
PROJECT_PATH=$(find . -name "*.xcodeproj" -maxdepth 1 -type d | head -n 1)
WORKSPACE_PATH=$(find . -name "*.xcworkspace" -maxdepth 1 -type d | head -n 1)

if [ -n "${WORKSPACE_PATH}" ]; then
    PROJECT_NAME=$(basename "${WORKSPACE_PATH}" .xcworkspace)
else
    PROJECT_NAME=$(basename "${PROJECT_PATH}" .xcodeproj)
fi

# 如果未传入 Scheme 名称，使用项目名称
SCHEME="${SCHEME:-${PROJECT_NAME}}"
echo "🎯 Using scheme: ${SCHEME}"

# 执行构建脚本
echo "🏗️ Building XCFramework..."
./scripts/build.sh "${SCHEME}" Release || exit 1

# 检查 podspec 文件
if [ ! -f "${PODSPEC_FILE}" ]; then
    echo "❌ Error: No .podspec file found!"
    exit 1
fi

# 更新 podspec 版本号
echo "🔧 Updating podspec version to ${VERSION}..."
sed -i '' "s/\(s\.version[[:space:]]*=[[:space:]]*\).*/\1'${VERSION}'/" "${PODSPEC_FILE}"

# Git 提交和打 Tag
echo "📦 Committing changes and tagging..."
git add .
git commit -m "Release ${VERSION}"
git tag "${TAG_PREFIX}${VERSION}"
git push origin master
git push origin "${TAG_PREFIX}${VERSION}"

# 发布到 CocoaPods
echo "🚀 Publishing to CocoaPods..."
pod trunk push "${PODSPEC_FILE}" --allow-warnings

echo "🎉 Release ${VERSION} completed!"
