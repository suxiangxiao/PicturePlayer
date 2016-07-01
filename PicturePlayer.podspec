Pod::Spec.new do |s|
s.name         = "PicturePlayer"
s.version      = "0.0.1"
s.summary      = '图片轮播的控件'
s.homepage     = "https://github.com/suxiangxiao/PicturePlayer"
s.license      = 'MIT'
s.author       = {'kbo' => '13751882497.com'}
s.source       = { :git => 'https://github.com/suxiangxiao/PicturePlayer.git'}
s.platform     = :ios
s.source_files = 'PicturePlayer/*.{h,m}'
s.resources    = 'PicturePlayer/Resource/*.{png}'
#s.frameworks = '*.helloFramework/helloFramework'
end
