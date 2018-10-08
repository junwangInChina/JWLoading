//
//  JWLoadingEating.m
//  JWLoading
//
//  Created by wangjun on 2018/10/8.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingEating.h"

#import "JWLoadingDefine.h"

#define kMouthLayer_Width  20
#define kPointLayer_Width  10
#define kPointLayer_Margin 20
#define kPoint_Count       3

@interface JWLoadingEating ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingEating

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
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                               CGRectGetHeight(self.frame)/2.0);
        _mainShapeLayer.speed = 0.0f;
        [self.layer addSublayer:_mainShapeLayer];
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        UIBezierPath *tempMouthPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0,0)
                                                                   radius:kMouthLayer_Width
                                                               startAngle:M_PI_2
                                                                 endAngle:M_PI_2*3
                                                                clockwise:YES];
        [tempMouthPath closePath];
        for (NSInteger i = 0; i < 2; i++)
        {
            CAShapeLayer *tempMouthLayer = [CAShapeLayer layer];
            tempMouthLayer.path = tempMouthPath.CGPath;
            tempMouthLayer.fillColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            tempMouthLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
            // 调整圆心，相对父layer的位置
            tempMouthLayer.position = CGPointMake((CGRectGetWidth(self.frame) - kMouthLayer_Width*2)/2.0,
                                                CGRectGetHeight(self.frame)/2.0);
            // 旋转
            tempMouthLayer.transform = CATransform3DMakeRotation((1 - 2 * i) * M_PI_4, 0, 0, 1);
            [_mainShapeLayer addSublayer:tempMouthLayer];
            
            // 动画
            CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            tempAnimation.duration = 0.3f;
            tempAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((1 - 2 * i) * M_PI_4, 0, 0, 1)];
            tempAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((1 - 2 * i) * M_PI_2, 0, 0, 1)];
            tempAnimation.repeatCount = MAXFLOAT;
            tempAnimation.autoreverses = YES;
            tempAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [tempMouthLayer addAnimation:tempAnimation forKey:@"animation_transfer"];
        }
        
        // 吃的小球
        for (NSInteger i = 0; i < kPoint_Count; i++)
        {
            CALayer *tempLayer = [CALayer layer];
            tempLayer.frame = CGRectMake((CGRectGetWidth(self.frame) - kMouthLayer_Width)/2.0 + (kPointLayer_Width + kPointLayer_Margin) * 3,
                                         (CGRectGetHeight(self.frame) - kPointLayer_Width) / 2.0,
                                         kPointLayer_Width,
                                         kPointLayer_Width);
            tempLayer.backgroundColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            tempLayer.cornerRadius = kPointLayer_Width / 2.0;
            [_mainShapeLayer addSublayer:tempLayer];
            
            // 动画
            CABasicAnimation *tempTransformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            tempTransformAnimation.duration = 1.8f;
            tempTransformAnimation.beginTime = CACurrentMediaTime() - (i * 1.8f/kPoint_Count);
            tempTransformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
            tempTransformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-(kPointLayer_Width + kPointLayer_Margin) * 3, 0, 0)];
            tempTransformAnimation.repeatCount = MAXFLOAT;
            [tempLayer addAnimation:tempTransformAnimation forKey:@"animation_point"];
        }
    }
    return _mainShapeLayer;
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
