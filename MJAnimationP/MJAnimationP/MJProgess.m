//
//  MJProgess.m
//  MJAnimationP
//
//  Created by Mac on 2017/11/10.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MJProgess.h"
@interface MJProgess()
@property(nonatomic,strong) UILabel* progressLabel;
@end
@implementation MJProgess
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initMJprogress];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMJprogress];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMJprogress];
    }
    return self;
}

-(void)initMJprogress
{
    self.lineWidth = 10.0f;
    self.bkColor = [UIColor grayColor];
    self.proGressColor = [UIColor blueColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.progressLabel = [UILabel new];
    self.progressLabel.textColor = [UIColor blackColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.text = @"0.0%";
    self.progressLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressLabel];
    self.backgroundColor = [UIColor clearColor];
    self.progressLabel.frame = CGRectMake(self.lineWidth, self.lineWidth, self.bounds.size.width-2*self.lineWidth, self.bounds.size.height-2*self.lineWidth);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextAddArc(contextRef, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2 - _lineWidth,  0, 2*M_PI, 0);
    CGContextSetLineWidth(contextRef, self.lineWidth);
    [self.bkColor setStroke];
    CGContextStrokePath(contextRef);
    
    
    float endAngle = _progress * (2 * M_PI);
    CGContextAddArc(contextRef,  self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2 - _lineWidth,  0, endAngle, 0);
    //设置背景的宽度
    CGContextSetLineWidth(contextRef, _lineWidth);
    //设置背景颜色
    [self.proGressColor setStroke];
    //绘制轨道
    CGContextStrokePath(contextRef);
    
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress > 1 || progress < 0) return;
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress*100];
    // 标记为需要重新绘制, 将会在下一个绘制循环中, 调用drawRect:方法重新绘制
    [self setNeedsDisplay];
    
}
@end
