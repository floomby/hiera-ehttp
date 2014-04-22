require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |gem|
    gem.name         = File.basename(`git rev-parse --show-toplevel`).chop
    gem.version      = `gitver version`
    
    gem.author       = `git config --get user.name`
    gem.email        = `git config --get user.email`
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
