# Claude Code 权限管理指南

## 📋 目录

1. [为什么需要权限管理？](#为什么需要权限管理)
2. [权限体系架构](#权限体系架构)
3. [快速配置](#快速配置)
4. [权限配置详解](#权限配置详解)
5. [技能权限检测](#技能权限检测)
6. [最佳实践](#最佳实践)
7. [故障排除](#故障排除)
8. [安全建议](#安全建议)

---

## 为什么需要权限管理？

### 问题背景

Claude Code 使用 **沙箱机制** 保护系统安全：
- 技能无法随意访问文件系统
- 需要明确授权才能读写文件
- 全局权限和项目权限分层控制

### 当前挑战

```
全局权限配置：
  ~/.claude/settings.local.json
  ✅ 允许访问技能文件
  ❌ 不包含项目文件

项目级需求：
  project-analyst: 需要读取项目代码
  project-init: 需要修改项目结构
  → 每个项目需要单独配置
```

### 解决方案

```
智能检测 + 一键配置 + 最小化权限
```

---

## 权限体系架构

### 两层权限模型

```
┌─ 全局权限 ─────────────────────────┐
│                                     │
│  ~/.claude/settings.local.json      │
│                                     │
│  • 控制技能文件访问                 │
│  • 控制系统级操作                   │
│  • 所有项目共享                     │
│                                     │
└─────────────────────────────────────┘
                ↓
┌─ 项目权限 ─────────────────────────┐
│                                     │
│  <project>/.claude/settings.local.json│
│                                     │
│  • 控制项目文件访问                 │
│  • 项目特定配置                     │
│  • 优先级高于全局                   │
│                                     │
└─────────────────────────────────────┘
```

### 优先级规则

```
项目权限 > 全局权限

例子：
  全局: Allow Read(//home/kfc/**)
  项目: Allow Read(./)

  结果: 只能访问 ./ 当前项目
```

---

## 快速配置

### 方式 1: 一键配置脚本 ⭐ 推荐

```bash
# 在项目根目录运行
~/.claude/skills/setup-project-permissions.sh

# 交互式界面：
🔧 Claude Code 项目权限配置工具
================================

📂 Step 1: 检测项目根目录
✅ 项目根目录: /path/to/your-project

🎯 Step 4: 选择需要的技能
1) project-analyst（项目分析）
2) project-init（项目标准化）
3) 两个技能都需要 ← 推荐
4) 自定义权限

请选择 [1-4]: 3

✅ 权限配置完成！
```

**特点**：
- ✅ 自动检测项目根目录
- ✅ 备份现有配置
- ✅ 交互式选择技能
- ✅ 权限最小化
- ✅ 自动验证

---

### 方式 2: 技能自动检测

启动 `project-analyst` 或 `project-init` 时：

```
启动技能
  ↓
技能检测权限
  ↓
⚠️  缺少项目级写权限
  ↓
显示一键配置脚本：
  mkdir -p .claude
  cat > .claude/settings.local.json << 'EOF'
  {
    "permissions": {
      "allow": ["Read(./)", "Write(./)"]
    }
  }
  EOF
  ↓
用户复制执行
  ↓
技能继续运行
```

**特点**：
- ✅ 无需提前配置
- ✅ 技能自动提示
- ✅ 即配置即用

---

### 方式 3: 手动配置

```bash
# 创建配置文件
mkdir -p .claude

# 写入权限配置
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)"
    ],
    "comment": "Manual configuration"
  }
}
EOF
```

**适用场景**：
- 需要自定义权限
- 自动化脚本集成
- 批量配置多个项目

---

## 权限配置详解

### 基础权限类型

#### Read 权限

```json
"Read(./)"
```

**作用**：允许读取项目文件

**适用技能**：
- `project-analyst`（分析代码）
- `auto-qa`（读取日志）

**范围**：
- `./` - 仅当前目录
- `./src` - 仅 src 目录
- `//home/kfc/**` - 整个目录（不推荐）

---

#### Write 权限

```json
"Write(./)"
```

**作用**：允许写入项目文件

**适用技能**：
- `project-analyst`（生成文档）
- `project-init`（创建配置）
- `git-master`（创建 .gitignore）

**范围**：
- `./` - 仅当前目录
- `./docs` - 仅 docs 目录

---

#### Bash 权限

```json
"Bash(cd,ls,cat,mkdir)"
```

**作用**：允许执行特定命令

**适用技能**：
- `project-init`（创建目录）
- `git-master`（git 命令）

**推荐命令**：
- `cd` - 切换目录
- `ls` - 列出文件
- `cat` - 读取文件
- `mkdir` - 创建目录
- `cp` - 复制文件
- `mv` - 移动文件

**不推荐**：
- `Bash(*)` - 所有命令（太危险）
- `Bash(rm)` - 删除命令（风险高）
- `Bash(sh)` - Shell 执行（不安全）

---

### 权限组合示例

#### 最小化配置（推荐）

```json
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)"
    ]
  }
}
```

**适用**：大部分项目

---

#### project-analyst 配置

```json
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)",
      "Bash(cd,ls,cat,find,head)"
    ]
  }
}
```

**说明**：
- Read: 读取代码
- Write: 生成文档
- Bash: 文件查找和预览

---

#### project-init 配置

```json
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)",
      "Bash(cd,ls,cat,mkdir,cp,mv)"
    ]
  }
}
```

**说明**：
- Read: 读取现有配置
- Write: 创建新文件
- Bash: 目录操作和文件复制

---

#### 开放配置（不推荐）

```json
{
  "permissions": {
    "allow": [
      "Read(//home/kfc/**)",
      "Write(//home/kfc/**)",
      "Bash(*)"
    ]
  }
}
```

**风险**：
- ❌ 可能访问其他项目
- ❌ 可能执行危险命令
- ❌ 违反最小权限原则

---

## 技能权限检测

### project-analyst 检测流程

```bash
Step 1: 检测项目根目录
  → 查找 package.json / requirements.txt / pom.xml / .git

Step 2: 检查权限配置
  → 检查 .claude/settings.local.json 是否存在

Step 3: 验证权限
  → 检查是否有 Read(./) 和 Write(./)

Step 4: 结果
  ├─ 有权限 → ✅ 继续运行
  ├─ 无权限 → ⚠️  显示配置脚本
  └─ 无文件 → ⚠️  提示创建配置
```

### project-init 检测流程

```bash
Step 1-3: 同 project-analyst

Step 4: 额外检查
  → 检查是否有 Bash(cd,ls,mkdir,cp)

Step 5: 备份提醒
  → 提示用户先提交代码或创建备份分支
```

---

## 最佳实践

### 1. 最小权限原则

```yaml
✅ 推荐:
  仅授予必要的最小权限
  Read(./) + Write(./)

❌ 不推荐:
  授予过宽权限
  Write(//home/kfc/**)
```

### 2. 项目隔离

```bash
# 每个项目独立配置
/project-a/.claude/settings.local.json
/project-b/.claude/settings.local.json

# 不要跨项目共享权限
```

### 3. 版本控制

```bash
# .claude/settings.local.json 不提交
echo ".claude/" >> .gitignore

# 但可以提交模板
cp .claude/settings.local.json .claude/settings.template.json
```

### 4. 定期审计

```bash
# 定期检查权限配置
cat .claude/settings.local.json | jq '.permissions'

# 确保权限范围合理
```

### 5. 备份配置

```bash
# 修改前备份
cp .claude/settings.local.json .claude/settings.backup.json

# 或使用脚本自动备份（脚本会自动备份）
```

---

## 故障排除

### 问题 1: 技能提示权限不足

**现象**：
```
⚠️  缺少项目级写权限
```

**解决**：
```bash
# 方式 A: 使用一键脚本
~/.claude/skills/setup-project-permissions.sh

# 方式 B: 手动配置
mkdir -p .claude
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": ["Read(./)", "Write(./)"]
  }
}
EOF
```

---

### 问题 2: 配置后仍提示权限不足

**原因**：配置文件格式错误

**检查**：
```bash
# 验证 JSON 格式
cat .claude/settings.local.json | jq .

# 如果报错，说明格式有问题
```

**解决**：
```bash
# 重新生成正确配置
~/.claude/skills/setup-project-permissions.sh
```

---

### 问题 3: 技能无法读取文件

**检查**：
```bash
# 确认权限包含 Read
grep "Read" .claude/settings.local.json

# 确认权限范围正确
grep "Read(./)" .claude/settings.local.json
```

**解决**：
```bash
# 添加 Read 权限
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": ["Read(./)", "Write(./)"]
  }
}
EOF
```

---

### 问题 4: 全局权限冲突

**现象**：全局权限限制了项目权限

**检查**：
```bash
# 查看全局权限
cat ~/.claude/settings.local.json | jq '.permissions'
```

**解决**：
```bash
# 项目权限优先级更高
# 确保项目配置正确
cat .claude/settings.local.json | jq '.permissions'
```

---

## 安全建议

### ✅ DO（推荐做法）

```yaml
权限范围:
  • 使用相对路径 (./)
  • 限制在当前项目
  • 只授予必要权限

配置管理:
  • 备份现有配置
  • 定期审计权限
  • 使用脚本自动生成

版本控制:
  • .claude/ 加入 .gitignore
  • 提交权限模板文件
```

### ❌ DON'T（避免做法）

```yaml
权限范围:
  • 不要使用绝对路径 (/**)
  • 不要包含整个用户目录
  • 不要授予 Bash(*)

配置管理:
  • 不要手动编辑（易出错）
  • 不要复制其他项目配置
  • 不要忽略备份

安全风险:
  • 不要在生产环境测试
  • 不要在敏感项目使用宽泛权限
```

---

## 附录

### A. 配置文件完整示例

```json
{
  "permissions": {
    "allow": [
      "Read(./)",
      "Write(./)",
      "Bash(cd,ls,cat,head,mkdir)"
    ],
    "comment": "Configuration for project-analyst and project-init",
    "generatedAt": "2026-01-11T10:00:00+08:00",
    "generator": "setup-project-permissions.sh",
    "project": "/path/to/project"
  }
}
```

### B. 权限检测脚本示例

```bash
#!/bin/bash
# 检查项目权限配置

check_permissions() {
  local project_dir="${1:-.}"

  if [ ! -f "$project_dir/.claude/settings.local.json" ]; then
    echo "❌ 权限配置文件不存在"
    return 1
  fi

  if grep -q '"Read(./)"' "$project_dir/.claude/settings.local.json" && \
     grep -q '"Write(./)"' "$project_dir/.claude/settings.local.json"; then
    echo "✅ 权限配置正确"
    return 0
  else
    echo "⚠️  权限配置不完整"
    return 1
  fi
}

check_permissions "$@"
```

### C. 相关文档

- [SKILLS-ECOSYSTEM.md](./SKILLS-ECOSYSTEM.md) - 技能生态系统总览
- [project-analyst.md](./project-analyst.md) - 项目分析技能
- [project-init.md](./project-init.md) - 项目标准化技能
- [setup-project-permissions.sh](./setup-project-permissions.sh) - 一键配置脚本

---

## 🎯 总结

```
┌─────────────────────────────────────────┐
│         权限管理核心原则                │
├─────────────────────────────────────────┤
│                                         │
│  1. 最小权限原则                        │
│     → 仅授予必要的最小权限              │
│                                         │
│  2. 项目隔离                            │
│     → 每个项目独立配置                  │
│                                         │
│  3. 智能检测                            │
│     → 技能自动提示配置                  │
│                                         │
│  4. 一键配置                            │
│     → 使用脚本自动生成                  │
│                                         │
│  5. 安全第一                            │
│     → 不自动覆盖，权限最小化            │
│                                         │
└─────────────────────────────────────────┘
```

**记住**：权限管理是安全的基础，请遵循最佳实践！
