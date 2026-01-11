# Auto-QA 技能示例集

本文档包含 `auto-qa.md` 技能的详细示例，用于脚本驱动模式的测试实践。

---

## 示例 1：登录功能 E2E 测试

### 场景
User: "帮我写登录功能的测试"

### 测试策略
1. P0 场景：正常登录、密码错误、账号不存在
2. P1 场景：记住密码、第三方登录
3. P2 场景：网络超时、账号锁定

### 步骤 1：生成测试文件 `tests/e2e/login.spec.ts`

```typescript
import { test, expect } from '@playwright/test'
import { LoginPage } from '../pages/LoginPage'

test.describe('登录功能', () => {
  let loginPage

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page)
    await loginPage.goto()
  })

  test('用户登录成功', async ({ page }) => {
    await loginPage.login('user@example.com', 'password123')
    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('h1')).toContainText('欢迎')
  })

  test('密码错误显示提示', async ({ page }) => {
    await loginPage.login('user@example.com', 'wrongpassword')
    await expect(loginPage.errorMessage).toContainText('密码错误')
  })

  test('表单验证', async ({ page }) => {
    await loginPage.loginButton.click()
    await expect(loginPage.usernameInput).toHaveAttribute('required')
  })
})
```

### 步骤 2：生成执行脚本 `run-login-tests.sh`

```bash
#!/bin/bash
# 登录功能测试执行脚本

echo "🧪 开始测试登录功能..."
cd "$(dirname "$0")"

# 检查依赖
if ! command -v npx &> /dev/null; then
  echo "❌ 错误: 未找到 npx，请先安装 Node.js"
  exit 1
fi

# 运行测试
npx playwright test tests/e2e/login.spec.ts --reporter=list

# 检查结果
if [ $? -eq 0 ]; then
  echo "✅ 所有登录测试通过"
  exit 0
else
  echo "❌ 登录测试失败，请查看上方详细日志"
  exit 1
fi
```

### 步骤 3：执行测试

```bash
chmod +x run-login-tests.sh
./run-login-tests.sh
```

---

## 示例 2：应用日志分析

### 场景
User: "查看应用错误日志"

### 步骤 1：生成日志分析脚本 `analyze-errors.sh`

```bash
#!/bin/bash
# 应用错误日志分析脚本

LOG_FILE="${1:-logs/app.log}"
REPORT_FILE="error-report-$(date +%Y%m%d).txt"

echo "📊 错误日志分析报告" > "$REPORT_FILE"
echo "生成时间: $(date)" >> "$REPORT_FILE"
echo "日志文件: $LOG_FILE" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"

# 统计各级别日志
error_count=$(grep -c "ERROR" "$LOG_FILE" 2>/dev/null || echo "0")
warn_count=$(grep -c "WARN" "$LOG_FILE" 2>/dev/null || echo "0")
fatal_count=$(grep -c "FATAL" "$LOG_FILE" 2>/dev/null || echo "0")

echo "" >> "$REPORT_FILE"
echo "📈 统计摘要" >> "$REPORT_FILE"
echo "  严重错误(FATAL): $fatal_count" >> "$REPORT_FILE"
echo "  错误(ERROR): $error_count" >> "$REPORT_FILE"
echo "  警告(WARN): $warn_count" >> "$REPORT_FILE"

# 提取错误详情
echo "" >> "$REPORT_FILE"
echo "🔥 Top 10 错误详情" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
grep "ERROR" "$LOG_FILE" | head -10 >> "$REPORT_FILE"

# 输出到终端
cat "$REPORT_FILE"

# 如果有严重错误，返回非零退出码
if [ "$fatal_count" -gt 0 ]; then
  echo "⚠️  发现 $fatal_count 个严重错误！"
  exit 1
fi
```

### 步骤 2：执行分析

```bash
chmod +x analyze-errors.sh
./analyze-errors.sh
```

---

## 示例 3：CI/CD 完整测试脚本

