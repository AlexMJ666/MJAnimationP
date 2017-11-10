//
//  MJProgess.h
//  MJAnimationP
//
//  Created by Mac on 2017/11/10.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MJProgess : UIView

@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) UIColor* bkColor;
@property(nonatomic,strong) UIColor* proGressColor;
@property(nonatomic,assign) CGFloat lineWidth;
@end
