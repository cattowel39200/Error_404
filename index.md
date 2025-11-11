---
layout: default
title: Home
---

<div class="hero">
    <div class="terminal-box">
        <div class="terminal-header">
            <div class="terminal-buttons">
                <span class="terminal-button red"></span>
                <span class="terminal-button yellow"></span>
                <span class="terminal-button green"></span>
            </div>
            <span class="terminal-title">error404@dev-blog: ~</span>
        </div>
        <div class="terminal-content">
            <div class="terminal-line">
                <span class="terminal-prompt">$</span>
                <span class="terminal-command">whoami</span>
            </div>
            <div class="terminal-output">Error 404: 개발자를 찾을 수 없음</div>

            <div class="terminal-line" style="margin-top: 1rem;">
                <span class="terminal-prompt">$</span>
                <span class="terminal-command">cat status.txt</span>
            </div>
            <div class="terminal-output">현재 상태: 초보 개발자</div>
            <div class="terminal-output">디버깅 중... ████████░░ 80%</div>

            <div class="terminal-line" style="margin-top: 1rem;">
                <span class="terminal-prompt">$</span>
                <span class="terminal-command">echo "목표"</span>
            </div>
            <div class="terminal-success">✓ 200 OK 달성을 향해 코딩 중!</div>

            <div class="terminal-line" style="margin-top: 1rem;">
                <span class="terminal-prompt">$</span>
                <span class="terminal-cursor"></span>
            </div>
        </div>
    </div>

    <div class="welcome-message">
        <h2>🔍 환영합니다!</h2>
        <p>여기는 <strong>실제 에러가 아니라</strong> 초보 개발자의 성장 블로그입니다 😊</p>
        <p>{{ site.description }}</p>
        <div class="status-badges">
            <span class="status-badge-large current">현재: 404 Not Found</span>
            <span style="font-size: 1.5rem;">→</span>
            <span class="status-badge-large target">목표: 200 OK</span>
        </div>
    </div>

    <div class="hero-description">
        <p>💡 에러 메시지가 무섭지 않은 개발자가 되기 위한 여정</p>
        <p>🛠️ 실제로 겪은 에러, 삽질 기록, 그리고 작은 성공들을 기록합니다</p>
        <p>📚 초보자도 이해할 수 있는 쉬운 설명을 지향합니다</p>
    </div>
</div>

<section class="recent-posts">
    <h2>📝 전체 글</h2>
    {% if site.posts.size > 0 %}
    <div class="posts-grid">
        {% for post in site.posts %}
        <article class="post-tile">
            <div class="post-tile-image">
                {% if post.category == 'MY LISP' %}
                    📝
                {% elsif post.category == '사무자동화' %}
                    ⚙️
                {% elsif post.category == 'AI활용' %}
                    🤖
                {% else %}
                    💡
                {% endif %}
            </div>
            <div class="post-tile-content">
                <div class="post-tile-header">
                    {% if post.category %}
                    <span class="category-badge">{{ post.category }}</span>
                    {% endif %}
                </div>
                <h3 class="post-tile-title">
                    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
                </h3>
                {% if post.description %}
                <p class="post-tile-description">{{ post.description }}</p>
                {% endif %}
                <div class="post-tile-footer">
                    <div class="post-tile-meta">
                        <time datetime="{{ post.date | date_to_xmlschema }}">
                            {{ post.date | date: "%Y.%m.%d" }}
                        </time>
                        {% if post.tags %}
                        <div class="post-item-tags">
                            {% for tag in post.tags limit:2 %}
                            <span class="tag">#{{ tag }}</span>
                            {% endfor %}
                        </div>
                        {% endif %}
                    </div>
                </div>
            </div>
        </article>
        {% endfor %}
    </div>
    {% else %}
    <div class="no-posts">
        <p>📭 아직 작성된 글이 없습니다.</p>
        <p>곧 멋진 컨텐츠로 채워질 예정입니다!</p>
    </div>
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
