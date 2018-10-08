//
//  JWLoadingRotatingTrigon.m
//  JWLoading
//
//  Created by wangjun on 2018/10/8.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingRotatingTrigon.h"

#import "JWLoadingDefine.h"

#define kBallLayer_Width    10
#define kTrigonLayer_Radiu  30

@interface JWLoadingRotatingTrigon()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingRotatingTrigon

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
        _mainShapeLayer.speed = 0.0f;
        [self.layer addSublayer:_mainShapeLayer];
        
        UIBezierPath *tempPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kBallLayer_Width, kBallLayer_Width)];
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        CGPoint tempTopPoint = CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                           (CGRectGetHeight(self.frame) - kTrigonLayer_Radiu)/2.0);
        CGPoint tempLeftPoint = CGPointMake(tempTopPoint.x - cosf(M_PI * 0.3) * kTrigonLayer_Radiu,
                                            tempTopPoint.y + kTrigonLayer_Radiu + sinf(M_PI * 0.3));
        CGPoint tempRightPoint = CGPointMake(tempTopPoint.x + cosf(M_PI * 0.3) * kTrigonLayer_Radiu,
                                             tempTopPoint.y + kTrigonLayer_Radiu + sinf(M_PI * 0.3));
        NSArray *tempPoints = @[NSStringFromCGPoint(tempTopPoint),
                                NSStringFromCGPoint(tempLeftPoint),
                                NSStringFromCGPoint(tempRightPoint)];
        
        NSArray *tempValues = @[@[[NSValue valueWithCGPoint:tempTopPoint],
                                  [NSValue valueWithCGPoint:tempLeftPoint],
                                  [NSValue valueWithCGPoint:tempRightPoint],
                                  [NSValue valueWithCGPoint:tempTopPoint]],
                                @[[NSValue valueWithCGPoint:tempLeftPoint],
                                  [NSValue valueWithCGPoint:tempRightPoint],
                                  [NSValue valueWithCGPoint:tempTopPoint],
                                  [NSValue valueWithCGPoint:tempLeftPoint]],
                                @[[NSValue valueWithCGPoint:tempRightPoint],
                                  [NSValue valueWithCGPoint:tempTopPoint],
                                  [NSValue valueWithCGPoint:tempLeftPoint],
                                  [NSValue valueWithCGPoint:tempRightPoint]]];
        for (NSInteger i = 0; i < tempPoints.count; i++)
        {
            CGPoint tempPoint = CGPointFromString(tempPoints[i]);
            CAShapeLayer *tempBallLayer = [CAShapeLayer layer];
            tempBallLayer.path = tempPath.CGPath;
            tempBallLayer.fillColor = [UIColor clearColor].CGColor;
            tempBallLayer.strokeColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            tempBallLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
            tempBallLayer.position = tempPoint;
            [_mainShapeLayer addSublayer:tempBallLayer];
            
            CAKeyframeAnimation *tempAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            tempAnimation.duration = 2.0f;
            tempAnimation.repeatCount = MAXFLOAT;
            tempAnimation.keyTimes = @[@0.0f, @0.33f, @0.66f, @1.0f];
            tempAnimation.values = tempValues[i];
            tempAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [tempBallLayer addAnimation:tempAnimation forKey:@"animation_position"];
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
