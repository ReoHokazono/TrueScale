Pod::Spec.new do |s|
  s.name         = "TrueScale"
  s.version      = "v0.6"
  s.summary      = "Make CGRect, CGSize, CGPoint from [mm], [cm] and [inch]."
  s.homepage     = "https://github.com/ReoHokazono/TrueScale"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Reo Hokazono" => "email@address.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ReoHokazono/TrueScale.git", :tag => "#{s.version}" }
  s.source_files = "TrueScale/**/*.swift"
  s.requires_arc = true
end
