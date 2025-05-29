source "https://rubygems.org"

# Specify your gem's dependencies in imglab.gemspec
gemspec

gem "rake", "~> 12.0"
gem "minitest", "~> 5.12.0"
gem "yard", "~> 0.8.7"

if RUBY_VERSION >= "3.4.0"
  gem "ostruct" # ostruct is not longer part of the standard library starting from Ruby 3.5.0. (Required by rake)
  gem "mutex_m" # mutex_m is not longer part of the standard library starting from Ruby 3.4.0. (Required by minitest)
end
