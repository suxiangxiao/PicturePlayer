# PicturePlayer
play pictures cycle

example:
#import "PicturePlayer.h"

UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)];
        [self.view addSubview:view];
    PicturePlayer *pp = [[PicturePlayer alloc] initWithFrame:view.bounds withPictures:@[@"", @"",@""] withADDetailUrls:@[@"http://www.baidu.com", @"http://jikexueyuan.com", @"http://www.baidu.com"]];
    //页码指示器的位置，不设置则默认居中
    pp.pageCtrlPosition = RIGHT_BOTTOM;
    //滚动是否带动画，不设置则默认带动画
    pp.isAnimat = YES;
    [view addSubview:pp];
    //点击跳转详情页
    pp.clickADAction = ^(NSUInteger index, NSString *detailUrl){
    };
