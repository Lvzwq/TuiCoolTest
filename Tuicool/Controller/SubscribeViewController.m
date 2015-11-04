//
//  SubscribeViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/2.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SubscribeViewController.h"
#import "AFNetworking.h"
#import "ItemTableViewController.h"

@interface SubscribeViewController()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *listNavi;

@property(nonatomic, strong) UITableView *navTableView;

@property(nonatomic, strong) NSMutableArray *listItems;

@property(nonatomic, strong) ItemTableViewController *itemTableViewController;

@end

@implementation SubscribeViewController

- (void)viewDidLoad{
    self.navTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 88 , DeviceHeight)];
    self.navTableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.navTableView];
    self.navTableView.delegate = self;
    self.navTableView.dataSource = self;
    
    self.navTableView.showsVerticalScrollIndicator = NO;
    self.itemTableViewController = [[ItemTableViewController alloc] init];
    self.itemTableViewController.view.frame = CGRectMake(88, 64, DeviceHeight - 88, DeviceHeight);
    self.itemTableViewController.navVC = self;
    [self.view addSubview:self.itemTableViewController.tableView];
    [self loadData:0];
}

- (void) setListNavi:(NSMutableArray *)listNavi{
    _listNavi = listNavi;
    [self.navTableView reloadData];
}

- (void)loadData: (NSUInteger) navId{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@", [[UIDevice currentDevice] name]];
    userAgent = [userAgent stringByAppendingPathComponent:@"2.13.1"];
    NSLog(@"user-agent = %@", userAgent);
    
    [sessionManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [sessionManager.requestSerializer setValue:@"Basic MC4wLjAuMDp0dWljb29s" forHTTPHeaderField:@"Authorization"];
    NSDictionary *param = @{@"cid": [NSNumber numberWithInteger:navId]};
    [sessionManager GET:@"http://api.tuicool.com/api/sites/hot.json"
             parameters:param
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
                    NSDictionary *resp = (NSDictionary *)responseObject;
                    self.itemTableViewController.listData = [NSMutableArray arrayWithArray:[resp objectForKey:@"items"]];
                    if (navId == 0) {
                        self.listNavi = [resp objectForKey:@"navi"];
                    }
    }
                failure:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
                    NSLog(@"error= %@", responseObject);
    }];
    
     
    
}

#pragma mark --UITableViewDataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listNavi count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"navListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    NSInteger row = indexPath.row;
    NSDictionary *item = [self.listNavi objectAtIndex:row];
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSDictionary *siteInfo = [self.listNavi objectAtIndex:row];
    [self loadData:[[siteInfo objectForKey:@"id"] intValue]];
   
}


@end
