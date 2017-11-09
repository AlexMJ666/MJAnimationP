#import "MJAnimation.h"
#define kWindowH   [UIScreen mainScreen].bounds.size.height
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
    [self AnimationAnimationTypeValue:transitionContext andToVC:toVC andFromVC:fromVC];
}

#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

#pragma mark -- AnimationAnimationTypeValue
-(void)AnimationAnimationTypeValue:(id<UIViewControllerContextTransitioning>)transitionContext andToVC:(UIViewController*)toVC andFromVC:(UIViewController*)fromVC
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
@end
