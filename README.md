# Claude Code 技能库

> 8 个核心技能 + 3 个辅助工具 + 5 个指南文档

生成时间：2026-01-11

## 快速概览

| 技能 | 核心功能 | 激活示例 |
|------|---------|---------|
| **problem-solver** | 问题编排器（自动发散+收敛） | "如何优化性能" |
| **multi-thinker-brainstorm** | 六维脑暴（6角色发散思维） | "脑暴一下：支付功能" |
| **multi-thinker-debate** | 三方辩论（3角色对抗决策） | "三方辩论：React vs Vue" |
| **git-master** | Git/GitHub 自动化 | "提交代码" |
| **auto-qa** | 自动化测试与日志分析 | "写测试" |
| **project-analyst** | 项目逆向分析 | "分析这个项目" |
| **project-init** | 项目标准化 | "标准化项目" |

## 核心技能

### 1. problem-solver - 问题编排器 ⭐

自动识别问题类型，编排其他技能协同工作，输出完整解决方案。

**激活示例：**
```bash
"如何提升前端性能"
"如何设计高可用系统"
"如何优化数据库查询"
```

**工作流程：** 问题分类 → 发散阶段 → 收敛阶段 → 执行计划

---

### 2. multi-thinker-brainstorm - 六维脑暴

6 个角色协同发散思维，产生创新点。

**6 个角色：** 哲学家、科学家、艺术家、商业家、工程师、心理学家

**激活示例：**
```bash
"脑暴一下：智能手表的支付功能"
"6个角色讨论：如何提升用户留存"
```

---

### 3. multi-thinker-debate - 三方辩论

3 个角色对抗思考，打破 AI 顺从性，做出平衡决策。

**3 个角色：** 进取派（架构师）、怀疑派（SRE）、务实派（CTO）

**激活示例：**
```bash
"三方辩论：是否采用微服务"
"多角色辩论：React vs Vue"
```

---

### 4. git-master - Git 自动化

Git 版本控制自动化，支持 GitHub/GitLab/Gitea。

**激活示例：**
```bash
"帮我初始化 git"
"提交代码"
"创建 PR/MR"
```

---

### 5. auto-qa - 自动化测试

脚本驱动测试，节省 80-90% Token。

**激活示例：**
```bash
"写测试"
"日志分析"
"性能测试"
```

---

### 6. project-analyst - 项目分析

Inside-Out 7 层次分析，从代码逆向推导架构。

**激活示例：**
```bash
"分析项目"
"理解架构"
"生成文档"
```

**权限要求：** 需要项目级读写权限

---

### 7. project-init - 项目标准化

Outside-In 5 阶段标准化，注入最佳实践。

**激活示例：**
```bash
"标准化项目"
"整理结构"
"注入配置"
```

**权限要求：** 需要项目级读写权限

---

## 快速选择指南

```
你想做什么？

├─ 复杂技术问题/优化方案 → problem-solver
├─ 纯创意/产品设计       → brainstorm
├─ 明确决策/风险评估      → debate
├─ Git/版本控制          → git-master
├─ 写测试/分析日志        → auto-qa
├─ 理解项目/生成文档      → project-analyst
└─ 标准化项目/整理结构    → project-init
```

---

## 权限配置

只有 2 个技能需要项目级权限：
- `project-analyst`
- `project-init`

**快速配置：**
```bash
cd your-project
~/.claude/skills/setup-project-permissions.sh
```

---

## 目录结构

```
skills/
├── 核心技能（7 个）
│   ├── problem-solver.md              ⭐ 问题编排器
│   ├── multi-thinker-brainstorm.md    🌟 6 角色脑暴
│   ├── multi-thinker-debate.md        🎭 3 角色辩论
│   ├── git-master.md                  🔧 Git 自动化
│   ├── auto-qa.md                     🧪 自动化测试
│   ├── project-analyst.md             🔍 项目分析
│   └── project-init.md                📐 项目标准化
│
├── 辅助工具
│   └── setup-project-permissions.sh  🔐 权限配置
│
└── 指南文档
    ├── SKILLS-ECOSYSTEM.md           📚 技能生态总览
    ├── MULTI-THINKER-GUIDE.md        📖 思维技能指南
    ├── PERMISSION-GUIDE.md           🔐 权限管理详解
    ├── EXAMPLES.md                   📝 使用示例
    └── auto-qa-examples.md           🧪 测试示例
```

---

## 核心理念

**自动编排：** problem-solver 自动协调其他技能

**发散 + 收敛：** brainstorm（创意）+ debate（决策）

**智能协同：** 一次提问，完整解决

---

**记住：** 复杂问题直接问，`problem-solver` 会自动完成"发散→收敛→执行"全流程！
