//
//  JWLoadingBallRotatePulse.m
//  JWLoading
//
//  Created by wangjun on 2018/9/29.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingBallRotatePulse.h"

#import "JWLoadingDefine.h"

#define kBallLayer_Width  35
#define kBallLayer_Height 35

#define kCycleLayer_Width  50
#define kCycleLayer_Height 50

@interface JWLoadingBallRotatePulse()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingBallRotatePulse

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 100, 100);
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat tempWidth = frame.size.width;
    CGFloat tempHeight = frame.size.height;
    if (tempWidth <= 100)
    {
        tempWidth = 100;
    }
    if (tempHeight <= 100)
    {
        tempHeight = 100;
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
        _mainShapeLayer.speed = 0.0f;
        
        [self.layer addSublayer:_mainShapeLayer];
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        CALayer *tempBallLayer = [CALayer layer];
        tempBallLayer.frame = CGRectMake(0, 0, kBallLayer_Width, kBallLayer_Height);
        tempBallLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        tempBallLayer.position = CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)/2.0, CGRectGetHeight(_mainShapeLayer.frame)/2.0);
        tempBallLayer.cornerRadius = kBallLayer_Width / 2.0;
        tempBallLayer.backgroundColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
        [tempBallLayer addAnimation:[self ballAnimationGroup] forKey:@"animation_ball"];
        [_mainShapeLayer addSublayer:tempBallLayer];
        
        CAShapeLayer *tempCycleLayer = [CAShapeLayer layer];
        tempCycleLayer.frame = CGRectMake(0, 0, kCycleLayer_Width, kCycleLayer_Height);
        tempCycleLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        tempCycleLayer.position = CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)/2.0,
                                              CGRectGetHeight(_mainShapeLayer.frame)/2.0);
        tempCycleLayer.path = [self cycleBezierPath].CGPath;
        tempCycleLayer.lineWidth = 2.0f;
        tempCycleLayer.strokeColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
        tempCycleLayer.fillColor = nil;
        [tempCycleLayer addAnimation:[self cycleAnimationGroup] forKey:@"animation_cycle"];
        [_mainShapeLayer addSublayer:tempCycleLayer];

    }
    return _mainShapeLayer;
}

#pragma mark - Helper
- (CAAnimationGroup *)ballAnimationGroup
{
    CAKeyframeAnimation *tempSaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    tempSaleAnimation.keyTimes = @[@0.0, @0.3, @1.0];
    tempSaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    tempSaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.29 :0.57 :0.49 :0.9],
                                          [CAMediaTimingFunction functionWithControlPoints:0.29 :0.57 :0.49 :0.9]];
    
    
    CABasicAnimation *tempOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    tempOpacityAnimation.fromValue = @0.0;
    tempOpacityAnimation.toValue = @1.0;
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = 1.0f;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.animations = @[tempSaleAnimation, tempOpacityAnimation];
    
    return tempGroup;
}

- (UIBezierPath *)cycleBezierPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath addArcWithCenter:CGPointMake(kCycleLayer_Width/2.0, kCycleLayer_Height/2.0)
                        radius:kCycleLayer_Width/2.0
                    startAngle:-(M_PI_4 * 3)
                      endAngle:-M_PI_4
                     clockwise:YES];
    [tempPath moveToPoint:CGPointMake(kCycleLayer_Width/2.0 + kCycleLayer_Width/2.0 * cosf(M_PI / 4),
                                      kCycleLayer_Width/2.0 + kCycleLayer_Width/2.0 * sinf(M_PI / 4))];

    [tempPath addArcWithCenter:CGPointMake(kCycleLayer_Width/2.0, kCycleLayer_Height/2.0)
                        radius:kCycleLayer_Width/2.0
                    startAngle:(M_PI_4 * 1)
                      endAngle:(M_PI_4 * 3)
                     clockwise:YES];
    
    return tempPath;
}

- (CAAnimationGroup *)cycleAnimationGroup
{
    CAKeyframeAnimation *tempSaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    tempSaleAnimation.keyTimes = @[@0.0, @0.5, @1.0];
    tempSaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    tempSaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.29 :0.57 :0.49 :0.9],
                                          [CAMediaTimingFunction functionWithControlPoints:0.29 :0.57 :0.49 :0.9]];
    
    
    CAKeyframeAnimation *tempRotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    tempRotateAnimation.keyTimes = @[@0.0, @0.5, @1.0];
    tempRotateAnimation.values = @[@0, @(M_PI), @(M_PI * 2)];
    tempRotateAnimation.timingFunctions = tempSaleAnimation.timingFunctions;
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = 1.0f;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.animations = @[tempSaleAnimation, tempRotateAnimation];
    
    return tempGroup;
}

#pragma mark - Public Method
- (void)startAnimation
{
    self.mainShapeLayer.speed = 1.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
