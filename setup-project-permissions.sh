#!/bin/bash
# 项目权限配置辅助脚本
# 用途：为 project-analyst 和 project-init 技能配置必要权限

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🔧 Claude Code 项目权限配置工具"
echo "================================"
echo ""

# 检测项目根目录
echo "📂 Step 1: 检测项目根目录"
if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "pom.xml" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ] || [ -d ".git" ]; then
  echo -e "${GREEN}✅ 项目根目录: $(pwd)${NC}"
else
  echo -e "${YELLOW}⚠️  未检测到项目特征文件${NC}"
  echo "请确保在项目根目录运行此脚本"
  exit 1
fi
echo ""

# 检查 .claude 目录
echo "📁 Step 2: 检查 .claude 目录"
CLAUDE_DIR=".claude"
if [ -d "$CLAUDE_DIR" ]; then
  echo -e "${GREEN}✅ .claude 目录已存在${NC}"
else
  echo -e "${YELLOW}⚠️  .claude 目录不存在，正在创建...${NC}"
  mkdir -p "$CLAUDE_DIR"
  echo -e "${GREEN}✅ .claude 目录已创建${NC}"
fi
echo ""

# 检查现有配置
echo "🔍 Step 3: 检查现有权限配置"
SETTINGS_FILE=".claude/settings.local.json"
if [ -f "$SETTINGS_FILE" ]; then
  echo -e "${YELLOW}⚠️  发现现有配置文件${NC}"

  # 备份现有配置
  BACKUP_FILE=".claude/settings.local.json.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP_FILE"
  echo -e "${GREEN}✅ 已备份现有配置到: $BACKUP_FILE${NC}"

  # 读取现有配置
  echo ""
  echo "现有权限配置："
  cat "$SETTINGS_FILE" | grep -A 10 "permissions" || echo "无法解析权限配置"
  echo ""

  read -p "是否更新现有配置？(y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "取消配置"
    exit 0
  fi
else
  echo -e "${YELLOW}⚠️  配置文件不存在${NC}"
fi
echo ""

# 选择技能
echo "🎯 Step 4: 选择需要的技能"
echo "1) project-analyst（项目分析）"
echo "2) project-init（项目标准化）"
echo "3) 两个技能都需要"
echo "4) 自定义权限"
read -p "请选择 [1-4]: " choice

case $choice in
  1)
    SKILL="project-analyst"
    PERMISSIONS='"Read(./)", "Write(./)"'
    ;;
  2)
    SKILL="project-init"
    PERMISSIONS='"Read(./)", "Write(./)", "Bash(cd,ls,cat,mkdir,cp,mv)"'
    ;;
  3)
    SKILL="project-analyst + project-init"
    PERMISSIONS='"Read(./)", "Write(./)", "Bash(cd,ls,cat,mkdir,cp,mv)"'
    ;;
  4)
    echo "自定义权限模式"
    read -p "请输入权限规则（如: Read(./), Write(./)）: " PERMISSIONS
    SKILL="custom"
    ;;
  *)
    echo "无效选择"
    exit 1
    ;;
esac
echo ""

# 生成配置文件
echo "📝 Step 5: 生成配置文件"
cat > "$SETTINGS_FILE" << EOF
{
  "permissions": {
    "allow": [
      $PERMISSIONS
    ],
    "comment": "Auto-generated for $SKILL skill",
    "generatedAt": "$(date -Iseconds)",
    "generator": "setup-project-permissions.sh"
  }
}
EOF

echo -e "${GREEN}✅ 配置文件已生成: $SETTINGS_FILE${NC}"
echo ""

# 显示配置内容
echo "📋 配置内容："
cat "$SETTINGS_FILE"
echo ""

# 验证配置
echo "🔍 Step 6: 验证配置"
if [ -f "$SETTINGS_FILE" ]; then
  echo -e "${GREEN}✅ 配置文件存在${NC}"
  if grep -q "permissions" "$SETTINGS_FILE"; then
    echo -e "${GREEN}✅ 权限配置正确${NC}"
  else
    echo -e "${RED}❌ 权限配置格式错误${NC}"
    exit 1
  fi
else
  echo -e "${RED}❌ 配置文件生成失败${NC}"
  exit 1
fi
echo ""

# 完成
echo "================================"
echo -e "${GREEN}✅ 权限配置完成！${NC}"
echo ""
echo "现在可以使用以下技能："
echo "  • project-analyst: 分析项目架构"
echo "  • project-init: 标准化项目结构"
echo ""
echo "如需撤销，可恢复备份："
if [ -n "$BACKUP_FILE" ]; then
  echo "  cp $BACKUP_FILE $SETTINGS_FILE"
fi
