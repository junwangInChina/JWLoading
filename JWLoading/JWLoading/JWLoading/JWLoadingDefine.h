//
//  JWLoadingDefine.h
//  JWLoading
//
//  Created by wangjun on 2018/9/27.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JWLOADING_SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define JWLOADING_SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

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

NS_INLINE UIColor *JWLoadingColor(NSString *hex)
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3)
    {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6)
    {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
