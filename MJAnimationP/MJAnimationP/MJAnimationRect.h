//
//  MJAnimationRect.h
//  sfawv
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MJAnimationRect : NSObject<UIViewControllerAnimatedTransitioning,UICollisionBehaviorDelegate>
@property (strong , nonatomic) id < UIViewControllerContextTransitioning > transitionContext;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end
