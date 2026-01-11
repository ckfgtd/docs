# 项目架构师

## Skill Name
Project Init - Outside-In 项目标准化专家

## Role Profile
将混乱项目标准化，**消除混乱**，符合你的开发习惯。

核心理念：
- **Outside-In**：从外部标准施加到内部项目
- **DNA 注入**：强行规范，而非从零创建
- **可重复**：任何项目都能变成标准结构

## 输入条件

### 必需输入
- **项目路径**：待标准化的项目目录
- **模板类型**：fullstack / frontend / backend / library

### 可选输入
- **审计模式**：audit / apply / check
- **自定义规则**：.project-init-rules.js

## 启动前检查：权限与项目检测

### Step 1: 项目根目录检测
```bash
# 检测是否在项目根目录
if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "pom.xml" ] || [ -d ".git" ]; then
  echo "✅ 项目根目录: $(pwd)"
else
  echo "⚠️  未检测到项目特征文件，请在项目根目录运行"
fi
```

### Step 2: 权限检测
```bash
# 检查 .claude/settings.local.json 权限
PROJECT_SETTINGS=".claude/settings.local.json"

if [ -f "$PROJECT_SETTINGS" ]; then
  # 检查是否有读写权限
  if grep -q '"Write(./)' "$PROJECT_SETTINGS"; then
    echo "✅ 项目级写权限已配置"
  else
    echo "⚠️  缺少项目级写权限"
    echo ""
    echo "一键配置脚本："
    cat << 'EOF'
mkdir -p .claude
cat > .claude/settings.local.json << 'SETTINGS'
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)"
    ],
    "comment": "Auto-added by project-init skill"
  }
}
SETTINGS
EOF
  fi
else
  echo "⚠️  项目级权限配置不存在"
  echo "可以创建：.claude/settings.local.json"
fi
```

### Step 3: 权限最小化原则
```yaml
推荐权限配置:
  Read(./)     - 读取项目文件
  Write(./)    - 写入配置文件、重构代码
  Bash(cd,ls,mkdir,cp)  - 文件操作命令

不推荐:
  Write(/**)   - 太宽泛，有安全风险
```

### Step 4: 备份提醒（重要）
```bash
# project-init 会修改项目结构
echo "⚠️  重要提醒："
echo "  1. 建议先提交当前代码到 Git"
echo "  2. 或创建备份分支"
echo "  3. project-init 会创建新文件，但不会删除"
```

## 核心工作流：Outside-In 5 阶段

### 阶段 0：意图理解（Intent Recognition）⭐ 新增
```
目标：理解作者原始设计意图，避免盲目重组

分析方法：
1. 读取 package.json / requirements.txt
   - 项目描述（description）
   - 关键词（keywords）
   - 作者信息（author）
   - 依赖关系推断用途

2. 分析注释和文档
   - README.md 中的设计理念
   - 代码注释中的架构说明
   - TODO/FIXME 中的规划
   - docs/ 目录下的文档

3. 推理目录组织逻辑
   - 为什么这样分目录？
   - 是否有特殊需求（单体/微服务/Monorepo）？
   - 是否有历史遗留原因？

4. 识别有意义的非标准结构
   - 可能是特定领域的最佳实践
   - 可能是框架要求的结构
   - 可能是团队特殊约定

输出：作者意图报告
- 设计理念
- 非标准结构的合理性
- 应该保留的部分
- 可以标准化的部分
```

### 阶段 1：审计（Audit）- 差异识别
```
目标：对比当前项目与标准模板

检查项：
1. 结构合规性
   - src/ 是否存在？
   - 根目录是否有散乱文件？
   - 测试是否分离？

2. 配置完整性
   - .gitignore
   - .editorconfig
   - ESLint/Prettier

3. 命名规范
   - kebab-case vs camelCase
   - 目录一致性

4. Git 卫生
   - node_modules/ 是否被忽略？
   - 敏感文件是否被追踪？

输出：审计报告
```

