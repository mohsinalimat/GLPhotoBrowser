Pod::Spec.new do |s|
  s.name             = "GLPhotoBrowser"
  s.version          = "1.0.0"
  s.summary          = "A iOS photo browser like wechat"

  s.description      = <<-DESC
                        GLPhotoBrowser is a iOS photo browser like wechat
                       DESC

  s.homepage         = "https://github.com/gaoli/GLPhotoBrowser"
  s.license          = 'MIT'
  s.author           = { "gaoli" => "3071730@qq.com" }
  s.source           = { :git => "https://github.com/gaoli/GLPhotoBrowser.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'GLPhotoBrowser/Classes/*.{h,m}'

  s.default_subspec = 'Model', 'View', 'ViewModel'

  s.dependency 'SDWebImage',    '~> 3.7'
  s.dependency 'KVOController', '~> 1.1'

  s.subspec 'Model' do |model|

    model.source_files = 'GLPhotoBrowser/Classes/Model/*.{h,m}'

  end

  s.subspec 'View' do |view|

    view.source_files = 'GLPhotoBrowser/Classes/View/*.{h,m}'

  end

  s.subspec 'ViewModel' do |viewModel|

    viewModel.source_files = 'GLPhotoBrowser/Classes/ViewModel/*.{h,m}'

  end
end
