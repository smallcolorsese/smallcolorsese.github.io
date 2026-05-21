/**
 * 站内搜索功能 - 导航栏模式
 */

class BlogSearch {
  constructor() {
    this.searchData = [];
    this.navbarSearchInput = null;
    this.modalSearchInput = null;
    this.searchResults = null;
    this.searchModal = null;
    this.googleSearchBox = null;
    this.isModalOpen = false; // 模态框状态标记
    this.init();
  }

  async init() {
    // 加载搜索数据
    await this.loadSearchData();
    this.bindEvents();
  }

  async loadSearchData() {
    try {
      const response = await fetch('/search.json');
      if (response.ok) {
        this.searchData = await response.json();
      }
    } catch (error) {
      console.error('Failed to load search data:', error);
    }
  }

  bindEvents() {
    // 获取导航栏搜索输入框
    this.navbarSearchInput = document.querySelector('#navbar-search-input');
    this.modalSearchInput = document.querySelector('#search-input');
    this.googleSearchBox = document.querySelector('.google-search-box');
    
    // 获取模态框相关元素
    this.searchModal = document.querySelector('#search-modal');
    this.searchResults = document.querySelector('#search-results');

    if (!this.navbarSearchInput) return;

    // === 导航栏搜索框事件 ===
    // 点击/焦点时显示模态框
    this.navbarSearchInput.addEventListener('focus', (e) => {
      e.stopPropagation();
      this.showSearchModal();
    });

    // 实时搜索并同步到模态框
    this.navbarSearchInput.addEventListener('input', (e) => {
      const keyword = e.target.value;
      if (this.modalSearchInput) {
        this.modalSearchInput.value = keyword;
      }
      this.performSearch(keyword);
    });

    // === 模态框搜索框事件 ===
    if (this.modalSearchInput) {
      this.modalSearchInput.addEventListener('focus', (e) => {
        e.stopPropagation();
        this.showSearchModal();
      });

      this.modalSearchInput.addEventListener('input', (e) => {
        const keyword = e.target.value;
        this.navbarSearchInput.value = keyword;
        this.performSearch(keyword);
      });

      this.modalSearchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          e.preventDefault();
        }
      });
    }

    // === 导航栏搜索框 Enter 键 ===
    this.navbarSearchInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
      }
    });

    // === 搜索框容器点击事件 ===
    if (this.googleSearchBox) {
      this.googleSearchBox.addEventListener('click', (e) => {
        e.stopPropagation();
        this.showSearchModal();
      });
    }

    // === 模态框背景点击关闭 ===
    if (this.searchModal) {
      this.searchModal.addEventListener('click', (e) => {
        e.stopPropagation();
        // 只有点击模态框背景（不是内容区域）时才关闭
        if (e.target === this.searchModal) {
          this.hideSearchModal();
        }
      });
    }

    // === 全局 ESC 键关闭 ===
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && this.isModalOpen) {
        this.hideSearchModal();
        this.navbarSearchInput?.blur();
      }
    });

    // === 全局点击事件 - 关闭模态框（只在搜索区域外） ===
    document.addEventListener('click', (e) => {
      if (!this.isModalOpen) return; // 模态框未打开时不处理
      
      // 检查点击的元素是否在搜索框或模态框内
      const isClickInsideSearchBox = this.googleSearchBox?.contains(e.target);
      const isClickInsideModal = this.searchModal?.contains(e.target);
      
      // 只有当点击在搜索区域外时才关闭
      if (!isClickInsideSearchBox && !isClickInsideModal) {
        this.hideSearchModal();
      }
    }, true); // 使用捕获阶段处理，确保在冒泡之前触发

    // === 搜索结果项目点击 ===
    document.addEventListener('click', (e) => {
      if (e.target.closest('.search-result-item')) {
        this.clearSearch();
        this.hideSearchModal();
        this.navbarSearchInput?.blur();
      }
    });
  }

  performSearch(keyword) {
    if (!keyword.trim()) {
      this.renderSearchResults([]);
      return;
    }

    const results = this.searchData.filter(post => {
      const searchContent = [
        post.title,
        post.content,
        post.tags?.join(' ') || '',
        post.categories?.join(' ') || ''
      ].join(' ').toLowerCase();

      return searchContent.includes(keyword.toLowerCase());
    });

    // 按相关性排序 - 标题匹配放在前面
    results.sort((a, b) => {
      const aTitle = a.title.toLowerCase().includes(keyword.toLowerCase());
      const bTitle = b.title.toLowerCase().includes(keyword.toLowerCase());
      return bTitle - aTitle;
    });

    this.renderSearchResults(results);
  }

  renderSearchResults(results) {
    if (!this.searchResults) return;

    if (results.length === 0) {
      this.searchResults.innerHTML = `
        <div class="search-empty">
          <p>未找到相关文章</p>
        </div>
      `;
      return;
    }

    const keyword = this.navbarSearchInput.value.trim();
    const html = results.map(post => `
      <a href="${post.path}" class="search-result-item">
        <div class="search-result-title">${this.highlightKeyword(post.title, keyword)}</div>
        <div class="search-result-excerpt">${this.highlightKeyword(post.excerpt || post.content?.substring(0, 100), keyword)}</div>
        <div class="search-result-meta">
          ${post.categories ? `<span class="search-result-meta-item">${post.categories.join(', ')}</span>` : ''}
          ${post.date ? `<span class="search-result-meta-item">${new Date(post.date).toLocaleDateString('zh-CN')}</span>` : ''}
        </div>
      </a>
    `).join('');

    this.searchResults.innerHTML = html;
  }

  highlightKeyword(text, keyword) {
    if (!keyword || !text) return text;
    const regex = new RegExp(`(${keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
    return text.replace(regex, '<mark>$1</mark>').substring(0, 150);
  }

  clearSearch() {
    this.navbarSearchInput.value = '';
    if (this.modalSearchInput) {
      this.modalSearchInput.value = '';
    }
  }

  showSearchModal() {
    if (this.isModalOpen) return; // 已经打开，避免重复处理
    
    this.isModalOpen = true;
    this.searchModal?.classList.add('active');
  }

  hideSearchModal() {
    this.isModalOpen = false;
    this.searchModal?.classList.remove('active');
  }
}

// 页面加载完成后初始化搜索
document.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('#navbar-search-input')) {
    new BlogSearch();
  }
});

// 页面加载完成后初始化搜索
document.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('#navbar-search-input')) {
    new BlogSearch();
  }
});

