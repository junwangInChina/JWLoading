//
//  JWLoadingMultiPulse.m
//  JWLoading
//
//  Created by wangjun on 2018/10/8.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingMultiPulse.h"

#import "JWLoadingDefine.h"

#define kPulseLayer_Radiu 50
#define kPulse_Count      3

@interface JWLoadingMultiPulse()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingMultiPulse

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 50, 50);
        self.pulse_radius = kPulseLayer_Radiu;
        self.pulse_count = kPulse_Count;
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

#pragma mark - Layy loading
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

        NSTimeInterval beginTime = CACurrentMediaTime();

        for (NSInteger i = 0; i < self.pulse_count; i++)
        {
            CALayer *tempLayer = [CALayer layer];
            tempLayer.frame = CGRectMake(0, 0, self.pulse_radius, self.pulse_radius);
            tempLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
            tempLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0);
            tempLayer.cornerRadius = self.pulse_radius/2.0;
            tempLayer.backgroundColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            tempLayer.opacity = 0.8f;
            tempLayer.transform = CATransform3DMakeScale(0, 0, 0);
            [tempLayer addAnimation:[self animationGroup:(beginTime + i * 0.2f)] forKey:@"animation_group"];
            
            [_mainShapeLayer addSublayer:tempLayer];
        }
    }
    return _mainShapeLayer;
}

#pragma mark - Helper
- (CAAnimationGroup *)animationGroup:(CGFloat)begin
{
    CABasicAnimation *tempTransAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    tempTransAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    tempTransAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)];
    
    CABasicAnimation *tempOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    tempOpacityAnimation.fromValue = @(0.8f);
    tempOpacityAnimation.toValue = @(0.0f);
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.beginTime = begin;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.duration = 1.2f;
    tempGroup.animations = @[tempTransAnimation, tempOpacityAnimation];
    
    return tempGroup;
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
