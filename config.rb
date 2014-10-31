#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "middleman-blog"

activate :syntax
activate :livereload
activate :redirect

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb,
               :tables => true,
               :autolink => true,
               :smartypants => true,
               :fenced_code_blocks => true

set :build_dir, 'publish'

set :css_dir, 'assets/css'
set :js_dir, 'assets/js'
set :images_dir, 'assets/img'
set :font_dir, 'assets/font'

redirect "index.html", :to => "blog/"

configure :build do
  activate :relative_assets
end

activate :blog do |blog|
  blog.prefix = "blog"
  blog.sources = "{year}-{month}-{day}-{title}"
  blog.default_extension = ".md"
  blog.layout = "post", 
  blog.permalink = ":year/:month/:day/:title"
end

activate :directory_indexes

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  deploy.branch   = "master"
  deploy.remote   = "git@github.com:finagle/finagle.github.io.git"
end

page "/sitemap.xml", :layout => false
page "/blog/feed.xml", :layout => false

helpers do
  def published(articles)
    if development?
      articles
    else
      articles.reject{|a| a.data.public_draft }
    end
  end
end

