//
//  BulletManager.h
//  弹幕
//
//  Created by xiudou on 16/9/18.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

/** <#name#> */
@property (nonatomic,copy) void (^generateViewBlock)(BulletView *view);

// 弹幕开始执行
- (void)start;

// 弹幕结束执行
- (void)stop;
@end
