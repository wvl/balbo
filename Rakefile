require 'rake/rdoctask'

task :default => :spec

desc "Build a gem"
task :gem => [ :gemspec, :build ]

desc "Launch Kicker (like autotest)"
task :kicker do
  puts "Kicking... (ctrl+c to cancel)"
  exec "kicker -e rake test lib"
end

begin
  require 'jeweler'
  $LOAD_PATH.unshift 'lib'
  require 'balbo/version'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "balbo"
    gemspec.summary = "Balbo is a framework-agnostic way to render almost logic-free views."
    gemspec.description = "Balbo is a framework-agnostic way to render almost logic-free views."
    gemspec.email = "wayne@larsen.st"
    gemspec.homepage = "http://github.com/wvl/balbo"
    gemspec.authors = ["Wayne Larsen", "Chris Wanstrath"]
    gemspec.version = Balbo::Version
  end
rescue LoadError
  puts "Jeweler not available."
  puts "Install it with: gem install jeweler"
end

desc "Run all the specs"
task :spec do
  sh "bacon -Ilib --automatic -c"
end

begin
  require 'sdoc_helpers'
rescue LoadError
  puts "sdoc support not enabled. Please gem install sdoc-helpers."
end

desc "Push a new version to Gemcutter"
task :publish => [ :test, :gemspec, :build ] do
  system "git tag v#{Balbo::Version}"
  system "git push origin v#{Balbo::Version}"
  system "git push origin master"
  system "gem push pkg/mustache-#{Balbo::Version}.gem"
  system "git clean -fd"
  exec "rake pages"
end

desc "Install the edge gem"
task :install_edge => [ :dev_version, :gemspec, :build ] do
  exec "gem install pkg/mustache-#{Balbo::Version}.gem"
end

# Sets the current Mustache version to the current dev version
task :dev_version do
  $LOAD_PATH.unshift 'lib'
  require 'balbo/version'
  version = Balbo::Version + '.' + Time.now.to_i.to_s
  Balbo.const_set(:Version, version)
end
