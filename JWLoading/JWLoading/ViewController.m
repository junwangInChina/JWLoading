//
//  ViewController.m
//  JWLoading
//
//  Created by wangjun on 2018/9/26.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "ViewController.h"

static NSString *kLoadingCell = @"ViewControllerTableViewCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *loadingTableView;
@property (nonatomic, strong) NSMutableArray *loadingArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Loading...";
    
    [self.loadingArray addObjectsFromArray:@[@{@"title":@"手写Loading",@"className":@"HandwritingAnimationController"},
                                             @{@"title":@"沙漏",@"className":@"HourglassAnimationController"},
                                             @{@"title":@"等效跳跃",@"className":@"EqualizeAnimationController"},
                                             @{@"title":@"旋转点",@"className":@"RotateDotGlowController"},
                                             @{@"title":@"音符律动",@"className":@"MusicAnimationController"},
                                             @{@"title":@"Skype",@"className":@"SkypeAnimationController"},
                                             @{@"title":@"小球旋转脉冲",@"className":@"BallRotatePulseController"},
                                             @{@"title":@"圆弧旋转",@"className":@"ArcRotateAnimationController"},
                                             @{@"title":@"旋转的小点",@"className":@"DotRotateAnimationController"}]];
    [self.loadingTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy loading
- (UITableView *)loadingTableView
{
    if (!_loadingTableView)
    {
        self.loadingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _loadingTableView.delegate = self;
        _loadingTableView.dataSource = self;
        [_loadingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLoadingCell];
        _loadingTableView.tableFooterView = [UIView new];
        [self.view addSubview:_loadingTableView];
    }
    return _loadingTableView;
}

- (NSMutableArray *)loadingArray
{
    if (!_loadingArray)
    {
        self.loadingArray = [NSMutableArray array];
    }
    return _loadingArray;
}

#pragma mark - UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadingArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoadingCell forIndexPath:indexPath];
    
    if (self.loadingArray.count > indexPath.row)
    {
        cell.textLabel.text = self.loadingArray[indexPath.row][@"title"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.loadingArray.count <= indexPath.row) return;
    
    Class tempClass = NSClassFromString(self.loadingArray[indexPath.row][@"className"]);
    UIViewController *tempController = [[tempClass alloc] init];
    tempController.title = self.loadingArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:tempController animated:YES];
}

@end
