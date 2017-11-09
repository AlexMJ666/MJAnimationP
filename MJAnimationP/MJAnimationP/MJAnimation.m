//
//  MJAnimation.m
//  sfawv
//
//  Created by Mac on 2017/11/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MJAnimation.h"
//应用程序的屏幕高度
#define kWindowH   [UIScreen mainScreen].bounds.size.height
//应用程序的屏幕宽度
#define kWindowW    [UIScreen mainScreen].bounds.size.width
@implementation MJAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (self.type == AnimationTypeValue1) {
        [self AnimationAnimationTypeValue1:transitionContext andToVC:toVC andFromVC:fromVC];
    }else if (self.type == AnimationTypeValue2)
    {
        [self AnimationAnimationTypeValue2:transitionContext andToVC:toVC andFromVC:fromVC];
    }
}

#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

#pragma mark -- AnimationAnimationTypeValue1

-(void)AnimationAnimationTypeValue1:(id<UIViewControllerContextTransitioning>)transitionContext andToVC:(UIViewController*)toVC andFromVC:(UIViewController*)fromVC
{
    UIBezierPath *smallCircle =  [UIBezierPath bezierPathWithOvalInRect:_circleCenterRect];
    
    CGFloat centerX = self.circleCenterRect.origin.x + (self.circleCenterRect.size.width/2);
    CGFloat centerY = self.circleCenterRect.origin.y - (self.circleCenterRect.size.height/2);
    
    CGFloat circleR1 = (kWindowW - centerX) > centerX ? (kWindowW - centerX) : centerX;
    CGFloat circleR2 = (kWindowH - centerY) > centerY ? (kWindowH - centerY) :centerY;
    
    CGFloat radius = sqrt(circleR1 * circleR1 + circleR2 * circleR2);
    
    UIBezierPath *largeCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.circleCenterRect, -radius, -radius)];
    
    if (_isPush) {
        [[transitionContext containerView] addSubview:toVC.view];
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        toVC.view.layer.mask = shapeLayer;
        shapeLayer.path = largeCircle.CGPath;
        
        CABasicAnimation*  shapeLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        shapeLayerAnimation.fromValue = (__bridge id _Nullable)(smallCircle.CGPath);
        shapeLayerAnimation.toValue = (__bridge id _Nullable)(largeCircle.CGPath);
        shapeLayerAnimation.duration = [self transitionDuration:transitionContext ];
        shapeLayerAnimation.delegate = self;
        [shapeLayer addAnimation:shapeLayerAnimation forKey:@"path"];
    }else
    {
        [[transitionContext containerView] addSubview:toVC.view];
        [[transitionContext containerView] sendSubviewToBack:toVC.view];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = smallCircle.CGPath;
        fromVC.view.layer.mask = shapeLayer;
        
        CABasicAnimation *shapeLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        shapeLayerAnimation.fromValue = (__bridge id _Nullable)(largeCircle.CGPath);
        shapeLayerAnimation.toValue = (__bridge id _Nullable)((smallCircle.CGPath));
        shapeLayerAnimation.duration = [self transitionDuration:transitionContext];
        shapeLayerAnimation.delegate = self;
        [shapeLayer addAnimation:shapeLayerAnimation forKey:@"path"];
    }
}

#pragma mark -- AnimationAnimationTypeValue2
-(void)AnimationAnimationTypeValue2:(id<UIViewControllerContextTransitioning>)transitionContext andToVC:(UIViewController*)toVC andFromVC:(UIViewController*)fromVC
{
    CGRect endFrame = [transitionContext initialFrameForViewController:fromVC];
    if (self.isPush) {
        fromVC.view.frame = endFrame;
        [transitionContext.containerView addSubview:fromVC.view];
        
        UIView *toView = [toVC view];
        [transitionContext.containerView addSubview:toView];
        
        //get the original position of the frame
        CGRect startFrame = toView.frame;
        //save the unmodified frame as our end frame
        endFrame = startFrame;
        
        //now move the start frame to the left by our width
        startFrame.origin.x += CGRectGetWidth(startFrame);
        toView.frame = startFrame;
        
        //now set up the destination for the outgoing view
        UIView *fromView = [fromVC view];
        CGRect outgoingEndFrame = fromView.frame;
        outgoingEndFrame.origin.x -= CGRectGetWidth(outgoingEndFrame);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            toView.frame = endFrame;
            toView.alpha = 1;
            fromView.frame = outgoingEndFrame;
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            fromView.alpha = 1;
            [toView setNeedsUpdateConstraints];
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        UIView *toView = [toVC view];
        //incoming view
        CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
        toFrame.origin.x -= CGRectGetWidth(toFrame);
        toView.frame = toFrame;
        toFrame = [transitionContext finalFrameForViewController:toVC];
        [transitionContext.containerView addSubview:toView];
        [transitionContext.containerView addSubview:fromVC.view];
        
        //outgoing view
        endFrame.origin.x += CGRectGetWidth(endFrame);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toView.frame = toFrame;
            toView.alpha = 1;
            fromVC.view.frame = endFrame;
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            fromVC.view.alpha = 1;
            [transitionContext completeTransition:YES];
        }];
    }
}
@end

