---
layout: default
title: Home
---

<div class="hero">
    <div class="error-box">
        <div class="error-code-large">404</div>
        <div class="error-message">
            <h2>개발자를 찾을 수 없습니다</h2>
            <p class="subtitle">하지만 찾는 중입니다...</p>
        </div>
    </div>
    <div class="hero-description">
        <p>{{ site.description }}</p>
        <p>초보 개발자의 에러 메시지, 삽질 기록, 그리고 작은 성공들을 기록합니다.</p>
    </div>
</div>

<section class="categories-section">
    <h2>📂 카테고리</h2>
    <div class="categories-grid">
        <div class="category-card error-404">
            <h3>404 - Not Found</h3>
            <p>개발자를 찾을 수 없는 순간들</p>
            <span class="post-count">초보자의 막막함</span>
        </div>
        <div class="category-card error-500">
            <h3>500 - Internal Server Error</h3>
            <p>나의 내부 서버가 터진 순간들</p>
            <span class="post-count">버그와의 전쟁</span>
        </div>
        <div class="category-card status-301">
            <h3>301 - Moved Permanently</h3>
            <p>방향을 바꾼 순간들</p>
            <span class="post-count">전환과 회고</span>
        </div>
        <div class="category-card status-200">
            <h3>200 - OK</h3>
            <p>성공한 순간들</p>
            <span class="post-count">작은 성취</span>
        </div>
        <div class="category-card status-100">
            <h3>100 - Continue</h3>
            <p>계속 배우는 중</p>
            <span class="post-count">학습 기록</span>
        </div>
    </div>
</section>

<section class="recent-posts">
    <h2>📝 최근 글</h2>
    {% if site.posts.size > 0 %}
    <div class="posts-list">
        {% for post in site.posts limit:5 %}
        <article class="post-item">
            <div class="post-item-header">
                {% if post.category %}
                <span class="category-badge">{{ post.category }}</span>
                {% endif %}
                {% if post.status %}
                <span class="status-badge status-{{ post.status }}">{{ post.status }}</span>
                {% endif %}
            </div>
            <h3 class="post-item-title">
                <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
            </h3>
            {% if post.description %}
            <p class="post-item-description">{{ post.description }}</p>
            {% endif %}
            <div class="post-item-meta">
                <time datetime="{{ post.date | date_to_xmlschema }}">
                    {{ post.date | date: "%Y.%m.%d" }}
                </time>
                {% if post.tags %}
                <div class="post-item-tags">
                    {% for tag in post.tags limit:3 %}
                    <span class="tag">#{{ tag }}</span>
                    {% endfor %}
                </div>
                {% endif %}
            </div>
        </article>
        {% endfor %}
    </div>
    {% else %}
    <p class="no-posts">아직 글이 없습니다. 곧 업데이트될 예정입니다!</p>
    {% endif %}
</section>

<section class="about-section">
    <h2>💬 이 블로그는...</h2>
    <div class="about-content">
        <p>
            <strong>"Error 404: 개발자를 찾을 수 없음"</strong>은 초보 개발자의 성장 과정을 기록하는 블로그입니다.
        </p>
        <ul>
            <li>✅ 실제로 겪은 에러와 해결 과정</li>
            <li>✅ 초보자 눈높이의 쉬운 설명</li>
            <li>✅ 삽질도 자산이 되는 기록</li>
            <li>✅ 함께 성장하는 커뮤니티</li>
        </ul>
        <p class="cta">
            <strong>현재 상태:</strong> <span class="status-current">404</span> →
            <strong>목표:</strong> <span class="status-goal">200 OK</span>
        </p>
    </div>
</section>