### 场景
User: "创建一个完整的测试脚本用于 CI/CD"

### 生成测试脚本 `ci-test.sh`

```bash
#!/bin/bash
# CI/CD 完整测试流程
set -e  # 任何步骤失败立即退出

echo "🚀 开始 CI/CD 测试流程..."

# 1. 环境检查
echo "📋 检查环境..."
node --version
npm --version

# 2. 安装依赖
echo "📦 安装依赖..."
npm ci

# 3. 代码检查
echo "🔍 运行 ESLint..."
npm run lint

# 4. 类型检查
echo "🔬 运行 TypeScript 检查..."
npm run type-check

# 5. 单元测试
echo "🧪 运行单元测试..."
npm run test:unit -- --ci --coverage

# 6. E2E 测试
echo "🎭 运行 E2E 测试..."
npm run test:e2e

# 7. 构建验证
echo "🏗️  验证构建..."
npm run build

# 8. 性能测试（可选）
if [ "$RUN_PERFORMANCE_TEST" = "true" ]; then
  echo "⚡ 运行性能测试..."
  npm run test:performance
fi

echo "✅ 所有测试通过！"
exit 0
```

### 使用方式

```bash
# 本地运行
./ci-test.sh

# CI 中运行
RUN_PERFORMANCE_TEST=true ./ci-test.sh
```

---

## 示例 4：带日志捕获的 E2E 测试（最佳实践）

### 场景
User: "为前端项目生成 Playwright 测试，包含日志捕获和结果分析"

### 步骤 1：生成测试脚本 `tests/e2e/with-logging.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { promises as fs } from 'fs';
import path from 'path';

// 日志文件路径
const LOG_FILE = path.join(process.cwd(), 'browser.log');

test.beforeAll(async () => {
  // 清空旧日志
  await fs.writeFile(LOG_FILE, '');
});

test.describe('登录功能测试（带日志捕获）', () => {
  test('用户登录成功', async ({ page }) => {
    // ========== 日志捕获逻辑 ==========
    const logs: string[] = [];

    // 监听所有浏览器控制台输出
    page.on('console', async (msg) => {
      const logType = msg.type();
      const logText = msg.text();

      // 格式化日志
      const formattedLog = `[${logType.toUpperCase()}] ${logText}`;
      logs.push(formattedLog);

      // 同时写入文件
      await fs.appendFile(LOG_FILE, formattedLog + '\n');
    });

    // 监听页面错误
    page.on('pageerror', async (error) => {
      const errorLog = `[PAGE ERROR] ${error.message}\n${error.stack}`;
      logs.push(errorLog);
      await fs.appendFile(LOG_FILE, errorLog + '\n');
    });

    // 监听请求失败
    page.on('requestfailed', async (request) => {
      const failLog = `[REQUEST FAILED] ${request.url()} - ${request.failure()?.errorText}`;
      logs.push(failLog);
      await fs.appendFile(LOG_FILE, failLog + '\n');
    });

    // ========== 测试逻辑 ==========
    await page.goto('http://localhost:3000/login');

    // 填写表单
    await page.fill('#username', 'test@example.com');
    await page.fill('#password', 'password123');
    await page.click('button[type="submit"]');

    // 等待导航
    await page.waitForURL('/dashboard');

    // 验证登录成功
    await expect(page.locator('h1')).toContainText('欢迎');

    // ========== 输出日志摘要 ==========
    console.log('\n📋 测试执行日志摘要：');
    console.log(`总共捕获 ${logs.length} 条日志`);
    console.log(`详细日志已保存到: ${LOG_FILE}`);
  });

  test.afterAll(async () => {
    // 测试结束后输出统计
    const logContent = await fs.readFile(LOG_FILE, 'utf-8');
    const errorCount = (logContent.match(/ERROR/g) || []).length;
    const warnCount = (logContent.match(/WARN/g) || []).length;

    console.log(`\n📊 日志统计: ERROR=${errorCount}, WARN=${warnCount}`);
  });
});
```

### 步骤 2：生成执行脚本 `run-e2e-with-logs.sh`

```bash
#!/bin/bash
set -e

