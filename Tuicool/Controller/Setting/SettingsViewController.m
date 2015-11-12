//
//  SettingsViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingLoginCell.h"
#import "StorageService.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"



@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray *setting;
@end

@implementation SettingsViewController
@synthesize listView;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    self.setting = [[NSArray alloc] initWithContentsOfFile:path];
    
    
    self.listView = [[UITableView alloc] init];
    CGFloat tableHeight = DeviceHeight - 49;
    self.listView.frame = CGRectMake(0, 0, DeviceWidth, tableHeight);
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.view addSubview: self.listView];
    self.navigationItem.title = @"我的";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"SettingCell";
    if (indexPath.section == 0) {
        SettingLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[SettingLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        StorageService *service = [StorageService shareInstance];
        //已经登录
        if ([service hasLogin]) {
            AccountModel *user = [service getUserInfo];
            NSLog(@"user = %@", user);
            cell.nickName.text = user.name;
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:user.profile] placeholderImage:[UIImage imageNamed:@"user_default"]];
        }
        return cell;
    }else if (indexPath.section == 1){
        NSArray *sectionTwo = [self.setting objectAtIndex:0];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        NSDictionary *row = [sectionTwo objectAtIndex:indexPath.row];
        cell.textLabel.text = [row objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else{
        NSArray *sectionTwo = [self.setting objectAtIndex: 1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        NSDictionary *row = [sectionTwo objectAtIndex:indexPath.row];
        cell.textLabel.text = [row objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else{
        return 42;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StorageService *service = [[StorageService alloc] init];
        if ([service hasLogin]) {
            
        }else{
            LoginViewController *loginController = [[LoginViewController alloc] init];
            loginController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginController animated:YES];
        }
    }else{
        
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.listView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.listView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.listView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.listView setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
