//
//  ArcRotateAnimationController.m
//  JWLoading
//
//  Created by wangjun on 2018/9/30.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "ArcRotateAnimationController.h"

#import "JWLoading.h"

@interface ArcRotateAnimationController ()

@end

@implementation ArcRotateAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JWLoadingArcRotate *tempLoading = [JWLoadingArcRotate new];
    tempLoading.backgroundColor = self.view.backgroundColor;
    tempLoading.stroke_color = [UIColor redColor];
    tempLoading.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0,
                                     CGRectGetHeight(self.view.frame) / 2.0);
    [self.view addSubview:tempLoading];
    [tempLoading startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
