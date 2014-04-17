require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |gem|
    gem.name         = "hiera-ehttp"
    gem.version      = "0.1.0"
    
    gem.author       = "Josh Hoover"
    gem.email        = "floomby@nmt.edu"
    gem.homepage     = "http://github.com/floomby/hiera-ehttp"
    gem.summary      = "HTTP backend for Hiera supporting encrypted entries"
    gem.description  = "Hiera backend for looking up data over HTTP APIs with support for encrypted values"
    
    gem.require_path = "lib"
    gem.files        = `git ls-files`.split($\)
    
    gem.executables  = ["hiera-ehttp"]
    
    gem.add_dependency('json')
end

Gem::PackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
end
