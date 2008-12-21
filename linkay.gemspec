Gem::Specification.new do |s|
  s.name = %q{linkay}
  s.version = "0.0.1"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Liming Lian"]
  s.description = %q{Linkay, opensocial container for Rails}
  s.email = %q{lianliming@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE.txt"]
  s.files = ["History.txt", "install.rb", "MIT-LICENSE.txt", "README.txt", "Rakefile", "lib/linkay.rb", "lib/linkay"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/limlian/linkay}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{linkay}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Linkay, opensocial container for Rails}
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.0.6"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.0.6"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.0.6"])
  end
end