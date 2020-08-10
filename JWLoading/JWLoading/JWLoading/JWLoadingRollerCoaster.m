//
//  JWLoadingRollerCoaster.m
//  JWLoading
//
//  Created by wangjun on 2018/11/25.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingRollerCoaster.h"

#import "JWLoadingDefine.h"

#define JWRollerCoaster_Width_Then_Height   2

@interface JWLoadingRollerCoaster ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingRollerCoaster

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 300, 150);
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat tempWidth = frame.size.width;
    CGFloat tempHeight = frame.size.height;
    if (tempWidth < tempHeight)
    {
        tempWidth = frame.size.height;
        tempHeight = frame.size.width;
    }
    if (tempWidth <= 300)
    {
        tempWidth = 300;
    }
    if (tempWidth > JWLOADING_SCREEN_WIDTH)
    {
        tempWidth = JWLOADING_SCREEN_WIDTH;
    }
    tempHeight = tempWidth / JWRollerCoaster_Width_Then_Height;
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
        _mainShapeLayer.masksToBounds = YES;
        
        [self.layer addSublayer:_mainShapeLayer];
        
        
        // 渐变背景
        CAGradientLayer *tempBgLayer = [CAGradientLayer layer];
        tempBgLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_mainShapeLayer.frame), CGRectGetHeight(_mainShapeLayer.frame));
        UIColor *lightColor = [UIColor colorWithRed:178.0/255.0 green:226.0/255.0 blue:248.0/255.0 alpha:1.0];
        UIColor *darkColor = [UIColor colorWithRed:232.0/255.0 green:244.0/255.0 blue:193.0/255.0 alpha:1.0];
        tempBgLayer.colors = @[(__bridge id)lightColor.CGColor, (__bridge id)darkColor.CGColor];
        tempBgLayer.startPoint = CGPointMake(0, 0);
        tempBgLayer.endPoint = CGPointMake(1, 1);
        [_mainShapeLayer addSublayer:tempBgLayer];
        
        // 山体
        CAShapeLayer *tempLaftMountainLayer = [self leftSnowMountainLayer];
        [_mainShapeLayer addSublayer:tempLaftMountainLayer];
        
        CAShapeLayer *tempRightMountainLayer = [self rightSnowMountainLayer];
        [_mainShapeLayer insertSublayer:tempRightMountainLayer above:tempLaftMountainLayer];
        
        // 草地
        CAShapeLayer *tempLeftLawnLayer = [self lawnLayerWithPath:[self leftLawnPath]
                                                             fill:[UIColor colorWithRed:82.0/255.0 green:177.0/255.0 blue:44.0/255.0 alpha:1.0]];
        [_mainShapeLayer addSublayer:tempLeftLawnLayer];
        
        CAShapeLayer *tempRightLawnLayer = [self lawnLayerWithPath:[self rightLawnPath]
                                                              fill:[UIColor colorWithRed:92.0/255.0 green:195.0/255.0 blue:52.0/255.0 alpha:1.0]];
        [_mainShapeLayer insertSublayer:tempRightLawnLayer above:tempLeftLawnLayer];
        
        // 黄色轨道
        CAShapeLayer *tempYellowTrackLayer = [self trackLayerWithPath:[self yellowTrackPath]
                                                               stroke:[UIColor colorWithRed:210.0/255.0 green:179.0/255.0 blue:54.0/255.0 alpha:1.0]
                                                                 fill:[UIColor colorWithPatternImage:[UIImage imageNamed:JWLOADING_IMAGE_NAME(@"track_yellow@3x")]]];
        [_mainShapeLayer addSublayer:tempYellowTrackLayer];
        
        
        CFTimeInterval tempYellowTime = CACurrentMediaTime();
        for (NSInteger i = 0; i < 5; i++)
        {
            // 黄色动画
            [self animationWithCar:JWLOADING_IMAGE_NAME(@"car_up@3x")
                        superLayer:tempYellowTrackLayer
                          duration:5
                             begin:tempYellowTime+0.07*(i*10/10.0)];
        }
        
        
        // 绿色轨道
        CAShapeLayer *tempGreenTrackLayer = [self trackLayerWithPath:[self greenTrackPath]
                                                              stroke:[UIColor colorWithRed:0.0/255.0 green:147.0/255.0 blue:163.0/255.0 alpha:1.0]
                                                                fill:[UIColor colorWithPatternImage:[UIImage imageNamed:JWLOADING_IMAGE_NAME(@"track_green@3x")]]];
        [_mainShapeLayer insertSublayer:tempGreenTrackLayer above:tempYellowTrackLayer];
        
        CFTimeInterval tempGreenTime = CACurrentMediaTime();
        for (NSInteger i = 0; i < 5; i++)
        {
            // 绿色动画
            [self animationWithCar:JWLOADING_IMAGE_NAME(@"car_down@3x")
                        superLayer:tempGreenTrackLayer
                          duration:5
                             begin:tempGreenTime+0.075*(i*10/10.0)];
        }
        
        
        // 白云
        CALayer *tempCloudLayer = [self cloudLayer];
        [_mainShapeLayer addSublayer:tempCloudLayer];
    }
    return _mainShapeLayer;
}

