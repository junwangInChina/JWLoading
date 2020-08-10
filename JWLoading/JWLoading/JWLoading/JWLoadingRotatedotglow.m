//
//  JWLoadingRotatedotglow.m
//  JWLoading
//
//  Created by wangjun on 2018/9/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingRotatedotglow.h"

#import "JWLoadingDefine.h"

@interface JWLoadingRotatedotglow()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingRotatedotglow

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
        _mainShapeLayer.frame = CGRectMake(0, 0, 50, 50);
        _mainShapeLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        [_mainShapeLayer addAnimation:[self basicAnimation] forKey:@"animation_basic"];
        _mainShapeLayer.speed = 0.0f;
        [self.layer addSublayer:_mainShapeLayer];
        
        NSArray *tempXs = @[@15,@0,@30.5]; // @[@-10,@40,@40,@-10];
        NSArray *tempYs = @[@0,@29.5,@29.5]; // @[@-10,@-10,@40,@40];
        UIColor *tempColor = [UIColor colorWithRed:230.0f/255.0f
                                             green:126.0f/255.0f
                                              blue:34.0f/255.0f
                                             alpha:1.0f];
        NSArray *tempColors = @[@[@"79BD9A",@"A8DBA8",@"79BD9A"],
                                @[@"CFF09E",@"79BD9A",@"CFF09E"],
                                @[@"A8DBA8",@"CFF09E",@"A8DBA8"]];
        for (NSInteger i = 0; i < tempXs.count; i++)
        {
            CALayer *tempLayer = [CALayer layer];
            tempLayer.frame = CGRectMake([tempXs[i] floatValue], [tempYs[i] floatValue], 20, 20);
            tempLayer.backgroundColor = tempColor.CGColor;
            tempLayer.cornerRadius = 10;;
            tempLayer.shadowColor = tempColor.CGColor;
            tempLayer.shadowOpacity = 1;
            tempLayer.shadowOffset = CGSizeMake(0, 0);
            tempLayer.shadowRadius = 15;
            [tempLayer addAnimation:[self groupAnimation:tempColors[i]] forKey:@"animation_dot"];
            
            [_mainShapeLayer addSublayer:tempLayer];
        }
    }
    return _mainShapeLayer;
}

#pragma mark - Helper
- (CABasicAnimation *)basicAnimation
{
    CABasicAnimation *tempAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    tempAnimation.duration = 1.5f;
    tempAnimation.repeatCount = MAXFLOAT;
    tempAnimation.fromValue = @(0);
    tempAnimation.toValue = @(M_PI*2);
    
    return tempAnimation;
}

- (CAAnimationGroup *)groupAnimation:(NSArray *)colors
{
    CAKeyframeAnimation *tempShadowRadiusAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowRadius"];
    tempShadowRadiusAnimation.duration = 1.5f;
    tempShadowRadiusAnimation.repeatCount = MAXFLOAT;
    tempShadowRadiusAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    tempShadowRadiusAnimation.values = @[@5.0, @20.0, @5.0];
    
    CAKeyframeAnimation *tempShaowColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowColor"];
    tempShaowColorAnimation.duration = 1.5f;
    tempShaowColorAnimation.repeatCount = MAXFLOAT;
    tempShaowColorAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    tempShaowColorAnimation.values = @[(id)JWLoadingColor(colors[0]).CGColor,
                                       (id)JWLoadingColor(colors[1]).CGColor,
                                       (id)JWLoadingColor(colors[2]).CGColor];
    
    CAKeyframeAnimation *tempBgColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    tempBgColorAnimation.duration = 1.5f;
    tempBgColorAnimation.repeatCount = MAXFLOAT;
    tempBgColorAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    tempBgColorAnimation.values = @[(id)JWLoadingColor(colors[0]).CGColor,
                                    (id)JWLoadingColor(colors[1]).CGColor,
                                    (id)JWLoadingColor(colors[2]).CGColor];
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = 1.5f;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    tempGroup.animations = @[tempShaowColorAnimation, tempShadowRadiusAnimation, tempBgColorAnimation];
    
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
