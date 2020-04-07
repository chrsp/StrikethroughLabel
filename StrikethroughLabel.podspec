Pod::Spec.new do |spec|

  spec.name         = "StrikethroughLabel"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
  Animation for strikethrough UILabel in Swift
                   DESC

  spec.homepage     = "https://github.com/chrsp/StrikethroughLabel.git"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author       = { "chrsp" => "chrspx@gmail.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/chrsp/StrikethroughLabel.git", :tag => "#{spec.version}" }
  spec.source_files  = "StrikethroughLabel/**/*.{h,m,swift}"

end

