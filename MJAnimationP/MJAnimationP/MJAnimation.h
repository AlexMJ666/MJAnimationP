//
//  MJAnimation.h
//  MJAnimationP
//
//  Created by Mac on 2017/11/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define RANDOM_FLOAT(MIN,MAX) (((CGFloat)arc4random() / 0x100000000) * (MAX - MIN) + MIN);


typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeValue1,
    AnimationTypeValue2,
};

@interface MJAnimation : NSObject<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
@property (strong , nonatomic) id < UIViewControllerContextTransitioning > transitionContext;
@property (assign , nonatomic) AnimationType type;
@property (assign ,nonatomic) BOOL isPush;
@property (assign , nonatomic) CGRect circleCenterRect;
@end
