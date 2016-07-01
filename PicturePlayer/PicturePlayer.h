//
//  PicturePlayer.h
//  ceshiDemo
//
//  Created by suxx on 16/6/27.
//  Copyright © 2016年 suxx. All rights reserved.
//
/**
 *  图片播放器，支持轮播，在调用的时候记得去掉视图控制器的留白，
 *  self.automaticallyAdjustsScrollViewInsets = NO;
 *  注意要引用第三方库 AFNetworking
 *
 *
 *
 */

#import <UIKit/UIKit.h>

typedef enum {
    LEFT_BOTTOM,
    MIDDLE_BOTTOM,
    RIGHT_BOTTOM,
}EPageCtlPosition;

@interface PicturePlayer : UIView

//广告点击事件回调
@property (nonatomic, strong) void (^clickADAction)(NSUInteger, NSString *);
//轮播的间隔事件，如果没有设置，则默认为5s
@property (nonatomic, assign)float interval;
//页码指示器的显示位置：左下，左中，右下，默认为左中
@property (nonatomic, assign)EPageCtlPosition pageCtrlPosition;
//是否开启动画播放
@property (nonatomic, assign)BOOL isAnimat;


/**
 *  图片播放器的初始化
 *
 *  @param frame     图片播放器的frame
 *  @param picArr    图片数组
 *  @param detailUrl 图片详情数组
 *
 *  @return 图片播放器
 */
- (instancetype)initWithFrame:(CGRect)frame withPictures:(NSArray *)picArr withADDetailUrls:(NSArray *)detailUrl;

@end
