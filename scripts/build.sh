#!/bin/bash

# 参数检查
CONFIGURATION="${2:-Release}"

# 自动检测项目名称和 Scheme
PROJECT_PATH=$(find . -name "*.xcodeproj" -maxdepth 1 -type d | head -n 1)
WORKSPACE_PATH=$(find . -name "*.xcworkspace" -maxdepth 1 -type d | head -n 1)

if [ -n "${WORKSPACE_PATH}" ]; then
    PROJECT_NAME=$(basename "${WORKSPACE_PATH}" .xcworkspace)
    BUILD_SETTINGS="-workspace ${WORKSPACE_PATH}"
    echo "🔍 Detected workspace: ${WORKSPACE_PATH}"
else
    PROJECT_NAME=$(basename "${PROJECT_PATH}" .xcodeproj)
    BUILD_SETTINGS="-project ${PROJECT_PATH}"
    echo "🔍 Detected project: ${PROJECT_PATH}"
fi

# 如果未传入 Scheme 名称，使用项目名称
SCHEME="${1:-${PROJECT_NAME}}"
echo "🎯 Using scheme: ${SCHEME}"

# 构建目录配置
BUILD_DIR="build"
XCFRAMEWORK_PATH="${BUILD_DIR}/${SCHEME}.xcframework"

# 清理旧构建
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# 编译真机版本 (arm64)
echo "🚀 Building iOS arm64..."
xcodebuild archive \
    ${BUILD_SETTINGS} \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -destination "generic/platform=iOS" \
    -archivePath "${BUILD_DIR}/${SCHEME}-iOS-arm64.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    | xcpretty

# 编译模拟器版本 (x86_64)
echo "🚀 Building iOS Simulator x86_64..."
xcodebuild archive \
    ${BUILD_SETTINGS} \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${BUILD_DIR}/${SCHEME}-iOS-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    | xcpretty

# 合并为 XCFramework
echo "🔄 Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "${BUILD_DIR}/${SCHEME}-iOS-arm64.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
    -framework "${BUILD_DIR}/${SCHEME}-iOS-simulator.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
    -output "${XCFRAMEWORK_PATH}"

# 验证输出
if [ -d "${XCFRAMEWORK_PATH}" ]; then
    echo "✅ Success: ${XCFRAMEWORK_PATH}"
else
    echo "❌ Error: Failed to create XCFramework"
    exit 1
fi
