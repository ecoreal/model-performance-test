#!/bin/bash

# 模型性能测试自动化脚本
# 用法: ./test-model.sh [model-name]
# 示例: ./test-model.sh opus-4.8

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="$PROJECT_DIR/prompt.txt"
OUTPUTS_DIR="$PROJECT_DIR/outputs"

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示使用说明
show_usage() {
    cat << EOF
模型性能测试脚本

用法:
    $0 [model-name]

可用的模型:
    opus-4.8    - Claude Opus 4.8
    fable-5     - Claude Fable 5 (需要claude5别名)
    sonnet-4.6  - Claude Sonnet 4.6
    haiku-4.5   - Claude Haiku 4.5

示例:
    $0 opus-4.8
    $0 fable-5

注意:
    - 生成的HTML会保存到 outputs/[model-name]/dashboard.html
    - 测试过程会记录开始和结束时间
    - 建议在生成后手动在浏览器中测试HTML文件
EOF
}

# 检查提示词文件
check_prompt_file() {
    if [ ! -f "$PROMPT_FILE" ]; then
        print_error "找不到提示词文件: $PROMPT_FILE"
        exit 1
    fi
    print_success "提示词文件已找到: $PROMPT_FILE"
}

# 测试模型
test_model() {
    local model=$1
    local output_dir="$OUTPUTS_DIR/$model"
    local output_file="$output_dir/dashboard.html"

    print_info "开始测试模型: $model"

    # 创建输出目录
    mkdir -p "$output_dir"

    # 记录开始时间
    local start_time=$(date +%s)
    print_info "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"

    # 根据不同模型执行不同命令
    case $model in
        opus-4.8)
            print_info "使用命令: claude --model opus"
            cat "$PROMPT_FILE" | claude --model opus > "$output_file" 2>&1
            ;;
        fable-5)
            print_info "使用命令: claude5 (需要claude5别名)"
            if ! command -v claude5 &> /dev/null; then
                print_error "claude5 命令不可用，请确保已配置别名"
                print_warning "运行: source ~/.bashrc"
                exit 1
            fi
            # fable-5需要交互式输入，这里提供手动方式
            print_warning "Fable 5 需要手动测试"
            print_info "请运行: cat $PROMPT_FILE | claude5 > $output_file"
            return 0
            ;;
        sonnet-4.6)
            print_info "使用命令: claude --model sonnet"
            cat "$PROMPT_FILE" | claude --model sonnet > "$output_file" 2>&1
            ;;
        haiku-4.5)
            print_info "使用命令: claude --model haiku"
            cat "$PROMPT_FILE" | claude --model haiku > "$output_file" 2>&1
            ;;
        *)
            print_error "未知的模型: $model"
            show_usage
            exit 1
            ;;
    esac

    # 记录结束时间
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    print_info "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
    print_success "生成耗时: ${duration} 秒"

    # 检查输出文件
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        local file_size=$(du -h "$output_file" | cut -f1)
        print_success "输出文件已生成: $output_file"
        print_info "文件大小: $file_size"

        # 保存测试元数据
        cat > "$output_dir/metadata.json" << EOF
{
  "model": "$model",
  "test_date": "$(date '+%Y-%m-%d %H:%M:%S')",
  "duration_seconds": $duration,
  "file_size": "$file_size",
  "output_file": "$output_file"
}
EOF
        print_success "元数据已保存: $output_dir/metadata.json"
    else
        print_error "输出文件生成失败或为空"
        exit 1
    fi

    # 提示下一步
    print_info ""
    print_info "下一步:"
    print_info "1. 在浏览器中打开: $output_file"
    print_info "2. 测试所有功能是否正常"
    print_info "3. 在 evaluation/scores.md 中记录评分"
}

# 主函数
main() {
    # 显示标题
    echo ""
    print_info "========================================="
    print_info "    模型性能测试工具"
    print_info "========================================="
    echo ""

    # 检查参数
    if [ $# -eq 0 ]; then
        print_warning "未指定模型"
        show_usage
        exit 1
    fi

    # 检查提示词文件
    check_prompt_file

    # 执行测试
    test_model "$1"

    print_success ""
    print_success "测试完成！"
}

# 运行主函数
main "$@"
