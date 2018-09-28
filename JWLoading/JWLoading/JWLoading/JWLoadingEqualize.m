//
//  JWLoadingEqualize.m
//  JWLoading
//
//  Created by wangjun on 2018/9/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingEqualize.h"

#import "JWLoadingDefine.h"

#define kLayer_Width  20
#define kLayer_Height 50

@interface JWLoadingEqualize ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@property (nonatomic, strong) UIBezierPath *originBezierPath;
@property (nonatomic, strong) UIBezierPath *endBezierPath;

@end

@implementation JWLoadingEqualize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 100, 50);
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
        _mainShapeLayer.frame = CGRectMake(0, 0, 100, 50);
        _mainShapeLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        _mainShapeLayer.speed = 0.0f;
        [self.layer addSublayer:_mainShapeLayer];
        
        NSArray *tempColors = @[@"0B486B",
                                @"3B8686",
                                @"79BD9A",
                                @"A8DBA8",
                                @"CFF09E"];
        for (NSInteger i = 0; i < tempColors.count; i++)
        {
            CAShapeLayer *tempLayer = [CAShapeLayer layer];
            tempLayer.frame = CGRectMake(i*kLayer_Width, 0, kLayer_Width, kLayer_Height);
            tempLayer.path = self.originBezierPath.CGPath;
            tempLayer.fillColor = JWLoadingColor(tempColors[i]).CGColor;
            [tempLayer addAnimation:[self basicAnimation:(i/10.0)]
                             forKey:[NSString stringWithFormat:@"animation_%@",tempColors[i]]];
            [_mainShapeLayer addSublayer:tempLayer];
        }
    }
    return _mainShapeLayer;
}

- (UIBezierPath *)originBezierPath
{
    if (!_originBezierPath)
    {
        self.originBezierPath = [UIBezierPath bezierPath];
        [_originBezierPath moveToPoint:CGPointMake(0, kLayer_Height)];
        [_originBezierPath addLineToPoint:CGPointMake(kLayer_Width/2.0, kLayer_Height-2)];
        [_originBezierPath addLineToPoint:CGPointMake(kLayer_Width, kLayer_Height)];
        [_originBezierPath addLineToPoint:CGPointMake(0, kLayer_Height)];
        [_originBezierPath closePath];
    }
    return _originBezierPath;
}

- (UIBezierPath *)endBezierPath
{
    if (!_endBezierPath)
    {
        self.endBezierPath = [UIBezierPath bezierPath];
        [_endBezierPath moveToPoint:CGPointMake(0, kLayer_Height)];
        [_endBezierPath addLineToPoint:CGPointMake(kLayer_Width/2.0, 0)];
        [_endBezierPath addLineToPoint:CGPointMake(kLayer_Width, kLayer_Height)];
        [_endBezierPath closePath];
    }
    return _endBezierPath;
}

#pragma mark - Helper
- (CABasicAnimation *)basicAnimation:(CGFloat)begin
{
    CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    tempAnimation.fromValue = (id)self.originBezierPath.CGPath;
    tempAnimation.toValue = (id)self.endBezierPath.CGPath;
    tempAnimation.autoreverses = YES;
    tempAnimation.duration = 0.5f;
    tempAnimation.beginTime = begin;
    tempAnimation.repeatCount = MAXFLOAT;
    tempAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.77 :0 :0.175 :1];
    
    return tempAnimation;
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
