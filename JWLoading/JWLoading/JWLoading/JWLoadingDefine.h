//
//  JWLoadingDefine.h
//  JWLoading
//
//  Created by wangjun on 2018/9/27.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_INLINE UIColor *JWLoadingReverseColor(UIColor *color)
{
    UIColor *tempColor = (color && color != [UIColor clearColor]) ? color : [UIColor whiteColor];

    const CGFloat *componentColors = CGColorGetComponents(tempColor.CGColor);    
    
    CGFloat r = componentColors[0];
    
    CGFloat g = componentColors[1];
    if (CGColorSpaceGetModel(CGColorGetColorSpace(tempColor.CGColor)) == kCGColorSpaceModelMonochrome)
    {
        g = componentColors[0];
    }
    
    CGFloat b = componentColors[2];
    if (CGColorSpaceGetModel(CGColorGetColorSpace(tempColor.CGColor)) == kCGColorSpaceModelMonochrome)
    {
        b = componentColors[0];
    }
    
    CGFloat a = componentColors[CGColorGetNumberOfComponents(tempColor.CGColor) - 1];
    
    UIColor *convertedColor = [UIColor colorWithRed:(1- r) green:(1 - g) blue:(1 - b) alpha:a];
    
    return convertedColor;

}
