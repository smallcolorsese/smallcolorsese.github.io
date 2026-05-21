# 博客搜索功能使用说明

## 功能介绍

为你的博客添加了一个强大的**站内搜索功能**，用户可以快速搜索和查找博客文章。

### 功能特点

✨ **快速搜索**
- 支持关键词搜索文章标题、内容、分类、标签
- 实时搜索结果，无需按回车键
- 搜索词自动高亮显示

🎨 **设计风格**
- 完全适配浅色/暗色主题
- 响应式设计，支持移动设备
- 与flexblock主题设计风格保持一致的卡片式界面

⚡ **用户体验**
- 模态框搜索界面，美观易用
- 支持ESC键关闭搜索
- 显示文章分类、日期等元信息
- 搜索结果包含文章摘要

## 文件说明

### 新增文件

```
themes/flexblock/
├── source/
│   ├── js/
│   │   └── search.js          # 搜索功能前端代码
│   └── css/
│       └── search.css         # 搜索功能样式
└── scripts/
    └── search.js              # Hexo生成更新 search.json
```

### 修改文件

1. **themes/flexblock/layout/layout.ejs**
   - 添加搜索样式表引入
   - 添加搜索模态框HTML

2. **themes/flexblock/layout/_partial/nav.ejs**
   - 在导航栏中添加搜索按钮

3. **themes/flexblock/layout/_partial/footer-script.ejs**
   - 添加搜索JS脚本引入

## 使用方法

### 第一步：重新生成站点

```bash
# 确保你在博客根目录

# 清除之前的构建
hexo clean

# 重新生成站点（会自动生成 search.json）
hexo generate

# 启动本地服务器预览
hexo server
```

### 第二步：使用搜索功能

1. **打开搜索框**
   - 点击导航栏右侧的 🔍 搜索图标
   - 或在搜索框中输入关键词

2. **搜索文章**
   - 输入关键词自动搜索
   - 搜索会在以下内容中匹配：
     - 文章标题
     - 文章内容
     - 文章分类
     - 文章标签

3. **查看结果**
   - 搜索结果以卡片式展示
   - 点击任何搜索结果直接进入文章
   - 匹配的关键词会高亮显示（粉色背景）

4. **关闭搜索**
   - 按ESC键关闭搜索框
   - 或在搜索框外点击关闭

## 自定义配置

### 修改搜索提示文本

编辑 `themes/flexblock/source/js/search.js`，找到这行：

```javascript
#search-input placeholder="搜索文章..."
```

改为你想要的提示文本。

### 修改搜索结果样式

编辑 `themes/flexblock/source/css/search.css`，可以修改：

- `.search-result-title` - 搜索结果标题样式
- `.search-result-excerpt` - 搜索结果摘要样式
- `.search-result-meta` - 搜索结果元信息样式
- 颜色、字体大小等其他样式

### 修改搜索索引内容

编辑 `themes/flexblock/scripts/search.js`：

```javascript
// 修改索引的内容长度（默认500字符）
content: content.substring(0, 500) // 改为你想要的长度
```

## 故障排除

### 问题：搜索框显示但无法搜索

**解决方案：**
1. 检查是否运行过 `hexo generate`
2. 确认 `public/search.json` 文件存在
3. 检查浏览器控制台是否有错误信息
4. 清除浏览器缓存，刷新页面

### 问题：搜索结果为空

**解决方案：**
1. 确保博客中有已发布的文章
2. 检查搜索关键词是否正确
3. 尝试搜索文章标题的一部分

### 问题：样式不正确或主题不匹配

**解决方案：**
1. 运行 `hexo clean && hexo generate` 重新生成
2. 刷新浏览器（Ctrl+F5 硬刷新）
3. 检查 `themes/flexblock/source/css/search.css` 是否完整

## 性能说明

- 搜索完全在浏览器端进行，不需要服务器查询
- 第一次访问时加载 `search.json`，之后缓存在内存中
- 支持大规模博客（几百篇文章）

## 技术细节

### 搜索流程

1. 页面加载时，`search.js` 从 `/search.json` 获取所有文章数据
2. 用户输入搜索词时，在前端进行实时搜索
3. 搜索算法检查以下字段：
   - title（标题）
   - content（内容片段）
   - tags（标签）
   - categories（分类）
4. 返回匹配结果并渲染到搜索框下方

### 搜索.json 生成原理

- Hexo 生成时，自动执行 `themes/flexblock/scripts/search.js`
- 遍历所有已发布的文章
- 提取标题、路径、日期、分类、标签、摘要等信息
- 生成 `/public/search.json` 文件供前端使用

## 浏览器兼容性

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 12+
- ✅ Edge 79+
- ✅ 移动浏览器（iOS Safari, Chrome Mobile）

## 反馈和改进

如果你发现任何问题或想要添加新功能，可以考虑：

1. 添加搜索历史记录
2. 添加分类/标签筛选
3. 添加搜索结果分页
4. 添加搜索统计功能

祝你使用愉快！🎉
