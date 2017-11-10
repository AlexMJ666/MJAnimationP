//
//  MJAnimationRect.m
//  sfawv
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MJAnimationRect.h"
//应用程序的屏幕高度
#define kWindowH   [UIScreen mainScreen].bounds.size.height
//应用程序的屏幕宽度
#define kWindowW    [UIScreen mainScreen].bounds.size.width

#define kwidthCount         4
#define kHeightCount       5
@implementation MJAnimationRect

//- (UIDynamicAnimator *)animator
//{
//    if (!_animator) {
//        //创建物理仿真器(ReferenceView, 参照视图, 其实就是设置仿真范围)
//        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self.transitionContext containerView]];
//    }
//    return _animator;
//}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [self AnimationAnimationType:transitionContext andToVC:toVC andFromVC:fromVC];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

-(void)AnimationAnimationType:(id<UIViewControllerContextTransitioning>)transitionContext andToVC:(UIViewController*)toVC andFromVC:(UIViewController*)fromVC
{
    //通过上下文获取跳转的view
    UIView *containerView = [transitionContext containerView];
    
    //将fromVC截图
    UIView *mainSnap = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    //调用cutView方法将截图切成4*5点格子并添加到当前的containerView上
    NSMutableArray* cutViewArray = [self cutView:mainSnap intoSlicesOfWidth:mainSnap.frame.size.width/kwidthCount andHeight:mainSnap.frame.size.height/kHeightCount];
    for (int i=0; i<cutViewArray.count; i++) {
        UIView* cutView = (UIView*)cutViewArray[i];
        //添加之前随机对切图进行微角度旋转，以增加动画效果
        CGFloat angle = (i% 2 ? 1 : -1) * (rand() % 5 / 10.0);
        cutView.transform = CGAffineTransformMakeRotation(angle);
        [containerView addSubview:cutView];
    }
    
    //获取目标view并添加到界面，置于页面底部，暂时先把他的alpha置为0
    UIView* toView = [toVC view];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    toView.alpha = 0;
    
    //截图已经覆盖fromView.view 所以可以直接隐藏。
    fromVC.view.hidden = YES;

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
    UIDynamicBehavior *behaviour = [[UIDynamicBehavior alloc] init];
    //为每个view添加重力
    UIGravityBehavior* gravity = [[UIGravityBehavior alloc] initWithItems:cutViewArray];
    gravity.gravityDirection = CGVectorMake(0, 1); // 方向
    gravity.magnitude = 5; //加速度
    // 碰撞检测
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:cutViewArray];
    // 设置不要出边界，碰到边界会被反弹
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionDelegate = self;
    //除了边界碰撞没有其他碰撞
    collision.collisionMode = UICollisionBehaviorModeBoundaries;
    [behaviour addChildBehavior:gravity];
    [behaviour addChildBehavior:collision];
    
    //每个view设置不同的动画效果，添加到总的动作中去
    for (UIView *aView in cutViewArray) {
        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[aView]];
        itemBehaviour.elasticity = (rand() % 5) / 8.0;
        itemBehaviour.density = (rand() % 5 / 3.0);
                itemBehaviour.allowsRotation = YES;
        [behaviour addChildBehavior:itemBehaviour];
    }
    [self.animator addBehavior:behaviour];
    toView.alpha = 1;
    
    [UIView animateWithDuration:1 animations:^{
        for (UIView *aView in cutViewArray) {
            aView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        for (UIView *view in cutViewArray) {
            [view removeFromSuperview];
        }
        [cutViewArray removeAllObjects];
        fromVC.view.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

-(NSMutableArray *)cutView:(UIView *)view intoSlicesOfWidth:(float)width andHeight:(float)height{
    NSMutableArray *lineViews = [NSMutableArray array];
    UIView *subsnapshot;
    for (int x=0; x<CGRectGetWidth(view.frame); x+=width) {
        for (int y=0;y<CGRectGetHeight(view.frame); y+=height) {
            CGRect subrect = CGRectMake(x, y, width, height);
            subsnapshot = nil;
            subsnapshot = [view resizableSnapshotViewFromRect:subrect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
            subsnapshot.frame = subrect;
            [lineViews addObject:subsnapshot];
        }
    }
    return lineViews;
}
@end
