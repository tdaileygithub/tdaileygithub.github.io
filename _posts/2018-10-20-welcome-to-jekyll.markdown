---
title:  "Github Pages Jekyll Setup"
date:   2018-10-20 20:10:34 -0700
categories: jekyll
---
# Install Prereqs
{% highlight bash %}
sudo apt-get install build-essential make libxml2 zlib1g zlib1g-dev
sudo apt-get install ruby ruby-dev jekyll
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

# Jekyll Plugins  - _config.yml
{% highlight yaml %}
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag
{% endhighlight %}

# Serve the Site
{% highlight bash %}
sudo bundle exec jekyll serve --trace
links http://127.0.0.1:4000
{% endhighlight %}