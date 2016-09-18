//
//  BulletManager.m
//  弹幕
//
//  Created by xiudou on 16/9/18.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager ()
/** 弹幕的数据来源 */
@property (nonatomic,strong) NSMutableArray *datasource;

/** 弹幕使用过程中的数组变量 */
@property (nonatomic,strong) NSMutableArray *bulletComments;

/** 存储弹幕view的数组变量 */
@property (nonatomic,strong) NSMutableArray *bulletViews;

/** <#name#> */
@property (nonatomic,assign) BOOL stopAnimation;

@end
@implementation BulletManager


- (instancetype)init{
    if (self = [super init]) {
        self.stopAnimation = YES;
    }
    return self;
}


#pragma mark - 懒加载
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithArray:@[@"弹道1~~~~~",
                                                       @"弹道2~~~~~~~~~~",
                                                       @"弹道3~~~~~~~~~~~~~~~~~~~",
                                                       @"弹道1~~~~~",
                                                       @"弹道2~~~~~~~~~~",
                                                       @"弹道3~~~~~~~~~~~~~~~~~~~",
                                                       @"弹道1~~~~~",
                                                       @"弹道2~~~~~~~~~~",
                                                       @"弹道3~~~~~~~~~~~~~~~~~~~"
                                                       ]];
    }
    return _datasource;
}

- (NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}
#pragma mark - 执行操作
- (void)start{
    if (!self.stopAnimation) {
        return;
    }
    self.stopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    [self initBulletComment];
}

- (void)stop{
    if (self.stopAnimation) {
        return;
    }
    self.stopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BulletView *bulletView = obj;
        [bulletView stopAnimation];
        bulletView = nil;
        
    }];
    
    [self.bulletViews removeAllObjects];
}


// 初始化弹道 随机分配弹道轨迹
- (void)initBulletComment {
    if (self.bulletComments.count > 0) {
        NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
        for (int i = 0; i < 3 ; i ++) {
            
            // 1 取出随机弹道
            NSInteger index = arc4random() % trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            // 2 删除取出的弹道
            [trajectorys removeObjectAtIndex:index];
            
            // 3 从弹幕数组中取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            // 4 删除弹幕数组中的数据
            [self.bulletComments removeObjectAtIndex:0];
            
            // 5 创建弹幕view
            [self creatBullerView:comment trajectory:trajectory];
        }
        
    }
}

- (void)creatBullerView:(NSString *)comment trajectory:(int)trajectory{
    if (self.stopAnimation) {return;}
    // 1 创建弹幕
    BulletView *bulletView = [[BulletView alloc] initWithComment:comment];
    // 2 赋值弹道
    bulletView.trajectory = trajectory;
    // 3 添加到数组中
    [self.bulletViews addObject:bulletView];
    
    __weak typeof(bulletView) weakBulletView = bulletView;
    __weak typeof(self) weakSelf = self;
    bulletView.moveStatusBlock = ^(MoveStasus status){
        
        if (self.stopAnimation) {return;}
        
        switch (status) {
            case Start:{   // 开始  😏
                [weakSelf.bulletViews addObject:weakBulletView];
            }
                break;
            case Enter:{   // 屁股刚进入  😍
                // 弹幕刚全部进入屏幕后,判断后面是否还有内容,如果有则在该弹道上添加该弹幕
                NSString *comment = [self nextComment];
                if (comment) {
                    [self creatBullerView:comment trajectory:trajectory];
                }
            }
                break;
            case End:{   // 屁股刚移除屏幕 🙅
                // 移除屏幕后销毁弹幕  释放资源
                if ([self.bulletViews containsObject:weakBulletView]) {
                    
                    [weakBulletView stopAnimation];
                    
                    [weakSelf.bulletViews removeObject:weakBulletView];
                }
                
                // 当数组中没有值时 重新开始
                if (self.bulletViews.count == 0) {
                    // 回复控制变量初始值
                    self.stopAnimation = YES;
                    // 重新开始
                    [weakSelf start];
                }
                
            }
                break;
                
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(bulletView);
    }
}

- (NSString *)nextComment{
    if (self.bulletComments.count == 0) return  nil;
    
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
    
}
@end
