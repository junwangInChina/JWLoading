//
//  JWLoadingWellPattern.m
//  JWLoading
//
//  Created by wangjun on 2018/11/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingWellPattern.h"

#define kWellPatternHeight 15

@interface JWLoadingWellPattern() <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) NSMutableArray *lineLayers;

@end

@implementation JWLoadingWellPattern

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 100, 100);
        self.animationDuration = 3;
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
        
        NSArray *tempStartPoints = @[@(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*2/3.0, CGRectGetHeight(_mainShapeLayer.frame)*1/6.0)),
                                     @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*5/6.0, CGRectGetHeight(_mainShapeLayer.frame)*2/3.0)),
                                     @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*1/3.0, CGRectGetHeight(_mainShapeLayer.frame)*5/6.0)),
                                     @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*1/6.0, CGRectGetHeight(_mainShapeLayer.frame)*1/3.0))];
        NSArray *tempEndPoints = @[@(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*2/3.0, CGRectGetHeight(_mainShapeLayer.frame)*5/6.0)),
                                   @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*1/6.0, CGRectGetHeight(_mainShapeLayer.frame)*2/3.0)),
                                   @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*1/3.0, CGRectGetHeight(_mainShapeLayer.frame)*1/6.0)),
                                   @(CGPointMake(CGRectGetWidth(_mainShapeLayer.frame)*5/6.0, CGRectGetHeight(_mainShapeLayer.frame)*1/3.0))];
        NSArray *tempColors = @[[UIColor colorWithRed:157.0/255.0 green:212.0/255.0 blue:233.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:245.0/255.0 green:189.0/255.0 blue:88.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:255.0/255.0 green:49.0/255.0 blue:126.0/255.0 alpha:1.0],
                                [UIColor colorWithRed:111.0/255.0 green:201.0/255.0 blue:181.0/255.0 alpha:1.0]];
        for (NSInteger i = 0; i < tempStartPoints.count; i++)
        {
            CGPoint tempStartPoint = [tempStartPoints[i] CGPointValue];
            CGPoint tempEndPoint = [tempEndPoints[i] CGPointValue];
            UIColor *tempColor = tempColors[i];
            
            CAShapeLayer *tempLineLayer = [self layerWithColor:tempColor
                                                         path:[self pathWithStart:tempStartPoint
                                                                              end:tempEndPoint]];
            
            [_mainShapeLayer addSublayer:tempLineLayer];
            [self.lineLayers addObject:tempLineLayer];
        }
    }
    return _mainShapeLayer;
}

- (NSMutableArray *)lineLayers
{
    if (!_lineLayers)
    {
        self.lineLayers = [NSMutableArray array];
    }
    return _lineLayers;
}

#pragma mark - Helper
- (CAShapeLayer *)layerWithColor:(UIColor *)color path:(UIBezierPath *)path
{
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.strokeColor = color.CGColor;
    tempLayer.path = path.CGPath;
    tempLayer.lineWidth = kWellPatternHeight;
    tempLayer.lineCap = kCALineCapRound;
    tempLayer.opacity = 0.8;
    
    return tempLayer;
}

- (UIBezierPath *)pathWithStart:(CGPoint)start end:(CGPoint)end
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:start];
    [tempPath addLineToPoint:end];
    
    return tempPath;
}

- (CABasicAnimation *)angleAnimation
{
    CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    tempAnimation.beginTime = CACurrentMediaTime();
    tempAnimation.fromValue = @(M_PI/6.0);
    tempAnimation.toValue = @(M_PI*6+M_PI/6.0);
    tempAnimation.fillMode = kCAFillModeForwards;
    tempAnimation.duration = self.animationDuration;
    tempAnimation.delegate = self;
    [tempAnimation setValue:@"Angle" forKey:@"BaseAnimation"];
    
    return tempAnimation;
}

- (CABasicAnimation *)lineShrinkAnimation
{
    CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tempAnimation.beginTime = CACurrentMediaTime();
    tempAnimation.duration = self.animationDuration/2.0;
    tempAnimation.fillMode = kCAFillModeForwards;
    tempAnimation.removedOnCompletion = NO;
    tempAnimation.fromValue = @(1);
    tempAnimation.toValue = @(0);
    
    return tempAnimation;
}

