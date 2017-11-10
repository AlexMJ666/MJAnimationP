//
//  MJAnimationVertical.m
//  sfawv
//
//  Created by Mac on 2017/11/3.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MJAnimationVertical.h"

@implementation MJAnimationVertical

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //获取fromVC与toVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过上下文获取跳转的view
    UIView *containerView = [transitionContext containerView];
    
    //将fromVC截图
    UIView *mainSnap = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    //fromVC分割成宽度为5的view
    NSArray *outgoingLineViews = [self cutView:mainSnap intoSlicesOfWidth:3];
    
    //将分割出来的view加入到主页面，用作动画
    for (int i = 0; i <outgoingLineViews.count;i++) {
        [containerView addSubview:(UIView*)outgoingLineViews[i]];
    }
    
    //toVC的view加入到跳转页面的view中，并放到分隔view到后面
    UIView *toView = [toVC view];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    CGFloat toViewStartY = toView.frame.origin.y;
    toView.alpha = 0;
    
    //因为已用分割view界面，所以本来到fromview久不需要显示了
    fromVC.view.hidden = YES;
    
    
    [UIView animateWithDuration:4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    } completion:^(BOOL finished) {
        
        //将toView切割保存
        toVC.view.alpha = 1;
        UIView *mainInSnap = [toView snapshotViewAfterScreenUpdates:YES];
        NSArray *incomingLineViews = [self cutView:mainInSnap intoSlicesOfWidth:3];
        
        //切割出来的line位置参差排列并添加到跳转view
        [self repositionViewSlices:incomingLineViews moveFirstFrameUp:NO];
        for (UIView *v in incomingLineViews) {
            [containerView addSubview:v];
        }
        toView.hidden = YES;
        
        [UIView animateWithDuration:4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //fromview的line以动画形式出界面，toview的line以动画形式复原fram也就是回到界面
            [self repositionViewSlices:outgoingLineViews moveFirstFrameUp:YES];
            [self resetViewSlices:incomingLineViews toYOrigin:toViewStartY];
        } completion:^(BOOL finished) {
            fromVC.view.hidden = NO;
            toView.hidden = NO;
            [toView setNeedsUpdateConstraints];
            for (UIView *v in incomingLineViews) {
                [v removeFromSuperview];
            }
            for (UIView *v in outgoingLineViews) {
                [v removeFromSuperview];
            }
            [transitionContext completeTransition:YES];
        }];
        
    }];
    
}

-(NSMutableArray *)cutView:(UIView *)view intoSlicesOfWidth:(float)width{
    
    CGFloat lineHeight = CGRectGetHeight(view.frame);
    
    NSMutableArray *lineViews = [NSMutableArray array];
    UIView *subsnapshot;
    for (int x=0; x<CGRectGetWidth(view.frame); x+=width) {
        CGRect subrect = CGRectMake(x, 0, width, lineHeight);
        subsnapshot = nil;
        subsnapshot = [view resizableSnapshotViewFromRect:subrect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        subsnapshot.frame = subrect;
        [lineViews addObject:subsnapshot];
    }
    return lineViews;
}

-(void)repositionViewSlices:(NSArray *)views moveFirstFrameUp:(BOOL)startUp{
    BOOL up = startUp;
    CGRect frame;
    float height;
    for (UIView *line in views) {
        frame = line.frame;
        height = CGRectGetHeight(frame) * RANDOM_FLOAT(1.0, 4.0);
        frame.origin.y += (up)?-height:height;
        line.frame = frame;
        up = !up;
    }
}

-(void)resetViewSlices:(NSArray *)views toYOrigin:(CGFloat)y{
    
    CGRect frame;
    for (UIView *line in views) {
        frame = line.frame;
        frame.origin.y = y;
        line.frame = frame;
    }
}




@end
