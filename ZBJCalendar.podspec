Pod::Spec.new do |s|

  s.name         = "ZBJCalendar"
  s.version      = "0.0.8"
  s.summary      = "ZBJCalendar is a simple calendar framework."

  s.homepage     = "https://github.com/wanggang316/ZBJCalendar"
  s.license      = "MIT"
  s.authors            = { "Gump" => "gummpwang@gmail.com" }
  s.social_media_url   = "https://twitter.com/wgang316"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wanggang316/ZBJCalendar.git", :tag => s.version }

  s.source_files  = "ZBJCalendar/ZBJCalendar/*.{h,m}"
  s.public_header_files = "ZBJCalendar/ZBJCalendar/*.h"


end
