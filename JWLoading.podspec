Pod::Spec.new do |s|

  s.name         = "JWLoading"
  s.version      = "0.0.8"
  s.summary      = "Loading动画。"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWLoading"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author             = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.0"
  #项目地址，版本
  s.source       = { :git => "https://github.com/junwangInChina/JWLoading.git", :tag => s.version }

  #库文件路径
  s.source_files  = "JWLoading/JWLoading/JWLoading/**/*.{h,m}"
  s.resource_bundles = {
    'JWLoading' => ['JWLoading/JWLoading/JWLoading/JWLoading.bundle/*.png']
  }
  #s.resource = 'JWLoading/JWLoading/JWLoading/JWLoading.bundle'
  #是否ARC
  s.requires_arc = true

end