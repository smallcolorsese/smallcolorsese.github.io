'use strict';

const path = require('path');
const fs = require('fs');

// 生成搜索索引
hexo.extend.generator.register('search', function(locals) {
  const config = hexo.config;
  const theme = hexo.theme.config;
  
  // 获取所有文章
  const posts = [];
  
  locals.posts.forEach(post => {
    // 移除HTML标签和代码块
    let content = post.content || '';
    content = content.replace(/<[^>]*>/g, ''); // 移除HTML标签
    content = content.replace(/```[\s\S]*?```/g, ''); // 移除代码块
    content = content.trim();
    
    // 获取摘要
    let excerpt = post.excerpt || content.substring(0, 200);
    excerpt = excerpt.replace(/<[^>]*>/g, '').trim();
    
    posts.push({
      title: post.title || '',
      path: post.path,
      date: post.date ? post.date.toISOString() : '',
      updated: post.updated ? post.updated.toISOString() : '',
      categories: post.categories ? post.categories.map(cat => cat.name) : [],
      tags: post.tags ? post.tags.map(tag => tag.name) : [],
      excerpt: excerpt,
      content: content.substring(0, 500) // 索引只保留前500个字符
    });
  });
  
  return {
    path: 'search.json',
    data: JSON.stringify(posts)
  };
});
