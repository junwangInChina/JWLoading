//
//  JWLoadingHourglass.m
//  JWLoading
//
//  Created by wangjun on 2018/9/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingHourglass.h"

#import "JWLoadingDefine.h"

#define kLayer_Width  42
#define kLayer_Height 21

@interface JWLoadingHourglass()

@property (nonatomic, strong) CAShapeLayer *topShapeLayer;
@property (nonatomic, strong) CAShapeLayer *bottomShapeLayer;
@property (nonatomic, strong) CAShapeLayer *lineShapeLayer;
@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@property (strong, nonatomic) CAKeyframeAnimation *topKeyframeAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *bottomKeyframeAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *lineKeyframeAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *mainKeyframeAnimation;

@end

@implementation JWLoadingHourglass

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
        _mainShapeLayer.backgroundColor = self.backgroundColor.CGColor;
        _mainShapeLayer.frame = CGRectMake(0, 0, kLayer_Width, kLayer_Height*2);
        _mainShapeLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        [_mainShapeLayer addAnimation:self.mainKeyframeAnimation forKey:@"main_animation"];
        _mainShapeLayer.speed = 0.0f;
        [self.layer addSublayer:_mainShapeLayer];
        
    }
    return _mainShapeLayer;
}

- (CAShapeLayer *)topShapeLayer
{
    if (!_topShapeLayer)
    {
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        [tempPath moveToPoint:CGPointMake(0, 0)];
        [tempPath addLineToPoint:CGPointMake(kLayer_Width, 0)];
        [tempPath addLineToPoint:CGPointMake(kLayer_Width/2.0, kLayer_Height)];
        [tempPath addLineToPoint:CGPointMake(0, 0)];
        [tempPath closePath];
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;
        
        self.topShapeLayer = [CAShapeLayer layer];
        _topShapeLayer.frame = CGRectMake(0, 0, kLayer_Width, kLayer_Height);
        _topShapeLayer.path = tempPath.CGPath;
        _topShapeLayer.fillColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
        _topShapeLayer.strokeColor = _topShapeLayer.fillColor;
        _topShapeLayer.lineWidth = 0.0f;
        _topShapeLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
        _topShapeLayer.position = CGPointMake(kLayer_Width/2.0, kLayer_Height);
        [_topShapeLayer addAnimation:self.topKeyframeAnimation forKey:@"top_animation"];
        _topShapeLayer.speed = 0.0f;
        
        [self.mainShapeLayer addSublayer:_topShapeLayer];
    }
    return _topShapeLayer;
}

- (CAShapeLayer *)bottomShapeLayer
{
    if (!_bottomShapeLayer)
    {
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        [tempPath moveToPoint:CGPointMake(kLayer_Width/2.0, 0)];
        [tempPath addLineToPoint:CGPointMake(kLayer_Width, kLayer_Height)];
        [tempPath addLineToPoint:CGPointMake(0, kLayer_Height)];
        [tempPath addLineToPoint:CGPointMake(kLayer_Width/2.0, 0)];
        [tempPath closePath];
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        self.bottomShapeLayer = [CAShapeLayer layer];
        _bottomShapeLayer.frame = CGRectMake(0, kLayer_Height, kLayer_Width, kLayer_Height);
        _bottomShapeLayer.path = tempPath.CGPath;
        _bottomShapeLayer.fillColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
        _bottomShapeLayer.strokeColor = _topShapeLayer.fillColor;
        _bottomShapeLayer.lineWidth = 0.0f;
        _bottomShapeLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
        _bottomShapeLayer.position = CGPointMake(kLayer_Width/2.0, kLayer_Height*2.0);
        _bottomShapeLayer.transform = CATransform3DMakeScale(0, 0, 0);
        [_bottomShapeLayer addAnimation:self.bottomKeyframeAnimation forKey:@"bottom_animation"];
        _bottomShapeLayer.speed = 0.0f;
        
        [self.mainShapeLayer addSublayer:_bottomShapeLayer];
    }
    return _bottomShapeLayer;
}

