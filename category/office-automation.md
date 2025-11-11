---
layout: default
title: 사무자동화
permalink: /category/office-automation/
---

<div class="category-header">
    <h1>⚙️ 사무자동화</h1>
    <p>업무 효율을 높이는 자동화 도구</p>
</div>

<section class="recent-posts">
    {% assign category_posts = site.categories['사무자동화'] %}
    {% if category_posts.size > 0 %}
    <div class="posts-grid">
        {% for post in category_posts %}
        <article class="post-tile">
            <div class="post-tile-image">
                ⚙️
            </div>
            <div class="post-tile-content">
                <div class="post-tile-header">
                    <span class="category-badge">{{ post.category }}</span>
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
        <p>📭 이 카테고리에는 아직 글이 없습니다.</p>
    </div>
    {% endif %}
</section>
