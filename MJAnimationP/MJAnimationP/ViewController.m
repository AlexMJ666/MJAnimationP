//
//  ViewController.m
//  MJAnimationP
//
//  Created by Mac on 2017/11/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "MJAnimation.h"
#import "MJAnimationVertical.h"
#import "MJAnimationRect.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate,UICollisionBehaviorDelegate>
@property(nonatomic,strong) MJAnimation* animations;
@property(nonatomic,strong) MJAnimationVertical * animationVertical;
@property(nonatomic,strong) MJAnimationRect * animationRect;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton* nextVC = [UIButton buttonWithType:UIButtonTypeCustom];
    nextVC.frame = CGRectMake(129, 250, 100, 44);
    nextVC.layer.borderWidth = 1;
    [nextVC setTitle:@"nextVC" forState:UIControlStateNormal];
    [nextVC setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [nextVC addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextVC];
    
    
}

-(void)next:(UIButton*)sender
{
    FirstViewController* vc = [FirstViewController new];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:^{
    }];
}

//返回一个管理动画过渡的对象
-(nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
//    动画1
//    if (!self.animations) {
//        self.animations = [MJAnimation new];
//    }
//    self.animations.circleCenterRect = CGRectMake(0, 0, 10, 10);
//    self.animations.type = AnimationTypeValue1;
//    self.animations.isPush = YES;
//    return self.animations;

//动画2
//    if (!self.animationVertical) {
//        self.animationVertical = [MJAnimationVertical new];
//    }
//    return self.animationVertical;

    if (!self.animationRect) {
        self.animationRect = [MJAnimationRect new];
    }
    return self.animationRect;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//动画1
//    if(!self.animations){
//        self.animations = [[MJAnimation alloc] init];
//    }
//    self.animations.type = AnimationTypeValue1;
//    self.animations.isPush = NO;
//    self.animations.circleCenterRect = CGRectMake(0, 0, 10, 10);
//    return self.animations;
//动画2
//    if (!self.animationVertical) {
//        self.animationVertical = [MJAnimationVertical new];
//    }
//    return self.animationVertical;
    if (!self.animationRect) {
        self.animationRect = [MJAnimationRect new];
    }
    return self.animationRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