- (CAShapeLayer *)lineShapeLayer
{
    if (!_lineShapeLayer)
    {
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        [tempPath moveToPoint:CGPointMake(kLayer_Width/2.0, 0)];
        [tempPath addLineToPoint:CGPointMake(kLayer_Width/2.0, kLayer_Height)];
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        self.lineShapeLayer = [CAShapeLayer layer];
        _lineShapeLayer.frame = CGRectMake(0, kLayer_Height, kLayer_Width, kLayer_Height);
        _lineShapeLayer.path = tempPath.CGPath;
        _lineShapeLayer.strokeColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
        _lineShapeLayer.lineWidth = 1.0f;
        _lineShapeLayer.lineJoin = kCALineJoinMiter;
        _lineShapeLayer.lineDashPhase = 3.0f;
        _lineShapeLayer.lineDashPattern = @[@(1),@(1)];
        _lineShapeLayer.strokeEnd = 0.0f;
        [_lineShapeLayer addAnimation:self.lineKeyframeAnimation forKey:@"line_animation"];
        _lineShapeLayer.speed = 0.0f;
        
        [self.mainShapeLayer addSublayer:_lineShapeLayer];
    }
    return _lineShapeLayer;
}

- (CAKeyframeAnimation *)mainKeyframeAnimation
{
    if (!_mainKeyframeAnimation)
    {
        self.mainKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        _mainKeyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :1.0f :0.8f :0.0f];
        _mainKeyframeAnimation.duration = 3.5;
        _mainKeyframeAnimation.repeatCount = CGFLOAT_MAX;
        _mainKeyframeAnimation.keyTimes = @[@0.8f, @1.0f];
        _mainKeyframeAnimation.values = @[@0.0f,@(M_PI)];
    }
    return _mainKeyframeAnimation;
}

- (CAKeyframeAnimation *)topKeyframeAnimation
{
    if (!_topKeyframeAnimation)
    {
        self.topKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _topKeyframeAnimation.duration = 3.5;
        _topKeyframeAnimation.repeatCount = CGFLOAT_MAX;
        _topKeyframeAnimation.keyTimes = @[@0.0f, @0.9f, @1.0f];
        _topKeyframeAnimation.values = @[@1.0f, @0.0f, @0.0f];
    }
    return _topKeyframeAnimation;
}

- (CAKeyframeAnimation *)bottomKeyframeAnimation
{
    if (!_bottomKeyframeAnimation)
    {
        self.bottomKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _bottomKeyframeAnimation.duration = 3.5;
        _bottomKeyframeAnimation.repeatCount = CGFLOAT_MAX;
        _bottomKeyframeAnimation.keyTimes = @[@0.1f, @0.9f, @1.0f];
        _bottomKeyframeAnimation.values = @[@0.0f, @1.0f, @1.0f];
    }
    return _bottomKeyframeAnimation;
}

- (CAKeyframeAnimation *)lineKeyframeAnimation
{
    if (!_lineKeyframeAnimation)
    {
        self.lineKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        _lineKeyframeAnimation.duration = 3.5;
        _lineKeyframeAnimation.repeatCount = CGFLOAT_MAX;
        _lineKeyframeAnimation.keyTimes = @[@0.0f, @0.1f, @0.9f, @1.0f];
        _lineKeyframeAnimation.values = @[@0.0f, @1.0f, @1.0f, @1.0f];
    }
    return _lineKeyframeAnimation;
}

#pragma mark - Public Method
- (void)startAnimation
{
    self.mainShapeLayer.speed =
    self.topShapeLayer.speed =
    self.bottomShapeLayer.speed =
    self.lineShapeLayer.speed = 1.0;
}

- (void)stopAnimation
{
    self.mainShapeLayer.speed =
    self.topShapeLayer.speed =
    self.bottomShapeLayer.speed =
    self.lineShapeLayer.speed = 0.0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