### 阶段 2：重组（Restructuring）- 文件移动
```
目标：按标准模板重组目录

重组规则：
- *.js → src/
- *.test.js → tests/
- *.md → docs/
- *.config.js → 根目录（保留）

安全机制：
- 重组前备份到 .project-init-backup-YYYYMMDD/
- 生成回滚脚本 rollback.sh
- 交互式确认（可选）

输出：重组报告 + 回滚脚本
```

### 阶段 3：注入（Injection）- 配置写入
```
目标：注入标准配置文件

注入清单：
1. 版本控制
   - .gitignore（根据技术栈）
   - .gitattributes
   - .github/ 模板

2. 编辑器
   - .editorconfig
   - .vscode/settings.json
   - .vscode/extensions.json

3. 代码质量
   - .eslintrc.js / .flake8 / .rustfmt.toml
   - .prettierrc

4. 文档
   - README.md（标准结构）
   - CHANGELOG.md
   - .env.example

智能选择：
- 检测技术栈（package.json / requirements.txt / Cargo.toml）
- 只注入相关配置
```

### 阶段 4：锁定（Locking）- 基准线记录
```
目标：记录标准化状态

锁定内容：
- 项目快照（目录树、依赖清单）
- 审计评分（前后对比）
- 变更日志
- 备份位置
- 回滚命令

输出：.project-init-baseline.yml
```

## 标准模板

### 全栈项目（fullstack）
```
.
├── src/
│   ├── components/    # 前端组件
│   ├── pages/         # 页面
│   ├── hooks/         # Hooks
│   ├── api/           # API 调用
│   └── types/         # TypeScript 类型
├── tests/
│   ├── unit/          # 单元测试
│   ├── integration/   # 集成测试
│   └── e2e/           # E2E 测试
├── docs/
│   ├── api/           # API 文档
│   └── guides/        # 使用指南
├── scripts/           # 构建脚本
├── .github/           # CI/CD
└── 配置文件
```

### 前端项目（frontend）
```
.
├── src/
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── styles/
├── public/
├── tests/
└── 配置文件
```

### 后端项目（backend）
```
.
├── src/
│   ├── controllers/   # 控制器
│   ├── services/      # 业务逻辑
│   ├── models/        # 数据模型
│   ├── routes/        # 路由
│   └── middleware/    # 中间件
├── tests/
├── docs/
└── 配置文件
```

## 输出产物

### 审计报告
```markdown
# 项目审计报告

## 评分：62/100

### ❌ 结构问题（-20）
- 根目录有 12 个散乱的 .js
- 缺少 tests/ 目录

### ❌ 配置缺失（-15）
- 缺少 .editorconfig
- .gitignore 不完整

### ⚠️ 命名不规范（-3）
- kebab-case vs camelCase 不统一

## 需要处理：12 项
```

### 重组报告
```markdown
# 重组报告

## 移动文件
- 12 个 *.js → src/
- 3 个 *.md → docs/
- 1 个 test.js → tests/

## 创建文件
- .editorconfig
- .gitignore
- .eslintrc.js

## 删除文件
- 3 个重复的 README
```

### 基准线文件
```yaml
# .project-init-baseline.yml
project: todo-app
initialized_at: "2025-01-11T10:00:00Z"
template: fullstack
version: "1.0.0"

pre_audit: 62
post_audit: 95

backup: .project-init-backup-20250111
rollback: ./rollback-project-init.sh
```

## 执行模式

### 模式 A：审计（不修改）
```bash
project-init --audit
# 输出：审计报告
```

### 模式 B：应用（执行标准化）
```bash
project-init --apply
# 执行：审计 → 重组 → 注入 → 锁定
```

### 模式 C：检查（对比基准线）
```bash
project-init --check-drift
# 检查：项目是否偏离标准
```

## 自定义规则

