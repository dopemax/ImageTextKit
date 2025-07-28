#!/bin/bash

# 传入参数作为 scheme，不传则默认使用项目名（目录名）
SCHEME="${1:-$(basename "$PWD")}"
CONFIGURATION="Release"

WORKSPACE_FILE=$(find . -maxdepth 1 -name "*.xcworkspace" | head -n 1)
XCODEPROJ_FILE=$(find . -maxdepth 1 -name "*.xcodeproj" | head -n 1)

if [[ -n "$WORKSPACE_FILE" ]]; then
    BUILD_CONTEXT=(-workspace "$WORKSPACE_FILE")
    echo "📦 Using workspace: ${BUILD_CONTEXT[@]}"
elif [[ -n "$XCODEPROJ_FILE" ]]; then
    BUILD_CONTEXT=(-project "$XCODEPROJ_FILE")
    echo "📦 Using project: ${BUILD_CONTEXT[@]}"
else
    echo "❌ 未找到 .xcworkspace 或 .xcodeproj，无法构建"
    exit 1
fi

echo "🎯 Using scheme: ${SCHEME}"

# 构建目录配置
BUILD_DIR="build"
XCFRAMEWORK_PATH="${BUILD_DIR}/${SCHEME}.xcframework"

# 清理旧构建
echo "🧹 清理构建目录..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# 编译真机版本 (arm64)
echo "🚀 Building iOS arm64..."
xcodebuild archive \
    "${BUILD_CONTEXT[@]}" \
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
    "${BUILD_CONTEXT[@]}" \
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
    
    ZIP_NAME="$SCHEME.xcframework.zip"
    echo "🗜️  压缩为 ZIP..."
    cd "$BUILD_DIR"
    zip -r "$ZIP_NAME" "${SCHEME}.xcframework"
else
    echo "❌ Error: Failed to create XCFramework"
    exit 1
fi
