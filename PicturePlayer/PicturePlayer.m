//
//  PicturePlayer.m
//  ceshiDemo
//
//  Created by suxx on 16/6/27.
//  Copyright © 2016年 suxx. All rights reserved.
//

#import "PicturePlayer.h"
#import <UIButton+AFNetworking.h>

@interface PicturePlayer()<UIScrollViewDelegate>

@property (nonatomic, strong)NSArray *pictureArr;
@property (nonatomic, strong)NSArray *detailUrlArr;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageCtl;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSLayoutConstraint *hContraint;
@property (nonatomic, strong)NSLayoutConstraint *vContraint;

@end

@implementation PicturePlayer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Delegate
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self circleScrollImage];
}

#pragma mark - Event Handle

#pragma mark - Private Method
-(void)prepareForUIWithPicArr:(NSArray *)picArr withDetailUrl:(NSArray *)detailUrlArr{
    self.pictureArr = picArr;
    self.detailUrlArr = detailUrlArr;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * (picArr.count + 2), self.frame.size.height);
    
    float x, y, width, height;
    x = self.frame.size.width;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height;
    if (_pictureArr.count > 0) {
        if (_pictureArr.count == 1){
            _scrollView.scrollEnabled = NO;
            _pageCtl.hidden = YES;
        }
        else {
            _scrollView.scrollEnabled = YES;
            _pageCtl.hidden = NO;
        }
        UIButton *last = nil;
        UIButton *first = nil;
        for (int i = 0; i < picArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, width, height);
            button.tag = 100 + i;
            [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_pictureArr[i]] placeholderImage:[self getDefaultPic]];
            [button addTarget:self action:@selector(clickADCAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            x += width;
            if (first == nil) {
                first = button;
            }
            last = button;
        }
        
        if (last) {
            UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
            firstButton.frame = CGRectMake(x, y, width, height);
            [firstButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_pictureArr firstObject]] placeholderImage:[self getDefaultPic]];
            [_scrollView addSubview:firstButton];
        }
        
        if (first) {
            UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [lastButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_pictureArr lastObject]] placeholderImage:[self getDefaultPic]];
            lastButton.frame = CGRectMake(0, y, width, height);
            [_scrollView addSubview:lastButton];
            
        }
       _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }else { //如果没有广告业，则默认放置一张
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_pictureArr lastObject]] placeholderImage:[self getDefaultPic]];
        [self.scrollView addSubview:button];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

//点击广告事件
-(void)clickADCAction:(UIButton *)button{
    NSUInteger index = button.tag - 100;
    NSLog(@"tag:%zd", button.tag);
    if (self.clickADAction) {
        self.clickADAction(index, _detailUrlArr.count > index?_detailUrlArr[index]:nil);
    }
}

/**
 *  滚动广告页
 */
-(void)circleScrollImage
{
    int index = _scrollView.contentOffset.x / self.frame.size.width;
    
    self.pageCtl.currentPage = index - 1;
    
    if (index > _pictureArr.count) {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageCtl.currentPage = 0;
    }
    else if (index <= 0)
    {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * _pictureArr.count, 0);
        _pageCtl.currentPage = _pageCtl.numberOfPages - 1;
    }
}

/**
 *  计时器响应事件
 */
-(void)timerAction{
    float x = _scrollView.contentOffset.x + self.frame.size.width;
    if (self.isAnimat) {
        [UIView animateWithDuration:2.0 animations:^{
            _scrollView.contentOffset = CGPointMake(x, 0);
        }];
    }else
        _scrollView.contentOffset = CGPointMake(x, 0);
        
   
    
    [self circleScrollImage];
}

/**
 *  获取本地图片
 *
 *  @param picName 图片的名字
 *
 *  @return 获取的图片
 */
-(UIImage *)getLoacalPicWithName:(NSString *)picName{
    NSString *path = [[NSBundle mainBundle] pathForResource:picName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
/**
 *  没有图片时的默认图片
 *
 *  @return 默认图片
 */
-(UIImage *)getDefaultPic{
    return [self getLoacalPicWithName:@"pic_default"];
}

#pragma mark - Public Method
- (instancetype)initWithFrame:(CGRect)frame withPictures:(NSArray *)picArr withADDetailUrls:(NSArray *)detailUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareForUIWithPicArr:picArr withDetailUrl:detailUrl];
    }
    return self;
}

#pragma mark - Getter 和 Setter
-(void)setPictureArr:(NSArray *)pictureArr{
    if (_pictureArr != pictureArr) {
        _pictureArr = pictureArr;
    }
}

-(void)setDetailUrlArr:(NSArray *)detailUrlArr{
    if (_detailUrlArr != detailUrlArr) {
        _detailUrlArr = detailUrlArr;
    }
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
    }
    
    return _scrollView;
}

-(UIPageControl *)pageCtl{
    if (_pageCtl == nil) {
        _pageCtl = [[UIPageControl alloc] init];
        _pageCtl.hidden = NO;
        _pageCtl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageCtl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageCtl.numberOfPages = _pictureArr.count;
        _pageCtl.currentPage = 0;
        [self addSubview:_pageCtl];
        
        self.pageCtl.translatesAutoresizingMaskIntoConstraints = NO;
        _hContraint = [NSLayoutConstraint constraintWithItem:_pageCtl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        _vContraint = [NSLayoutConstraint constraintWithItem:_pageCtl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:-10.f];
        
        [self addConstraint:_vContraint];
        [self addConstraint:_hContraint];
    }
    
    return _pageCtl;
}

-(void)setInterval:(float)interval{
    if (_interval != interval) {
        _interval = interval;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

-(void)setPageCtrlPosition:(EPageCtlPosition)pageCtrlPosition{
    self.pageCtl.translatesAutoresizingMaskIntoConstraints = NO;
    [self removeConstraint:_hContraint];
    if (pageCtrlPosition == LEFT_BOTTOM) {
        _hContraint = [NSLayoutConstraint constraintWithItem:_pageCtl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:20.f];
        [self addConstraint:_hContraint];
        
    }else if (pageCtrlPosition == MIDDLE_BOTTOM){
        _hContraint = [NSLayoutConstraint constraintWithItem:_pageCtl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        [self addConstraint:_hContraint];
        
    }else if (pageCtrlPosition == RIGHT_BOTTOM){
        _hContraint = [NSLayoutConstraint constraintWithItem:_pageCtl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:-20.f];
        [self addConstraint:_hContraint];
        
    }
}

-(void)setIsAnimat:(BOOL)isAnimat{
    _isAnimat = isAnimat;
}
@end
