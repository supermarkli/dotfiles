1. 核心准则 (Core & Style)
沟通：中文回复/注释；零客套，直接输出；适度使用 emoji。
编码：单引号 'string'；函数 camelCase；常量 UPPER_SNAKE。
原则：实证主义。禁止假设，不确定即 Search；Shell 报错必须用 2>&1 捕获全量。

2. 阅读与评估 (Reading & Evaluation)
PDF 流程：优先执行 pdftotext -layout input.pdf -。
分流：>50 字直接分析；<50 字视为图表/公式，执行 gs 转 PNG 视觉分析。
禁令：严禁 head/tail 截断；严禁读取前 N 行即下结论。
超长文本：
<3000 行：全量读取。
>3000 行：按页码 (-f -l) 分段，禁止按行号截断。
验证：声称"缺失"前，必须 rg -i -C 2 "关键词" 确认。

3. 文件编辑策略 (Edit Strategy)
新建：使用 Write。
修改：
<3 处：使用 Edit (str_replace)。old_str 必须包含唯一性锚点（如函数头），严禁仅用 } 或 return。
>3 处/大段替换：优先使用 mcp__edit_file。
原子化：单次 Edit 跨度 <50 行。修改前必须先 Read 确保上下文唯一。

4. 大文档与 Web 处理 (Large Doc)
场景：W3C Spec / API Ref / >5万行。
方法：先用 sed/grep 提取结构生成 map.txt 辅助定位。
禁令：禁止直读全文入上下文；禁止 markdownify；禁止输出正文。
工具：直接执行 python3 -c "import requests; import html2text; ..."。
反馈：仅输出包含路径、行数/大小、耗时的统计表格。

5. 学术搜索 (Scholar Search)
首选 OpenAlex：https://api.openalex.org/works?search=...
次选 DBLP：https://dblp.org/search/publ/api?q=...
备选 CrossRef：通用跨学科。

6. 环境安全与上下文治理 (Governance)
预检：执行前 command -v 验证工具，ls -l 验证路径，优先用绝对路径。
进度：任务跨度 >3 子任务时，输出 ## 进度同步。
熔断：连续 2 次命令报错，必须停下来重新 Read 原始文件，严禁盲目重试。
精简：禁止重复输出用户已提供的长代码，仅展示 Diff。
