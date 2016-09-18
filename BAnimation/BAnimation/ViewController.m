//
//  ViewController.m
//  BAnimation
//
//  Created by xiudou on 16/9/18.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"
@interface ViewController ()
@property (nonatomic,strong) BulletManager *bulletManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bulletManager = [[BulletManager alloc] init];
    __weak typeof(self) weakSelf = self;
    self.bulletManager.generateViewBlock = ^(BulletView *view){
        [weakSelf addBulletView:view];
    };
    
    UIButton *startButotn = [[UIButton alloc] init];
    [startButotn setTitle:@"开始" forState:UIControlStateNormal];
    [startButotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startButotn.frame = CGRectMake(50, 50, 50, 50);
    [self.view addSubview:startButotn];
    [startButotn addTarget:self action:@selector(startButotnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopButotn = [[UIButton alloc] init];
    [stopButotn setTitle:@"结束" forState:UIControlStateNormal];
    [stopButotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    stopButotn.frame = CGRectMake(250, 50, 50, 50);
    [self.view addSubview:stopButotn];
    [stopButotn addTarget:self action:@selector(stopButotnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startButotnClick{
    [self.bulletManager start];
}
- (void)stopButotnClick{
    [self.bulletManager stop];
}
- (void)addBulletView:(BulletView *)view{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    view.frame = CGRectMake(width, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

@end