#pragma mark - Helper
- (CAShapeLayer *)leftSnowMountainLayer
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(0,
                                      CGRectGetHeight(self.mainShapeLayer.frame)*0.8)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.15,
                                         CGRectGetHeight(self.mainShapeLayer.frame)*0.3)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.4,
                                         CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempPath addLineToPoint:CGPointMake(0,
                                         CGRectGetHeight(self.mainShapeLayer.frame))];
    
    UIBezierPath *tempCoverPath = [UIBezierPath bezierPath];
    [tempCoverPath moveToPoint:CGPointMake(0,
                                           CGRectGetHeight(self.mainShapeLayer.frame)*0.8)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.1,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.47)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.12,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.5)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.14,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.45)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.16,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.53)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.18,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.45)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.21,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.47)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.4,
                                              CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempCoverPath addLineToPoint:CGPointMake(0,
                                              CGRectGetHeight(self.mainShapeLayer.frame))];
    
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.path = tempPath.CGPath;
    tempLayer.fillColor = [UIColor whiteColor].CGColor;
    
    CAShapeLayer *tempCoverLayer = [CAShapeLayer layer];
    tempCoverLayer.path = tempCoverPath.CGPath;
    tempCoverLayer.fillColor = [UIColor colorWithRed:104.0/255.0 green:92.0/255.0 blue:157.0/255.0 alpha:1.0].CGColor;
    [tempLayer addSublayer:tempCoverLayer];
    
    return tempLayer;
}

- (CAShapeLayer *)rightSnowMountainLayer
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.25,
                                      CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.45,
                                         CGRectGetHeight(self.mainShapeLayer.frame)*0.55)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.65,
                                         CGRectGetHeight(self.mainShapeLayer.frame))];
    
    UIBezierPath *tempCoverPath = [UIBezierPath bezierPath];
    [tempCoverPath moveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.25,
                                           CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.4,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.6625)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.42,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.69)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.44,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.65)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.46,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.68)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.475,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.64)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.5,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.6625)];
    [tempCoverPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.65,
                                              CGRectGetHeight(self.mainShapeLayer.frame))];
    
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.path = tempPath.CGPath;
    tempLayer.fillColor = [UIColor whiteColor].CGColor;
    
    CAShapeLayer *tempCoverLayer = [CAShapeLayer layer];
    tempCoverLayer.path = tempCoverPath.CGPath;
    tempCoverLayer.fillColor = [UIColor colorWithRed:75.0/255.0 green:65.0/255.0 blue:111.0/255.0 alpha:1.0].CGColor;
    [tempLayer addSublayer:tempCoverLayer];
    
    return tempLayer;
}

- (CAShapeLayer *)lawnLayerWithPath:(UIBezierPath *)path fill:(UIColor *)fill
{
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.path = path.CGPath;
    tempLayer.fillColor = fill.CGColor;
    
    return tempLayer;
}

- (CAShapeLayer *)trackLayerWithPath:(UIBezierPath *)path stroke:(UIColor *)stroke fill:(UIColor *)fill
{
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.lineWidth = 5;
    tempLayer.strokeColor = stroke.CGColor;
    tempLayer.path = path.CGPath;
    tempLayer.fillColor = fill.CGColor;
    
    CAShapeLayer *tempLineLayer = [CAShapeLayer layer];
    tempLineLayer.lineCap = kCALineCapRound;
    tempLineLayer.strokeColor = [UIColor whiteColor].CGColor;
    tempLineLayer.lineDashPattern = @[@1.0, @6.0];
    tempLineLayer.lineWidth = 2.5;
    tempLineLayer.fillColor = [UIColor clearColor].CGColor;
    tempLineLayer.path = path.CGPath;
    [tempLayer addSublayer:tempLineLayer];
    
    return tempLayer;
}

