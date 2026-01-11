# Claude Code 技能使用示例

本指南包含完整的实际使用示例，帮助您快速上手 Claude Code 技能生态系统。

---

## 📚 目录

1. [权限配置示例](#权限配置示例)
2. [项目分析示例](#项目分析示例)
3. [项目标准化示例](#项目标准化示例)
4. [问题解决示例](#问题解决示例)
5. [组合工作流示例](#组合工作流示例)

---

## 权限配置示例

### 场景 1：新项目首次配置

```bash
# 1. 创建新项目
mkdir my-new-project
cd my-new-project
npm init -y

# 2. 运行权限配置脚本
~/.claude/skills/setup-project-permissions.sh

# 交互式输出：
🔧 Claude Code 项目权限配置工具
================================

📂 Step 1: 检测项目根目录
✅ 项目根目录: /home/user/my-new-project

📁 Step 2: 检查 .claude 目录
⚠️  .claude 目录不存在，正在创建...
✅ .claude 目录已创建

🔍 Step 3: 检查现有权限配置
⚠️  配置文件不存在

🎯 Step 4: 选择需要的技能
1) project-analyst（项目分析）
2) project-init（项目标准化）
3) 两个技能都需要
4) 自定义权限

请选择 [1-4]: 3

📝 Step 5: 生成配置文件
✅ 配置文件已生成: .claude/settings.local.json

🔍 Step 6: 验证配置
✅ 配置文件存在
✅ 权限配置正确

================================
✅ 权限配置完成！

# 3. 验证配置
cat .claude/settings.local.json
```

**生成的配置文件**：
```json
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)",
      "Bash(cd,ls,cat,mkdir,cp,mv)"
    ],
    "comment": "Auto-generated for project-analyst + project-init skill",
    "generatedAt": "2026-01-11T10:00:00+08:00",
    "generator": "setup-project-permissions.sh"
  }
}
```

---

### 场景 2：现有项目添加权限

```bash
# 1. 进入现有项目
cd existing-project

# 2. 运行配置脚本
~/.claude/skills/setup-project-permissions.sh

# 输出：
🔍 Step 3: 检查现有权限配置
⚠️  配置文件不存在

# 如果已有配置，会自动备份：
🔍 Step 3: 检查现有权限配置
⚠️  发现现有配置文件
✅ 已备份现有配置到: .claude/settings.local.json.backup.20260111_100000

现有权限配置：
{
  "permissions": {
    "allow": ["Read(./)"]
  }
}

是否更新现有配置？(y/N): y

# 继续配置...
```

---

### 场景 3：技能自动检测配置

```bash
# 用户直接使用技能，未提前配置权限
cd my-project
echo "分析这个项目的架构" | claude

# 技能自动检测：
⚠️  缺少项目级写权限

一键配置脚本：
mkdir -p .claude
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)"
    ],
    "comment": "Auto-added by project-analyst skill"
  }
}
EOF

# 用户复制执行后，技能继续运行
```

---

## 项目分析示例

### 场景 1：接手未知项目

```bash
# 用户提问
"分析这个项目的架构和核心功能"

# project-analyst 执行
【启动前检查】
✅ 项目根目录: /home/user/mystery-project
✅ 项目级写权限已配置

【层次 1：表层特征扫描】
检测到：
  • package.json → Node.js 项目
  • tsconfig.json → TypeScript
  • vite.config.ts → Vite 构建工具
  • src/ 目录结构：React 应用

【层次 2：依赖关系映射】
主要依赖：
  • react, react-dom → React 框架
  • react-router → 路由管理
  • @tanstack/react-query → 数据获取
  • zustand → 状态管理
  • axios → HTTP 客户端

架构模式：SPA 单页应用

【层次 3：数据模型分析】
核心实体：
  • User（用户）
  • Post（文章）
  • Comment（评论）

【层次 4：业务逻辑分析】
核心功能：
  1. 用户认证（登录/注册）
  2. 文章管理（CRUD）
  3. 评论系统
  4. 用户个人主页

【层次 5：API 契约分析】
后端接口：
  • POST /api/auth/login
  • GET /api/posts
  • POST /api/posts
  • DELETE /api/posts/:id

【层次 6：架构模式识别】
架构模式：
  • 前后端分离
  • RESTful API
  • 组件化设计
  • Hook 模式

【层次 7：质量审计】
代码质量：
  ✅ 使用 TypeScript
  ✅ 有 ESLint 配置
  ⚠️  缺少单元测试
  ⚠️  无 API 类型定义

【输出】生成项目文档
✅ README.md
✅ ARCHITECTURE.md
✅ API.md
```

---

## 项目标准化示例

### 场景 1：混乱项目标准化

```bash
# 用户提问
"标准化这个项目"

# project-init 执行
【启动前检查】
✅ 项目根目录: /home/user/messy-project
✅ 项目级写权限已配置

⚠️  重要提醒：
  1. 建议先提交当前代码到 Git
  2. 或创建备份分支
  3. project-init 会创建新文件，但不会删除

【阶段 0：意图理解】
分析项目特征：
  • package.json 存在 → Node.js 项目
  • src/ 目录混乱 → 需要重构
  • 无 .gitignore → 缺少规范
  • 无 README.md → 缺少文档

作者原始意图：
  • 保留自定义工具函数目录
  • 使用特定的命名约定
  → 将保留这些有意义的非标准结构

【阶段 1：表层扫描】
当前问题：
  ❌ 缺少 .gitignore
  ❌ 缺少 README.md
  ❌ 缺少 CONTRIBUTING.md
  ❌ 无 ESLint 配置
  ❌ 无 Prettier 配置

【阶段 2：依赖与配置注入】
注入配置文件：
  ✅ .gitignore（标准 Node.js）
  ✅ .editorconfig（统一编辑器配置）
  ✅ .eslintrc.js（ESLint 规则）
  ✅ .prettierrc（Prettier 格式）
  ✅ tsconfig.json（TypeScript 配置）

【阶段 3：目录结构标准化】
重构目录结构：
  src/
  ├── api/          ← 新建：API 请求
  ├── components/   ← 保留：已有组件
  ├── hooks/        ← 新建：自定义 Hooks
  ├── lib/          ← 保留：作者的工具函数
  ├── pages/        ← 新建：页面组件
  ├── styles/       ← 新建：全局样式
  ├── types/        ← 新建：类型定义
  └── utils/        ← 新建：通用工具

【阶段 4：文档生成】
生成标准文档：
  ✅ README.md（项目说明）
  ✅ CONTRIBUTING.md（贡献指南）
  ✅ CHANGELOG.md（变更日志）
  ✅ .env.example（环境变量模板）

【阶段 5：质量检查】
检查清单：
  ✅ 目录结构标准化
  ✅ 配置文件完整
  ✅ 文档齐全
  ✅ 可立即开发

【输出】标准化完成
```

**标准化前后对比**：

```
标准化前：
messy-project/
├── package.json
├── src/
│   ├── App.jsx
│   ├── main.jsx
│   └── utils/          ← 混乱的工具函数
├── components/         ← 散落在外部
└── pages/             ← 散落在外部

标准化后：
messy-project/
├── .editorconfig      ← 新增
├── .env.example       ← 新增
├── .eslintrc.js        ← 新增
├── .gitignore         ← 新增
├── .prettierrc        ← 新增
├── CHANGELOG.md       ← 新增
├── CONTRIBUTING.md    ← 新增
├── README.md          ← 新增（增强）
├── package.json       ← 保留
└── src/
    ├── api/           ← 新增
    ├── components/    ← 移入
    ├── hooks/         ← 新增
    ├── lib/           ← 保留（作者意图）
    ├── pages/         ← 移入
    ├── styles/        ← 新增
    ├── types/         ← 新增
    └── utils/         ← 整理
```

---

## 问题解决示例

### 场景 1：性能优化问题（自动编排）

```bash
# 用户提问
"如何提升前端项目性能？"

# problem-solver 自动识别并编排
【问题分类】
识别为复合问题 C（需要探索方案 + 决策优先级）

【阶段 1：发散思维】
调用 multi-thinker-brainstorm...

🔭 哲学家：
  性能本质是时间 → 预加载、边缘计算
  核心价值：用户的生命

🔬 科学家：
  esbuild 替代 babel（提升 10-100x）
  虚拟滚动（处理 10k+ 列表）
  Web Worker 处理大数据

🎨 艺术家：
  骨架屏（白屏时间 < 100ms）
  渐进式加载（低质量 → 高质量）
  微动效反馈（按钮点击 50ms 响应）

💼 商业家：
  代码分割（减少 50% 首屏体积）
  图片优化（WebP + 响应式，节省 40% 流量）
  缓存策略（命中率 80%，提升 10x 速度）

🔧 工程师：
  Tree Shaking（减少 30% 体积）
  React.memo / useMemo（减少 40% 渲染）
  Code Splitting（路由级 + 组件级）

🧠 心理学家：
  进度条（即使虚假的，也能减少焦虑）
  Skeleton Screen（比 Loading 图标更优雅）
  感知性能 > 实际性能

【输出：20+ 方案清单】

【阶段 2：收敛决策】
调用 multi-thinker-debate...

🚀 进取派（架构师）：
  必须全面升级！
  1️⃣ 构建工具：Webpack → Vite（启动快 10-100x）
  2️⃣ 运行时框架：React → React Server Components
  3️⃣ 渲染模式：CSR → SSR + SSG
  4️⃣ 架构：单体 → 微前端

🛡️ 怀疑派（SRE 专家）：
  这会是个灾难！
  • Vite 生态不成熟（生产环境翻车率 30%+）
  • SSR 增加复杂度（内存占用 3x）
  • 微前端通信复杂（状态管理噩梦）
  真实案例：某公司迁移 Vite 后，生产环境白屏，
  回滚花费 4 小时，损失 50 万用户

⚖️ 务实派（CTO）：
  现实问题：
  • 团队只有 5 人，没精力管 20 个服务
  • 当前构建 15 分钟，但还没到瓶颈
  • 迁移成本：3-6 个月
  建议渐进优化，不要大爆炸式重构

【交叉质询】

🛡️ 怀疑派 → 🚀 进取派：
  你说 Vite 启动快，但生产环境构建和开发不同
  团队没人会用，出问题怎么修？

⚖️ 务实派 → 🚀 进取派：
  React Server Components 还是实验性技术
  值得为此重构 4 个项目吗？

【综合仲裁：平衡方案】

决策结果：
  P0（立即执行）：
    • 代码分割 + Tree Shaking
    • 图片优化 + 懒加载
    • 缓存策略

  P1（试点评估）：
    • 选择一个非关键项目试点 Vite
    • 验证生产环境稳定性

  P2（暂缓）：
    • SSR/SSG（除非 SEO 迫切需要）
    • 微前端（除非团队 > 50 人）
    • Edge Computing（成本高）

【阶段 3：执行计划】

Week 1: 构建优化
  • 启用 Tree Shaking: 减少 30% 体积
  • 代码分割（路由级）: 减少 50% 首屏资源
  • 生产环境 gzip: 减少 60% 传输体积

Week 2: 运行时优化
  • 图片 WebP + 懒加载: 减少 70% 图片流量
  • React.memo 优化列表: 减少 40% 渲染
  • 路由预加载: 提升页面切换速度

Week 3: 监控
  • 集成 Web Vitals: 监控 LCP/FID/CLS
  • 性能基线数据: 对比优化效果

Month 2: Vite 试点
  • 选择非关键项目
  • 验证稳定性
  • 团队培训

预期收益：
  首屏加载：2.5s → 1.8s ✅
  构建体积：3MB → 1.8MB ✅
  风险：低（渐进式优化）
```

---

## 组合工作流示例

### 场景 1：接手老项目完整流程

```bash
# 第 1 步：理解项目
"分析这个项目的架构"

→ project-analyst 执行
   输出：技术栈、架构模式、核心功能、依赖关系
   生成文档：README.md, ARCHITECTURE.md

# 第 2 步：评估质量
"审计代码质量，找出技术债务"

→ project-analyst 深度分析
   输出：
   • 代码质量评分：C+
   • 主要问题：
     - 缺少单元测试（覆盖率 0%）
     - 组件耦合度高
     - 无类型安全
     - 构建速度慢（15 分钟）

# 第 3 步：制定优化方案（自动编排）
"如何改进代码质量"

→ problem-solver 自动执行
   → multi-thinker-brainstorm（发散）
      产生 20+ 改进方案

   → multi-thinker-debate（收敛）
      决策优先级：
        P0: 添加 TypeScript + ESLint
        P1: 单元测试（核心模块）
        P2: 组件解耦（重构）

   输出：执行计划

# 第 4 步：执行标准化
"标准化项目结构"

→ project-init 执行
   创建标准目录结构
   注入配置文件（ESLint, Prettier）
   生成文档模板

# 第 5 步：建立测试
"为项目建立自动化测试"

→ auto-qa 执行
   生成测试框架
   创建 E2E 测试用例
   配置 CI/CD 集成

# 第 6 步：版本控制
"提交代码并推送到 GitHub"

→ git-master 执行
   git add .
   git commit -m "feat: 项目标准化和测试基础设施"
   gh repo create
   git push -u origin main
```

**完整输出示例**：

```
┌─ 接手老项目完整工作流 ─────────────┐
│                                    │
│  第 1 步：项目分析                  │
│    ✅ 理解架构和功能                │
│    ✅ 生成项目文档                  │
│                                    │
│  第 2 步：质量审计                  │
│    ✅ 识别技术债务                  │
│    ✅ 评估风险和收益                │
│                                    │
│  第 3 步：优化方案（自动编排）       │
│    ✅ 发散：20+ 方案                │
│    ✅ 收敛：选择 P0/P1/P2           │
│    ✅ 输出：执行计划                │
│                                    │
│  第 4 步：标准化                    │
│    ✅ 目录结构重构                  │
│    ✅ 配置文件注入                  │
│    ✅ 文档生成                      │
│                                    │
│  第 5 步：测试建立                  │
│    ✅ 测试框架搭建                  │
│    ✅ E2E 测试用例                  │
│    ✅ CI/CD 集成                    │
│                                    │
│  第 6 步：版本控制                  │
│    ✅ Git 仓库创建                  │
│    ✅ 代码提交和推送                │
│                                    │
└────────────────────────────────────┘

项目状态：混乱 → 标准化 → 可维护
```

---

### 场景 2：新项目从零开始

```bash
# 第 1 步：初始化项目
mkdir my-new-project
cd my-new-project
npm create vite@latest

# 第 2 步：配置权限
~/.claude/skills/setup-project-permissions.sh
选择：3) 两个技能都需要

# 第 3 步：项目分析（验证）
"分析这个项目的架构"

→ project-analyst
   确认技术栈正确
   生成初始文档

# 第 4 步：标准化（可选，如果 create-vite 不够）
"标准化项目结构"

→ project-init
   添加更多配置
   完善目录结构

# 第 5 步：建立测试
"为项目建立自动化测试"

→ auto-qa
   Playwright E2E 测试
   Vitest 单元测试

# 第 6 步：初始化 Git
git init
git add .
git commit -m "feat: 初始化项目"

# 第 7 步：推送到 GitHub
"创建 GitHub 仓库并推送"

→ git-master
   gh repo create my-new-project --public
   git push -u origin main
```

---

## 🎯 总结

### 使用流程图

```
┌─ 新项目 ─────────────────────────────┐
│                                      │
│  1. npm create vite@latest           │
│  2. setup-project-permissions.sh    │
│  3. project-analyst（验证）          │
│  4. project-init（标准化）           │
│  5. auto-qa（测试）                  │
│  6. git-master（版本控制）           │
│                                      │
└──────────────────────────────────────┘

┌─ 老项目 ─────────────────────────────┐
│                                      │
│  1. project-analyst（理解）          │
│  2. project-analyst（审计）          │
│  3. problem-solver（方案）           │
│  4. project-init（标准化）           │
│  5. auto-qa（测试）                  │
│  6. git-master（版本控制）           │
│                                      │
└──────────────────────────────────────┘

┌─ 问题解决 ───────────────────────────┐
│                                      │
│  "如何优化 X"                        │
│    ↓                                 │
│  problem-solver（自动编排）          │
│    → brainstorm（发散 20+ 方案）    │
│    → debate（收敛选择最优）          │
│    → 输出执行计划                    │
│                                      │
└──────────────────────────────────────┘
```

---

## 💡 提示

1. **首次使用**：先运行 `setup-project-permissions.sh` 配置权限
2. **新项目**：从 project-init 开始建立标准结构
3. **老项目**：先用 project-analyst 理解，再标准化
4. **复杂问题**：直接使用 problem-solver 自动编排
5. **Git 操作**：使用 git-master 自动化版本控制

---

**相关文档**：
- [PERMISSION-GUIDE.md](./PERMISSION-GUIDE.md) - 权限管理详解
- [SKILLS-ECOSYSTEM.md](./SKILLS-ECOSYSTEM.md) - 技能生态总览
