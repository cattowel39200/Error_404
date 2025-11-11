---
layout: default
title: 카테고리
permalink: /categories/
---

<div class="categories-page">
    <h1>📂 카테고리</h1>
    <p>주제별로 분류된 글 목록입니다.</p>

    <div class="categories-grid">
        <div class="category-section">
            <div class="category-header-box">
                <span class="category-icon-large">📝</span>
                <h2>MY LISP</h2>
                <p>AutoCAD LISP 유틸리티 모음</p>
                <a href="{{ '/category/my-lisp' | relative_url }}" class="btn">전체보기 →</a>
            </div>
            {% assign lisp_posts = site.categories['MY LISP'] %}
            {% if lisp_posts.size > 0 %}
            <ul class="post-list">
                {% for post in lisp_posts limit:5 %}
                <li>
                    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
                    <span class="post-date">{{ post.date | date: "%Y.%m.%d" }}</span>
                </li>
                {% endfor %}
            </ul>
            {% if lisp_posts.size > 5 %}
            <p class="more-link">
                <a href="{{ '/category/my-lisp' | relative_url }}">더보기 ({{ lisp_posts.size }}개) →</a>
            </p>
            {% endif %}
            {% else %}
            <p class="no-posts">아직 글이 없습니다.</p>
            {% endif %}
        </div>

        <div class="category-section">
            <div class="category-header-box">
                <span class="category-icon-large">⚙️</span>
                <h2>사무자동화</h2>
                <p>업무 효율을 높이는 자동화 도구</p>
                <a href="{{ '/category/office-automation' | relative_url }}" class="btn">전체보기 →</a>
            </div>
            {% assign automation_posts = site.categories['사무자동화'] %}
            {% if automation_posts.size > 0 %}
            <ul class="post-list">
                {% for post in automation_posts limit:5 %}
                <li>
                    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
                    <span class="post-date">{{ post.date | date: "%Y.%m.%d" }}</span>
                </li>
                {% endfor %}
            </ul>
            {% if automation_posts.size > 5 %}
            <p class="more-link">
                <a href="{{ '/category/office-automation' | relative_url }}">더보기 ({{ automation_posts.size }}개) →</a>
            </p>
            {% endif %}
            {% else %}
            <p class="no-posts">아직 글이 없습니다.</p>
            {% endif %}
        </div>

        <div class="category-section">
            <div class="category-header-box">
                <span class="category-icon-large">🤖</span>
                <h2>AI활용</h2>
                <p>AI를 활용한 업무 혁신</p>
                <a href="{{ '/category/ai' | relative_url }}" class="btn">전체보기 →</a>
            </div>
            {% assign ai_posts = site.categories['AI활용'] %}
            {% if ai_posts.size > 0 %}
            <ul class="post-list">
                {% for post in ai_posts limit:5 %}
                <li>
                    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
                    <span class="post-date">{{ post.date | date: "%Y.%m.%d" }}</span>
                </li>
                {% endfor %}
            </ul>
            {% if ai_posts.size > 5 %}
            <p class="more-link">
                <a href="{{ '/category/ai' | relative_url }}">더보기 ({{ ai_posts.size }}개) →</a>
            </p>
            {% endif %}
            {% else %}
            <p class="no-posts">아직 글이 없습니다.</p>
            {% endif %}
        </div>
    </div>
</div>