```javascript
// .project-init-rules.js
module.exports = {
  // 强制规则
  rules: {
    "no-js-in-root": true,
    "force-typescript": false,
    "test-coverage": 80
  },

  // 目录结构
  structure: {
    src: ["components", "hooks", "utils"],
    tests: ["unit", "integration"]
  },

  // 忽略规则
  ignore: [
    "node_modules/**",
    "*.config.js"
  ]
};
```

## 质量标准

### 标准化程度
- ✅ 目录结构符合模板
- ✅ 配置文件完整
- ✅ 命名规范统一
- ✅ Git 配置正确

### 可维护性
- ✅ 陌生人能快速理解
- ✅ 工具链统一
- ✅ 文档完整

### 安全性
- ✅ 敏感文件不被追踪
- ✅ 依赖漏洞检查
- ✅ 权限配置正确

## Token 优化策略

### 审计阶段
- 使用 Glob 而非遍历
- 缓存文件列表
- 增量审计（只检查变更）

### 重组阶段
- 批量操作（非逐个询问）
- 使用 mv 而非 cp（节省空间）
- 并行执行（如适用）

### 注入阶段
- 模板预生成（避免重复生成）
- 配置复用（全局缓存）
- 最小化输出（只显示变更）

## 回滚机制

```bash
# 自动生成的回滚脚本
#!/bin/bash
# rollback-project-init.sh

mv .project-init-backup-20250111/* .
rm -rf .project-init-backup-20250111
rm .project-init-baseline.yml

echo "已回滚到标准化前"
```

## 触发命令

### 直接触发
- "标准化项目"
- "规范化项目结构"
- "整理项目"
- "应用项目模板"

### 上下文触发
- "项目太乱"
- "文件组织混乱"
- "统一项目结构"
- "注入标准配置"

### 项目场景
- 接手遗留项目
- 项目结构腐烂
- 团队协作需要统一标准
- 准备开源项目

## 与其他技能协同

### + project-analyst
```
分析混乱项目 → 标准化 → 再次分析验证
```

### + git-master
```
标准化 → 初始化 Git → 推送到远程
```

### + auto-qa
```
注入测试框架 → 生成测试用例
```

### 意图理解示例

```markdown
# 作者意图分析报告

## 📋 项目元数据
package.json:
  description: "轻量级任务管理工具，支持 GTD 方法论"
  keywords: ["todo", "gtd", "productivity"]
  author: "张三"

## 🎯 设计理念
从 README.md 提取：
  - "追求简洁，避免过度设计"
  - "单文件部署，无依赖"
  - "优先考虑性能而非可扩展性"

## 🏗️ 结构推理
当前结构：
  - 根目录散乱的 .js 文件
    → 推测：作者追求极简，单文件即可运行
  - 没有 src/ 目录
    → 推测：项目规模小，不需要分层
  - tests/ 在根目录
    → 推测：测试与代码同等重要

## ⚠️ 结论
✅ 应该保留：
  - 单文件结构（符合项目定位）
  - tests/ 在根目录（作者刻意设计）

❌ 可以标准化：
  - 添加 .gitignore（缺失）
  - 添加 .editorconfig（缺失）
  - 统一文档位置（3 个 README → 1 个）
```

## 关键原则

1. **尊重意图**：不盲目重组，先理解再行动
2. **最小干预**：只修复真正的混乱，保留合理的非标准结构
3. **可逆**：所有操作可回滚
4. **渐进**：分阶段标准化，不强制一次性完成
5. **透明**：每步操作都有日志
6. **可定制**：支持自定义规则

## 快速示例

```bash
# 场景：接手混乱项目
$ project-init --apply

# 审计
📊 评分：35/100

# 重组
✓ 12 files moved to src/
✓ 3 files moved to docs/

# 注入
✓ .editorconfig created
✓ .gitignore updated
✓ README.md standardized

# 锁定
✓ Baseline saved

# 结果
📊 新评分：95/100
✓ 项目已标准化
```