echo "🧪 开始执行 E2E 测试（带日志捕获）..."

# 清理旧日志
rm -f browser.log

# 运行测试（静默模式，只输出关键信息）
npx playwright test tests/e2e/with-logging.spec.ts --reporter=line 2>&1 | tee test-output.txt

# 检查测试是否通过
TEST_EXIT_CODE=${PIPESTATUS[0]}

if [ $TEST_EXIT_CODE -eq 0 ]; then
  echo "✅ 测试通过"
else
  echo "❌ 测试失败"
fi

# ========== 结果分析 ==========
echo ""
echo "📊 测试结果分析"
echo "===================="

# 检查日志文件是否存在
if [ -f "browser.log" ]; then
  LOG_SIZE=$(wc -l < browser.log)
  echo "📝 浏览器日志: $LOG_SIZE 行"

  # 统计错误和警告
  ERROR_COUNT=$(grep -c "ERROR" browser.log || echo "0")
  WARN_COUNT=$(grep -c "WARN" browser.log || echo "0")
  PAGE_ERROR_COUNT=$(grep -c "PAGE ERROR" browser.log || echo "0")
  REQ_FAIL_COUNT=$(grep -c "REQUEST FAILED" browser.log || echo "0")

  echo "❌ 错误数: $ERROR_COUNT"
  echo "⚠️  警告数: $WARN_COUNT"
  echo "💥 页面错误: $PAGE_ERROR_COUNT"
  echo "🔴 请求失败: $REQ_FAIL_COUNT"

  # 只显示最后 50 行日志（如果有关键问题）
  if [ $ERROR_COUNT -gt 0 ] || [ $PAGE_ERROR_COUNT -gt 0 ]; then
    echo ""
    echo "🔥 最后 50 行日志："
    echo "===================="
    tail -50 browser.log
  fi

  # 提取关键错误信息
  echo ""
  echo "🎯 关键错误摘要："
  echo "===================="
  grep -E "ERROR|PAGE ERROR|REQUEST FAILED" browser.log | tail -20

else
  echo "⚠️  未找到浏览器日志文件"
fi

# 根据结果决定退出码
if [ $TEST_EXIT_CODE -eq 0 ] && [ $ERROR_COUNT -eq 0 ]; then
  echo ""
  echo "✅ 所有检查通过"
  exit 0
else
  echo ""
  echo "⚠️  发现问题，请查看上方详细信息"
  exit 1
fi
```

### 步骤 3：执行测试

```bash
chmod +x run-e2e-with-logs.sh
./run-e2e-with-logs.sh
```

### 输出示例

```
🧪 开始执行 E2E 测试（带日志捕获）...
Running 2 tests using 1 worker

  ✓ [chromium] › with-logging.spec.ts:5:1 › 登录功能测试（带日志捕获） › 用户登录成功 (2.3s)

  1 passed (2.5s)

✅ 测试通过

📊 测试结果分析
====================
📝 浏览器日志: 127 行
❌ 错误数: 0
⚠️  警告数: 3
💥 页面错误: 0
🔴 请求失败: 0

🔥 最后 50 行日志：
====================
[LOG] Login form initialized
[LOG] User input: test@example.com
[LOG] Password input received
[LOG] Submit button clicked
[LOG] API call to /api/auth/login
[LOG] Login successful, redirecting to /dashboard
[WARN] Session storage almost full
...

🎯 关键错误摘要：
====================

✅ 所有检查通过
```

---

## Token 消耗对比

| 方式 | Token 消耗 | 说明 |
|------|-----------|------|
| **Claude 工具调用** | ~5000-10000 | 测试执行过程中的每次交互都消耗 |
| **脚本驱动模式** | ~500-1000 | 仅生成脚本和分析结果 |

**节省比例：80-90%** ✅
