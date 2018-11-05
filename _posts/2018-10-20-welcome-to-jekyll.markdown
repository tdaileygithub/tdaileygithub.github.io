---
title:  "Github Pages Jekyll Setup"
date:   2018-10-20 20:10:34 -0700
categories: jekyll
---
# Install Prereqs
{% highlight bash %}
sudo apt-get install -y build-essential make libxml2 zlib1g zlib1g-dev
sudo apt-get install -y ruby ruby-dev jekyll
sudo gem install jekyll bundler
{% endhighlight %}

# Create Site using jekyll
{% highlight bash %}
#from directory above the cloned repot
sudo jekyll new tdaileygithub.github.io --force
cd tdaileygithub.github.io
#edit Gemfile
gem "github-pages", group: :jekyll_plugins
sudo bundle update
{% endhighlight %}

# Jekyll Plugins  _config.yml
[GitHub Pages Supported Plugins](https://pages.github.com/versions/)
{% highlight yaml %}
plugins:
  - jekyll-feed
  - jekyll-avatar
  - jekyll-sitemap
  - jekyll-paginate
  - jekyll-relative-links
  - jekyll-seo-tag
  - jekyll-gist
{% endhighlight %}

{% highlight bash %}
sudo gem install jekyll-feed
sudo gem install jekyll-avatar
sudo gem install jekyll-sitemap
sudo gem install jekyll-paginate
sudo gem install jekyll-relative-links
sudo gem install jekyll-seo-tag
sudo gem install jekyll-gist
sudo gem install html-pipeline
{% endhighlight %}

# Serve the Site
{% highlight bash %}
sudo bundle exec jekyll serve --trace
links http://127.0.0.1:4000
{% endhighlight %}