- (CABasicAnimation *)pointMoveXAnimation:(NSInteger)i
{
    CABasicAnimation *tempXAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    tempXAnimation.beginTime = CACurrentMediaTime() + self.animationDuration/2.0;
    tempXAnimation.duration = self.animationDuration/4.0;
    tempXAnimation.fillMode = kCAFillModeForwards;
    tempXAnimation.autoreverses = YES;
    tempXAnimation.fromValue = @(0);
    if (i == 0)
    {
        tempXAnimation.toValue = @(-CGRectGetWidth(self.mainShapeLayer.frame)/6.0);
    }
    else if (i == 1)
    {
        tempXAnimation.toValue = @(-(CGRectGetWidth(self.mainShapeLayer.frame)/2.0 - CGRectGetWidth(self.mainShapeLayer.frame)/6.0));
    }
    else if (i == 2)
    {
        tempXAnimation.toValue = @(CGRectGetWidth(self.mainShapeLayer.frame)/6.0);
    }
    else if (i == 3)
    {
        tempXAnimation.toValue = @((CGRectGetWidth(self.mainShapeLayer.frame)/2.0 - CGRectGetWidth(self.mainShapeLayer.frame)/6.0));
    }

    
    return tempXAnimation;
}

- (CABasicAnimation *)pointMoveYAnimation:(NSInteger)i
{
    CABasicAnimation *tempYAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    tempYAnimation.beginTime = CACurrentMediaTime() + self.animationDuration/2.0;
    tempYAnimation.duration = self.animationDuration/4.0;
    tempYAnimation.fillMode = kCAFillModeForwards;
    tempYAnimation.autoreverses = YES;
    tempYAnimation.fromValue = @(0);
    if (i == 0)
    {
        tempYAnimation.toValue = @((CGRectGetWidth(self.mainShapeLayer.frame)/2.0 - CGRectGetWidth(self.mainShapeLayer.frame)/6.0));
    }
    else if (i == 1)
    {
        tempYAnimation.toValue = @(-CGRectGetWidth(self.mainShapeLayer.frame)/6.0);
    }
    else if (i == 2)
    {
        tempYAnimation.toValue = @(-(CGRectGetWidth(self.mainShapeLayer.frame)/2.0 - CGRectGetWidth(self.mainShapeLayer.frame)/6.0));
    }
    else if (i == 3)
    {
        tempYAnimation.toValue = @(CGRectGetWidth(self.mainShapeLayer.frame)/6.0);
    }
    
    return tempYAnimation;
}

- (CABasicAnimation *)lineStretchAnimation
{
    CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tempAnimation.beginTime = CACurrentMediaTime() + self.animationDuration;
    tempAnimation.duration = self.animationDuration/4.0;
    tempAnimation.fillMode = kCAFillModeForwards;
    tempAnimation.removedOnCompletion = NO;
    tempAnimation.fromValue = @(0);
    tempAnimation.toValue = @(1);

    return tempAnimation;
}

- (void)clearAnimation
{
    [self.layer removeAllAnimations];
    
    [self.mainShapeLayer removeAllAnimations];
    
    for (CAShapeLayer *tempLayer in self.lineLayers)
    {
        [tempLayer removeAllAnimations];
    }
}

- (void)animationBeginRun
{
    [self.mainShapeLayer addAnimation:[self angleAnimation] forKey:@""];
    for (NSInteger i = 0; i < self.lineLayers.count; i++)
    {
        CAShapeLayer *tempLayer = self.lineLayers[i];
        
        [tempLayer addAnimation:[self lineShrinkAnimation] forKey:@""];
        [tempLayer addAnimation:[self pointMoveXAnimation:i] forKey:@""];
        [tempLayer addAnimation:[self pointMoveYAnimation:i] forKey:@""];
        [tempLayer addAnimation:[self lineStretchAnimation] forKey:@""];
    }
}

#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        CABasicAnimation *tempAnimation = (CABasicAnimation *)anim;
        if ([[tempAnimation valueForKey:@"BaseAnimation"] isEqualToString:@"Angle"])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration/4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startAnimation];
            });
        }
    }
}

#pragma mark - Public Method
- (void)startAnimation
{
    [self clearAnimation];

    [self animationBeginRun];
    
    self.mainShapeLayer.speed = 1.0;
}

- (void)stopAnimation
{
    [self clearAnimation];

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
