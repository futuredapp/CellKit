Pod::Spec.new do |s|
  s.name        = "CellKit"
  s.version     = "0.5.1"
  s.summary     = "Table View and Collection View data source wrapper"
  s.description = <<-DESC
    Generic abstraction over table/collection data source
    with automatic cell registration of
    cell models and automatic animations using diffs.
  DESC
  s.homepage               = "https://github.com/thefuntasty/CellKit"
  s.license                = { type: "MIT", file: "LICENSE" }
  s.author                 = { "Matěj K. Jirásek": "matej.jirasek@thefuntasty.com", "Petr Zvoníček": "zvonicek@gmail.com" }
  s.social_media_url       = "https://twitter.com/TheFuntasty"
  s.ios.deployment_target  = "9.0"
  s.tvos.deployment_target = "9.0"
  s.swift_versions         = ["4.2", "5.0", "5.1"]
  s.source                 = { git: "https://github.com/thefuntasty/CellKit.git", tag: s.version.to_s }
  s.frameworks             = ["Foundation", "UIKit"]
  s.default_subspec        = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/CellKit/*"
  end

  s.subspec "Diffable" do |ss|
    ss.dependency "CellKit/Core"
    ss.source_files = "Sources/DiffableCellKit/*"
    ss.dependency "DifferenceKit", "~> 1.0"
  end
end
