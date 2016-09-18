//
//  BulletView.m
//  弹幕
//
//  Created by xiudou on 16/9/18.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "BulletView.h"
// 间距
#define Padding 10
// 头像宽高
#define IconImageViewWH 30
@interface BulletView ()
/** 弹幕label */
@property (nonatomic,strong) UILabel *lbComment;
/** 头像 */
@property (nonatomic,strong) UIImageView *iconImageView;
@end
@implementation BulletView

// 初始化弹幕
- (instancetype)initWithComment:(NSString *)comment{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        // 计算文字的宽度
        CGFloat commentWidth = [comment sizeWithAttributes:dic].width;
        
        self.bounds = CGRectMake(0, 0, commentWidth + IconImageViewWH + 2 * Padding, 30);
        self.layer.cornerRadius = 30 * 0.5;
        
        self.iconImageView.frame = CGRectMake(0, 0, IconImageViewWH, IconImageViewWH);
        self.iconImageView.layer.cornerRadius = IconImageViewWH * 0.5;
        self.iconImageView.layer.borderColor = [UIColor orangeColor].CGColor;
        self.iconImageView.layer.borderWidth = 1;
        self.iconImageView.backgroundColor = [UIColor purpleColor];
        
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + IconImageViewWH, 0, commentWidth, 30);
        
    }
    
    return self;
}
// 开始动画
- (void)startAnimation{
    // 屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    // 设置时间
    CGFloat duration = 4.0f;
    // 弹幕➕屏幕的总宽
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    // 开始进入
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    // s(距离) = v(速度) * t(时间)
    // 弹幕移动的速度
    CGFloat speed = wholeWidth / duration;
    // 弹幕刚完全进入屏幕需要的时间
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    // 这个dispatch_time_t 不好  因为dispatch_time_t在执行的过程中无法让他停止
    // 方法 1
    //    int64_t enterDuration = CGRectGetWidth(self.bounds) / speed;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, enterDuration * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //
    //        if (self.moveStatusBlock) {
    //            self.moveStatusBlock(Enter);
    //        }
    //
    //    });
    
    // 方法2 延迟操作
    [self performSelector:@selector(enterScreen) withObject:self afterDelay:enterDuration];
    
    
    __block CGRect frame = self.frame;
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}
// 结束动画
- (void)stopAnimation{
    // 停止performSelector方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // 停止layer动画
    [self.layer removeAllAnimations];
    // 移除
    [self removeFromSuperview];
}

- (UILabel *)lbComment{
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}


- (void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
    
}


@end
