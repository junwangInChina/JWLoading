//
//  JWLoadingSkype.m
//  JWLoading
//
//  Created by wangjun on 2018/9/29.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingSkype.h"

#import "JWLoadingDefine.h"

#define kLayer_Width  10
#define kLAyer_Height 10
#define kMaxNum 5

@interface JWLoadingSkype ()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingSkype

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
        
        UIColor *tempColor = (self.backgroundColor == nil || self.backgroundColor == [UIColor clearColor]) ? self.superview.backgroundColor : self.backgroundColor;

        for (NSInteger i = 0; i < kMaxNum; i++)
        {
            CALayer *tempLayer = [CALayer layer];
            tempLayer.frame = CGRectMake(0, 0, kLayer_Width, kLAyer_Height);
            tempLayer.cornerRadius = CGRectGetMidX(tempLayer.frame);
            tempLayer.masksToBounds = YES;
            tempLayer.backgroundColor = (self.stroke_color && self.stroke_color != [UIColor clearColor]) ? self.stroke_color.CGColor : JWLoadingReverseColor(tempColor).CGColor;
            [tempLayer addAnimation:[self animationGroup:i] forKey:@"animation_group"];
            [_mainShapeLayer addSublayer:tempLayer];
        }
        
        [self.layer addSublayer:_mainShapeLayer];
    }
    return _mainShapeLayer;
}

- (UIBezierPath *)cycleBezierPath
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0)
                        radius:((MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) - kLayer_Width) / 2.0)
                    startAngle:-M_PI_2
                      endAngle:-M_PI_2 + 2 * M_PI
                     clockwise:YES];
    
    return tempPath;
}

- (CAAnimationGroup *)animationGroup:(NSInteger)index
{
    CGFloat tempOffset = (index + 1) * (1.0/(kMaxNum + 1));
    CAKeyframeAnimation *tempPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    tempPositionAnimation.duration = 1.5f;
    tempPositionAnimation.repeatCount = MAXFLOAT;
    tempPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :tempOffset :0.25f :1.0f];
    tempPositionAnimation.path = [self cycleBezierPath].CGPath;
    
    CABasicAnimation *tempSaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    tempSaleAnimation.duration = 1.5f;
    tempSaleAnimation.repeatCount = MAXFLOAT;
    tempSaleAnimation.fromValue = @(1-tempOffset);
    tempSaleAnimation.toValue = @(0.2+tempOffset);
    if(1-tempOffset > 0.2+tempOffset)
    {
        tempSaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    else
    {
        tempSaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    CAAnimationGroup *tempGroup = [CAAnimationGroup animation];
    tempGroup.duration = 1.5f;
    tempGroup.repeatCount = MAXFLOAT;
    tempGroup.animations = @[tempPositionAnimation,tempSaleAnimation];
    
    return tempGroup;
}

#pragma mark - Public Method
- (void)startAnimation
{
    self.mainShapeLayer.speed = 1.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
