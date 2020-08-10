//
//  JWLoadingDotRotateOpacity.m
//  JWLoading
//
//  Created by wangjun on 2018/10/8.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingDotRotateOpacity.h"

#import "JWLoadingDefine.h"

#define kDotLayer_Width  10
#define kDotLayer_Height 10
#define kDotLayer_Margin 10
#define kDot_Count       3

@interface JWLoadingDotRotateOpacity ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingDotRotateOpacity

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 50, 50);
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat tempWidth = frame.size.width;
    CGFloat tempHeight = frame.size.height;
    if (tempWidth <= 50)
    {
        tempWidth = 50;
    }
    if (tempHeight <= 50)
    {
        tempHeight = 50;
    }
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, tempWidth, tempHeight)];
}

#pragma mark - Lazy loading
- (CAShapeLayer *)mainShapeLayer
{
    if (!_mainShapeLayer)
    {
        self.mainShapeLayer = [CAShapeLayer layer];
        _mainShapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _mainShapeLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        [_mainShapeLayer addAnimation:[self mainAnimationGroup] forKey:@"animation_main"];
        _mainShapeLayer.speed = 0.0f;
        
        CGFloat tempX = (CGRectGetWidth(self.frame) - (kDot_Count * kDotLayer_Width + (kDot_Count - 1) * kDotLayer_Margin)) / 2.0;
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;
        
        BOOL hasMiddle = kDot_Count%2 > 0;
        
        for (NSInteger i = 0; i < kDot_Count; i++)
        {
            CALayer *tempLayer = [CALayer layer];
            tempLayer.frame = CGRectMake(tempX + (i * (kDotLayer_Width + kDotLayer_Margin)),
                                         (CGRectGetHeight(self.frame) - kDotLayer_Height)/2.0,
                                         kDotLayer_Width,
                                         kDotLayer_Height);
            tempLayer.cornerRadius = kDotLayer_Width / 2.0;
            tempLayer.masksToBounds = YES;
            tempLayer.backgroundColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            
            if (hasMiddle)
            {
                if (i != kDot_Count / 2)
                {
                    [tempLayer addAnimation:[self opacityAnimation] forKey:@"animation_opacity"];
                }
            }
            
            
            [_mainShapeLayer addSublayer:tempLayer];
        }
        
        [self.layer addSublayer:_mainShapeLayer];
    }
    return _mainShapeLayer;
}

- (CAAnimationGroup *)mainAnimationGroup
{
    CAKeyframeAnimation *tempSaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    tempSaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    tempSaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 0.6f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    tempSaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.7f :-0.13f :0.22f :0.89f],
                                          [CAMediaTimingFunction functionWithControlPoints:0.7f :-0.13f :0.22f :0.89f]];
    
    CAKeyframeAnimation *tempRotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    tempRotateAnimation.keyTimes = tempSaleAnimation.keyTimes;
    tempRotateAnimation.values = @[@0, @(-M_PI), @(-M_PI * 2)];
    tempRotateAnimation.timingFunctions = tempSaleAnimation.timingFunctions;
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = 1.0f;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.animations = @[tempSaleAnimation,tempRotateAnimation];
    
    return tempGroup;
}

- (CAKeyframeAnimation *)opacityAnimation
{
    CAKeyframeAnimation *tempAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    tempAnimation.duration = 1.0f;
    tempAnimation.repeatCount = MAXFLOAT;
    tempAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    tempAnimation.values = @[@1.0f, @0.3f, @1.0f];
    
    return tempAnimation;
}

#pragma mark - Public Method
- (void)startAnimation
{
    self.mainShapeLayer.speed = 1.0f;
}

- (void)stopAnimation
{
    self.mainShapeLayer.speed = 0.0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
