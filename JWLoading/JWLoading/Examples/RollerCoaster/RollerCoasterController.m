//
//  RollerCoasterController.m
//  JWLoading
//
//  Created by wangjun on 2018/11/25.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "RollerCoasterController.h"

#import "JWLoading.h"

@interface RollerCoasterController ()

@end

@implementation RollerCoasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JWLoadingRollerCoaster *tempLoading = [JWLoadingRollerCoaster new];
    tempLoading.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100);
    tempLoading.backgroundColor = self.view.backgroundColor;
    tempLoading.stroke_color = [UIColor redColor];
    tempLoading.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0,
                                     CGRectGetHeight(self.view.frame) / 2.0);
//    tempLoading.layer.borderWidth = 1.0;
//    tempLoading.layer.borderColor = [UIColor blackColor].CGColor;
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
