Gem::Specification.new do |gem|
  gem.name          = 'redcarpet-confluence'
  gem.version       = '1.1.0'
  gem.authors       = ['Adam Stegman']
  gem.email         = ['me@adamstegman.com']
  gem.summary       = 'A Redcarpet renderer to convert Markdown to Confluence syntax.'
  gem.description   = gem.summary.to_s
  gem.homepage      = 'https://github.com/adamstegman/redcarpet-confluence'
  gem.license       = 'MIT'

  gem.executable    = 'md2conf'
  gem.files         = Dir[
                        'lib/**/*.rb',
                        'Gemfile',
                        'README.md',
                        'Rakefile',
                        'redcarpet-confluence.gemspec'
                      ]
  gem.test_files    = Dir[
                        'spec/**/*.rb'
                      ]
  gem.require_paths = ['lib']

  gem.add_dependency             'redcarpet', '~> 3.4'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
