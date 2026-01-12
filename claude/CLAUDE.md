# AI Agent Execution Protocol (Standard)

## 1. 核心准则 (Core & Style)

- **沟通**：中文回复；**零客套**，直接输出；适度使用 emoji 区分模块。
- **编码**：单引号 `'string'`；函数 `camelCase`；常量 `UPPER_SNAKE`；**严禁**在代码中使用 `...` 占位符。
- **原则**：**实证主义**。禁止假设，不确定即搜索/读取；Shell 报错必须用 `2>&1` 捕获全量信息。


## 2. 文件操作与评估 (File Ops)

- **PDF 处理**：优先 `pdftotext -layout`；文本 >50 字直接分析，否则视为扫描件调用视觉工具。
- **读取禁令**：严禁 `head`/`tail` 截断读取；严禁在读取前 N 行后下结论。
- **大规模文件 (>3000 行)**：
  - 禁止全量读取。按页码/逻辑段落分流。
  - **验证**：声称"缺失"前，必须执行 `rg -i -C 2 "keyword"`。
- **编辑策略**：
  - **原子化**：单次修改 <50 行。修改前必须重新 `Read` 目标行及其上下文。
  - **唯一性**：`str_replace` 的 `old_str` 必须包含函数头/唯一锚点，严禁仅用 `}` 或 `return`。
  - **大规模替换**：>3 处修改强制使用 `mcp__edit_file` (如有) 或重写整个文件。


## 3. 大文档与 Web 处理 (Deep Crawl)

- **场景**：API 文档、>5万行代码库、W3C 规范。
- **方法**：
  1. 执行 `sed`/`grep` 提取目录结构，生成 `map.txt`。
  2. 使用 `python3` 脚本配合 `requests` + `html2text` 精准抓取，禁止全网页 `markdownify`。
- **输出**：仅展示包含【路径、行数/大小、处理耗时】的统计表格。


## 4. 学术搜索与真伪校验 (Scholar Workflow)

### 4.1 检索链

```
OpenAlex (API) -> DBLP -> CrossRef -> arXiv -> 作者主页
```

### 4.2 多源校验

- **已发表论文**：必须满足 **DBLP 记录 + OpenAlex DOI 匹配**
- **预印本/在审论文**：检索 `github.io` 路径模式：
  ```
  /assets/pubs/
  /publications/
  /paper/
  ```

### 4.3 DOI 深度解析

必须校验：年份、卷期、页码、作者排序。

命名模式识别：
```
hivetee-tifs26.pdf → 投稿 TIFS 2026
ccai-micro25.pdf   → 投稿 MICRO 2025
```

### 4.4 硬性要求

- **严禁**仅根据单一数据库结果判定论文"不存在"
- **严禁**标题对上即认为验证通过，必须核对 DOI/卷期/作者


## 5. 调试与错误治理 (Troubleshooting)

### 5.1 API 与代理

**网络诊断**：响应为空时，先检查代理

```bash
curl -v "https://api.openalex.org/..." 2>&1 | grep proxy
```

**绕过代理**：

```bash
curl -s --noproxy "*" "https://api.openalex.org/..."
```

### 5.2 DBLP 空结果处理

```python
# ❌ 错误：空结果时 KeyError
hits = d['result']['hits']['hit']

# ✅ 正确：先检查 @total
total = d['result']['hits'].get('@total', '0')
hits = d['result']['hits'].get('hit', []) if total != '0' else []
```

### 5.3 OpenAlex 精确搜索

```bash
# ❌ search 太宽泛：38289 条不相关结果
curl "api.openalex.org/works?search=ccAI"

# ✅ filter 参数精确匹配
curl "api.openalex.org/works?filter=title.search:Compatible%20and%20Confidential"
```

### 5.4 JSON 安全解析

```bash
# ❌ 嵌套 get() 遇 None 仍报错
curl "url" | python3 -c 'r.get("a", {}).get("b", {}).get("c")'

# ✅ 保存文件 + 独立脚本
curl "url" > /tmp/data.json && python3 << 'EOF'
import json
d = json.load(open("/tmp/data.json"))
# 多行安全处理
EOF
```

## 7. 治理与反馈 (Governance)

- **预检**：执行前 `command -v` 验证工具，`ls -l` 验证路径。
- **进度同步**：任务跨度 >3 子任务时，输出 `## 进度同步` 汇报已完成与剩余项。
- **熔断机制**：连续 2 次命令报错，必须停止执行，重新读取原始文件，严禁盲目重试。
- **精简输出**：禁止重复输出用户已提供的代码；修改仅展示关键 Diff。
- **状态维护**：每次修改后，通过 `ls -l` 或 `md5sum` 确认文件状态已变更。

