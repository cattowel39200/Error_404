---
layout: default
title: 소개
permalink: /about/
---

<div class="about-page">
    <div class="terminal-box">
        <div class="terminal-header">
            <div class="terminal-buttons">
                <span class="terminal-button red"></span>
                <span class="terminal-button yellow"></span>
                <span class="terminal-button green"></span>
            </div>
            <span class="terminal-title">about.sh</span>
        </div>
        <div class="terminal-content">
            <div class="terminal-line">
                <span class="terminal-prompt">$</span>
                <span class="terminal-command">cat profile.txt</span>
            </div>
            <div class="terminal-output">
                <h1>Error 404: 개발자를 찾을 수 없음</h1>
                <p>{{ site.description }}</p>
            </div>
        </div>
    </div>

    <section class="about-section">
        <h2>🎯 블로그 목표</h2>
        <div class="about-content">
            <p>이 블로그는 초보 개발자가 <strong>404 Not Found</strong> 상태에서 <strong>200 OK</strong>로 성장하는 과정을 기록합니다.</p>
            <ul>
                <li>✅ 실제로 겪은 에러와 해결 과정 공유</li>
                <li>✅ 초보자도 이해할 수 있는 쉬운 설명</li>
                <li>✅ AutoCAD LISP 자동화 도구 개발</li>
                <li>✅ 업무 자동화 및 효율화 방법</li>
                <li>✅ AI 활용 실전 노하우</li>
            </ul>
        </div>
    </section>

    <section class="about-section">
        <h2>📚 주요 카테고리</h2>
        <div class="category-cards">
            <div class="category-card">
                <div class="category-card-icon">📝</div>
                <h3>MY LISP</h3>
                <p>AutoCAD LISP 유틸리티 개발 및 공유</p>
                <a href="{{ '/category/my-lisp' | relative_url }}" class="btn">바로가기 →</a>
            </div>
            <div class="category-card">
                <div class="category-card-icon">⚙️</div>
                <h3>사무자동화</h3>
                <p>업무 효율을 높이는 자동화 도구</p>
                <a href="{{ '/category/office-automation' | relative_url }}" class="btn">바로가기 →</a>
            </div>
            <div class="category-card">
                <div class="category-card-icon">🤖</div>
                <h3>AI활용</h3>
                <p>AI를 활용한 업무 혁신</p>
                <a href="{{ '/category/ai' | relative_url }}" class="btn">바로가기 →</a>
            </div>
        </div>
    </section>

    <section class="about-section">
        <h2>👤 작성자</h2>
        <div class="about-content">
            <p><strong>{{ site.author.name }}</strong></p>
            <p>{{ site.author.bio }}</p>
            {% if site.author.github %}
            <p>
                <a href="https://github.com/{{ site.author.github }}" target="_blank" class="btn">
                    GitHub 방문하기 →
                </a>
            </p>
            {% endif %}
        </div>
    </section>

    <section class="about-section">
        <h2>📬 연락처</h2>
        <div class="about-content">
            <p>블로그에 대한 문의나 제안 사항이 있으시면 연락주세요.</p>
            {% if site.author.email %}
            <p>Email: <a href="mailto:{{ site.author.email }}">{{ site.author.email }}</a></p>
            {% endif %}
            {% if site.author.github %}
            <p>GitHub: <a href="https://github.com/{{ site.author.github }}" target="_blank">@{{ site.author.github }}</a></p>
            {% endif %}
        </div>
    </section>

    <section class="about-section">
        <h2>🚀 현재 상태</h2>
        <div class="status-display">
            <div class="status-badge-large current">404 Not Found</div>
            <div class="status-arrow">→</div>
            <div class="status-badge-large target">200 OK</div>
        </div>
        <div class="progress-bar">
            <div class="progress-fill" style="width: 80%;">
                <span class="progress-text">디버깅 중... 80%</span>
            </div>
        </div>
    </section>
</div>