- (CAKeyframeAnimation *)animationWithCar:(NSString *)car
                               superLayer:(CAShapeLayer *)superLayer
                                 duration:(CFTimeInterval)duration
                                    begin:(CFTimeInterval)begin
{
    CALayer *tempCarLayer = [CALayer layer];
    tempCarLayer.frame = CGRectMake(-20, -10, 11, 7);
    tempCarLayer.contents = (__bridge id _Nullable)[UIImage imageNamed:car].CGImage;
    
    CAKeyframeAnimation *tempAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    tempAnimation.path = superLayer.path;
    tempAnimation.duration = duration;
    tempAnimation.beginTime = begin;
    tempAnimation.autoreverses = NO;
    tempAnimation.repeatCount = CGFLOAT_MAX;
    tempAnimation.calculationMode = kCAAnimationPaced;
    tempAnimation.rotationMode = kCAAnimationRotateAuto;
    tempAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [superLayer addSublayer:tempCarLayer];
    [tempCarLayer addAnimation:tempAnimation forKey:@""];
    
    return tempAnimation;
}

- (UIBezierPath *)leftLawnPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempPath addLineToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame)*0.8)];
    [tempPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)/3.0,
                                              CGRectGetHeight(self.mainShapeLayer.frame))
                     controlPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)/5.0,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.8)];
    
    return tempPath;
}

- (UIBezierPath *)rightLawnPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame),
                                              CGRectGetHeight(self.mainShapeLayer.frame) * 0.8)
                     controlPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)/2.0,
                                              CGRectGetHeight(self.mainShapeLayer.frame) * 0.7)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame), CGRectGetHeight(self.mainShapeLayer.frame))];
    
    return tempPath;
}

- (UIBezierPath *)yellowTrackPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame) * 0.9)];
    [tempPath addCurveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) * 0.6, CGRectGetHeight(self.mainShapeLayer.frame)*0.5)
                controlPoint1:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) / 6.0, CGRectGetHeight(self.mainShapeLayer.frame)*0.5)
                controlPoint2:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) / 4.0, CGRectGetHeight(self.mainShapeLayer.frame)*1.2)];
    [tempPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) * 1.0,
                                              CGRectGetHeight(self.mainShapeLayer.frame)/3.0)
                     controlPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.85,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.0)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) + 10, CGRectGetHeight(self.mainShapeLayer.frame)/3.0)];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame) + 10, CGRectGetHeight(self.mainShapeLayer.frame) + 10)];
    [tempPath addLineToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame)+10)];
    [tempPath addLineToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame))];
    
    return tempPath;
}

- (UIBezierPath *)greenTrackPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    // 起始点
    [tempPath moveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)+10, CGRectGetHeight(self.mainShapeLayer.frame))];
    [tempPath addLineToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame), CGRectGetHeight(self.mainShapeLayer.frame)*0.85)];
    // 二次曲线
    [tempPath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.7,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.8)
                     controlPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.8,
                                              CGRectGetHeight(self.mainShapeLayer.frame)*0.7)];
    // 圆
    [tempPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.7-sin(M_PI_4)*CGRectGetWidth(self.mainShapeLayer.frame)*0.15,
                                           CGRectGetHeight(self.mainShapeLayer.frame)*0.8-cos(M_PI_4)*CGRectGetWidth(self.mainShapeLayer.frame)*0.15)
                        radius:CGRectGetWidth(self.mainShapeLayer.frame)*0.15
                    startAngle:M_PI_4
                      endAngle:(M_PI_4 + M_PI * 2)
                     clockwise:YES];
    // 三次曲线
    [tempPath addCurveToPoint:CGPointMake(0, CGRectGetHeight(self.mainShapeLayer.frame)*0.7)
                controlPoint1:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.5, CGRectGetHeight(self.mainShapeLayer.frame)*1.2)
                controlPoint2:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)*0.2, CGRectGetHeight(self.mainShapeLayer.frame)*0.1)];
    // 封口
    [tempPath addLineToPoint:CGPointMake(-10, CGRectGetHeight(self.mainShapeLayer.frame))];
    
    
    return tempPath;
}

- (CALayer *)cloudLayer
{
    CALayer *tempLayer = [CALayer layer];
    tempLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:JWLOADING_IMAGE_NAME(@"cloud_white@3x")].CGImage);
    tempLayer.frame = CGRectMake(0, 0, 42, 13);

    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(CGRectGetWidth(self.mainShapeLayer.frame)+CGRectGetWidth(tempLayer.frame),
                                      CGRectGetHeight(self.mainShapeLayer.frame)*0.1)];
    [tempPath addLineToPoint:CGPointMake(-CGRectGetWidth(tempLayer.frame),
                                         CGRectGetHeight(self.mainShapeLayer.frame)*0.1)];
    
    CAKeyframeAnimation *tempAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    tempAnimation.path = tempPath.CGPath;
    tempAnimation.duration = 30;
    tempAnimation.autoreverses = YES;
    tempAnimation.repeatCount = CGFLOAT_MAX;
    tempAnimation.calculationMode = kCAAnimationPaced;
    [tempLayer addAnimation:tempAnimation forKey:@""];
    
    return tempLayer;
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
