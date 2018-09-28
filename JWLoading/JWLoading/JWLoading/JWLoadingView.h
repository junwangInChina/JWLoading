//
//  JWLoadingView.h
//  JWLoading
//
//  Created by wangjun on 2018/9/28.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 基本类
 */
@interface JWLoadingView : UIView

@property (nonatomic, strong) UIColor *stroke_color;

- (void)startAnimation;

@end
