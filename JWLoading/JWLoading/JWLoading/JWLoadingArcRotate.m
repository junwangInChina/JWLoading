//
//  JWLoadingArcRotate.m
//  JWLoading
//
//  Created by wangjun on 2018/9/30.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingArcRotate.h"

#import "JWLoadingDefine.h"

#define kInsideLayer_Width  25
#define kInsideLayer_Height 25

#define kOutsideLayer_Width  50
#define kOutsideLayer_Height 50

@interface JWLoadingArcRotate ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingArcRotate

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
        _mainShapeLayer.speed = 0.0;
        
        [self.layer addSublayer:_mainShapeLayer];
        
        [_mainShapeLayer addSublayer:[self layerWithSize:CGSizeMake(kOutsideLayer_Width, kOutsideLayer_Height)]];
        [_mainShapeLayer addSublayer:[self layerWithSize:CGSizeMake(kInsideLayer_Width, kInsideLayer_Height)]];
    }
    return _mainShapeLayer;
}

- (CALayer *)layerWithSize:(CGSize)size
{
    UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.frame = CGRectMake(0, 0, size.width, size.height);
    tempLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    tempLayer.position = CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)/2.0, CGRectGetHeight(self.mainShapeLayer.frame)/2.0);
    tempLayer.path = [self bezierPathWithSize:size].CGPath;

    tempLayer.lineWidth = 2.0;
    tempLayer.strokeColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
    tempLayer.fillColor = nil;
    [tempLayer addAnimation:[self animationGroupWithSize:size] forKey:@"animation_cycle"];
    
    return tempLayer;
}

- (UIBezierPath *)bezierPathWithSize:(CGSize)size
{
    CGFloat startFirstAngle = (size.width == kOutsideLayer_Width) ? -(M_PI_4*3) : (M_PI_4*3);
    CGFloat endFirstAngle = (size.width == kOutsideLayer_Width) ? -M_PI_4 : (M_PI_4*5);

    CGFloat startSecondAngle = (size.width == kOutsideLayer_Width) ? M_PI_4 : -M_PI_4;
    CGFloat endSecondAngle = (size.width == kOutsideLayer_Width) ? M_PI_4 * 3 : M_PI_4;
    
    CGPoint midPoint = CGPointMake(size.width/2.0 + size.width/2.0 * cos(M_PI_4),
                                   (size.width == kOutsideLayer_Width ? (size.height/2.0 + size.height/2.0 * sin(M_PI_4)) : (size.height/2.0 - size.height/2.0 * sin(M_PI_4))));
    
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath addArcWithCenter:CGPointMake(size.width/2.0, size.height/2.0)
                        radius:(MIN(size.width, size.height)/2.0)
                    startAngle:startFirstAngle
                      endAngle:endFirstAngle
                     clockwise:YES];
    [tempPath moveToPoint:midPoint];
    [tempPath addArcWithCenter:CGPointMake(size.width/2.0, size.height/2.0)
                        radius:(MIN(size.width, size.height)/2.0)
                    startAngle:startSecondAngle
                      endAngle:endSecondAngle
                     clockwise:YES];
    
    return tempPath;
}

- (CAAnimationGroup *)animationGroupWithSize:(CGSize)size
{
    CAKeyframeAnimation *tempSaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    tempSaleAnimation.keyTimes = @[@0, @0.5, @1.0];
    tempSaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 0.6f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    tempSaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAKeyframeAnimation *tempRotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    tempRotateAnimation.keyTimes = tempSaleAnimation.keyTimes;
    tempRotateAnimation.values = @[@0,
                                   @(size.width == kOutsideLayer_Width ? M_PI : -M_PI),
                                   @((size.width == kOutsideLayer_Width ? M_PI : -M_PI) * 2)];
    tempRotateAnimation.timingFunctions = tempSaleAnimation.timingFunctions;
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = size.width == kOutsideLayer_Width ? 1.0f : 0.5f;
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
