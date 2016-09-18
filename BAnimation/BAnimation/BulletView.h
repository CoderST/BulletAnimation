//
//  BulletView.h
//  弹幕
//
//  Created by xiudou on 16/9/18.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,MoveStasus) {
    Start,
    Enter,
    End
};
@interface BulletView : UIView
/** 弹道 */
@property (nonatomic,assign) int trajectory;
/** 弹幕的回调 */
@property (nonatomic,copy) void (^moveStatusBlock)(MoveStasus status);

// 初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;
// 开始动画
- (void)startAnimation;
// 结束动画
- (void)stopAnimation;
@end
