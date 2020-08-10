//
//  JWLoadingMusic.m
//  JWLoading
//
//  Created by wangjun on 2018/9/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "JWLoadingMusic.h"

#import "JWLoadingDefine.h"

#define kLayer_Width  8
#define kLayer_Height 100
#define kLayer_Margin 10

@interface JWLoadingMusic()

@property (nonatomic, strong) CAShapeLayer *mainShapeLayer;

@end

@implementation JWLoadingMusic

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, JWLOADING_SCREEN_WIDTH, kLayer_Height);
        self.loading_height = kLayer_Height;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat tempWidth = frame.size.width;
    CGFloat tempHeight = frame.size.height;
    if (tempWidth <= JWLOADING_SCREEN_WIDTH)
    {
        tempWidth = JWLOADING_SCREEN_WIDTH;
    }
    if (tempHeight <= self.loading_height)
    {
        tempHeight = self.loading_height;
    }
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, tempWidth, tempHeight)];
}

#pragma mark - Lazy loading
- (CAShapeLayer *)mainShapeLayer
{
    if (!_mainShapeLayer)
    {
        self.mainShapeLayer = [CAShapeLayer layer];
        _mainShapeLayer.frame = CGRectMake(0, 0, JWLOADING_SCREEN_WIDTH, self.loading_height);
        _mainShapeLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        _mainShapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        _mainShapeLayer.speed = 0.0f;
        
        NSArray *tempColors = @[@"0B486B",
                                @"3B8686",
                                @"79BD9A",
                                @"A8DBA8",
                                @"CFF09E",
                                @"ff0000",
                                @"ff8901",
                                @"00ff00",
                                @"A8DBA8",
                                @"CFF09E"];
        CGFloat tempX = (JWLOADING_SCREEN_WIDTH - (tempColors.count * kLayer_Width + (tempColors.count - 1) * kLayer_Margin)) / 2.0;
        
        for (NSInteger i = 0; i < tempColors.count; i++)
        {
            CGFloat tempY = (arc4random() % self.loading_height) + 30;
            CGFloat tempDuration = ((arc4random() % 100) + 50) / 100.0;
            
            CAShapeLayer *tempLayer = [CAShapeLayer layer];
            tempLayer.frame = CGRectMake(tempX + i * (kLayer_Width + kLayer_Margin), -(self.loading_height/2.0), kLayer_Width, self.loading_height);
            tempLayer.path = [self beziPath:tempY].CGPath;
            tempLayer.strokeColor = JWLoadingColor(tempColors[i]).CGColor;
            tempLayer.lineWidth = kLayer_Width;
            tempLayer.lineCap = kCALineCapRound;
            tempLayer.anchorPoint = CGPointMake(0.5f, 0);
            tempLayer.strokeEnd = 0;
            [tempLayer addAnimation:[self animation:tempDuration] forKey:@"animation"];
            
            [_mainShapeLayer addSublayer:tempLayer];
        }
        
        [self.layer addSublayer:_mainShapeLayer];
    }
    return _mainShapeLayer;
}

- (UIBezierPath *)beziPath:(CGFloat)y
{
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(0, self.loading_height)];
    [tempPath addLineToPoint:CGPointMake(0, self.loading_height-y)];
    
    return tempPath;
}

- (CAKeyframeAnimation *)animation:(CGFloat)duration
{
    CAKeyframeAnimation *tempAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    tempAnimation.duration = duration;
    tempAnimation.repeatCount = MAXFLOAT;
    tempAnimation.keyTimes = @[@0.1, @0.5, @0.75, @0.9, @1.0];
    tempAnimation.values = @[@1.0, @0.1, @0.3, @0.7, @1.0];
    
    return tempAnimation;
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
