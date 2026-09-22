<div align="center">

# 🧪 Model Performance Test

**用同一道前端编程题，实测不同 AI 模型的代码能力**

[![Models](https://img.shields.io/badge/models-4-8A2BE2?logo=anthropic&logoColor=white)](#-测试对象)
[![Task](https://img.shields.io/badge/task-前端单页应用-FF6B6B)](#-测试任务)
[![Rubric](https://img.shields.io/badge/rubric-100分制-4ECDC4)](#-评分标准)
[![Status](https://img.shields.io/badge/status-测试进行中-F7B32B)](#-测试进展)

*一份可复现、可量化、可横向对比的 LLM 前端能力基准*

</div>

---

## 📌 项目简介

这是一个用于测试和比较不同 AI 模型性能的测试工程。所有模型接收**完全相同的提示词**（一个涵盖番茄钟、任务管理、习惯追踪的「个人生产力仪表板」单页应用），在相同环境下生成结果，再按统一的评分标准进行横向对比。

> 核心原则：**同题、同环境、同标准**，确保对比的公平性。

## 🎯 测试任务

被测应用为一个单 HTML 文件的「个人生产力仪表板」，要求实现 4 大核心模块：

| 模块 | 关键要求 |
|------|----------|
| ⏱️ 番茄钟 | 自定义工作/休息时长、进度环、开始/暂停/重置、结束提示 |
| ✅ 任务列表 | 增删、完成标记、统计、回车快速添加、localStorage 持久化 |
| 📅 习惯追踪 | 最近 7 天打卡可视化、点击打卡/取消、连续天数统计 |
| 💬 励志名言 | 随机展示、一键更换、至少 10 条名言 |

技术约束：原生 HTML/CSS/JS 单文件实现，响应式适配 375px / 768px / 1024px+，全部数据 localStorage 持久化。

完整提示词见 [`prompt.txt`](prompt.txt)。

## 📂 目录结构

```
model-performance-test/
├── README.md                     # 项目说明文档
├── prompt.txt                    # 统一的测试提示词
├── outputs/                      # 各模型生成的原始产出
│   ├── opus-4.8/dashboard.html   # Claude Opus 4.8
│   ├── opus-4.8v2/dashboard.html # Claude Opus 4.8（第二轮）
│   ├── fable5/dashboard.html     # Claude Fable 5
│   ├── sonnet-4.6/               # Claude Sonnet 4.6（待测试）
│   └── haiku-4.5/                # Claude Haiku 4.5（待测试）
├── evaluation/                   # 评估结果
│   ├── scores.md                 # 各模型评分表
│   └── comparison.md             # 横向对比分析
└── scripts/
    └── test-model.sh             # 自动化测试脚本
```

## 🚀 使用方法

### 测试单个模型

```bash
# 一键测试（自动计时、保存产出与元数据）
./scripts/test-model.sh opus-4.8

# 或手动执行
cat prompt.txt | claude --model opus > outputs/opus-4.8/dashboard.html
```

支持的模型：`opus-4.8` / `fable-5` / `sonnet-4.6` / `haiku-4.5`

### 查看与评估

```bash
# 在浏览器中打开产出，人工实测功能
firefox outputs/opus-4.8/dashboard.html
```

然后在 [`evaluation/scores.md`](evaluation/scores.md) 记录评分、在 [`evaluation/comparison.md`](evaluation/comparison.md) 记录对比结论。

## 📊 测试进展

> 以下代码规模与功能实现情况来自对产出 HTML 源码的静态分析；主观评分（UI 美观度、交互体验等）待浏览器人工实测后填入 [scores.md](evaluation/scores.md)。

| 模型 | 状态 | 产出大小 | 代码行数 | 四大功能 | localStorage | 响应式 | 主题切换 | 音效提示 |
|------|------|---------|---------|:-------:|:------------:|:------:|:--------:|:--------:|
| **Opus 4.8** | ✅ 已测试 | 33.7 KB | 1072 | ✅✅✅✅ | ✅ | ✅ | ✅ | ✅ |
| **Opus 4.8 v2** | ✅ 已测试 | 35.2 KB | 1018 | ✅✅✅✅ | ✅ | ✅ | ➖ | ✅ |
| **Fable 5** | ✅ 已测试 | 33.3 KB | 1024 | ✅✅✅✅ | ✅ | ✅ | ✅ | ✅ |
| Sonnet 4.6 | ⏳ 待测试 | — | — | — | — | — | — | — |
| Haiku 4.5 | ⏳ 待测试 | — | — | — | — | — | — | — |

> 三个已测模型均完整实现四大核心模块，全部使用原生单文件实现并通过 `@media` 响应式断点。详细对比见 [comparison.md](evaluation/comparison.md)。

## ⚖️ 评分标准

满分 **100 分**，四个维度：

| 维度 | 满分 | 构成 |
|------|-----:|------|
| 💻 代码能力 | 40 | 功能完整性 15 + 代码质量 10 + 错误处理 8 + 性能优化 7 |
| 🎨 前端设计 | 30 | UI/UX 15 + 响应式布局 8 + 视觉效果 7 |
| 🔧 工程实践 | 20 | 注释文档 8 + 可维护性 7 + 最佳实践 5 |
| ✨ 创新性 | 10 | 额外功能 5 + 体验优化 5 |

### 质量等级

| 等级 | 分数 | 表现 |
|:----:|:----:|------|
| ⭐ | 60–70 | 可运行、功能基本正常、UI 可用 |
| ⭐⭐ | 70–80 | UI 美观、功能完整、有 localStorage、结构清晰 |
| ⭐⭐⭐ | 80–90 | 响应式优秀、动画流畅、代码质量高 |
| ⭐⭐⭐⭐ | 90–100 | 多个加分项、体验出色、有创新细节 |

## 📋 测试规范

1. 使用**相同的提示词**测试所有模型，确保公平性
2. 在相同的环境和浏览器中测试生成的 HTML
3. 记录生成时间和 token 消耗（如果可用）
4. 建议多次测试取平均值，减少随机性

---

<div align="center">

📅 开始时间：2026-06-16 · 👤 测试人：ec

</div>
