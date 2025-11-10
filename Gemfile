source "https://rubygems.org"

# Jekyll
gem "jekyll", "~> 4.3"

# Jekyll 플러그인
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-seo-tag", "~> 2.8"
  gem "jekyll-sitemap", "~> 1.4"
end

# Windows와 JRuby에서 시간대 데이터 사용
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Windows 성능 향상
gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]

# HTTP 서버
gem "webrick", "~> 1.8"
