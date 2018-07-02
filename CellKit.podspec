Pod::Spec.new do |s|
  s.name         = "CellKit"
  s.version      = "0.1"
  s.summary      = "Table View and Collection View data source wrapper"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/thefuntasty/CellKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Petr Zvoníček" => "petr.zvonicek@thefuntasty.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/thefuntasty/CellKit.git", :tag => s.version.to_s }  
  s.frameworks  = "Foundation"

  s.subspec 'Core' do |core|
    core.source_files  = "Sources/*"
  end

  s.subspec 'Equatable' do |equatable|
    equatable.dependency 'CellKit/Core'    
    equatable.source_files = 'Sources/EquatableDataSource/*'
    equatable.dependency 'Dwifft', '~> 0.8'
  end

  s.default_subspec = 'Core'  
end
