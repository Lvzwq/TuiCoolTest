//
//  SettingsViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingLoginCell.h"
#import "Constants.h"


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
    CGFloat tableHeight = DeviceHeight - 64 - 49;
    self.listView.frame = CGRectMake(0, 64, DeviceWidth, tableHeight);
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.view addSubview: self.listView];
    
    [self addNavgationBar:@"我的"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//自定义导航栏
- (void)addNavgationBar: (NSString *)title{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 64)];
    UIColor *color = [UIColor colorWithRed:0.0f green:205/255.0f blue:144/255.0f alpha:1.0f];
    
    //设置导航栏标题属性
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont systemFontOfSize:18.0f], NSFontAttributeName,
                                 [UIColor whiteColor], NSForegroundColorAttributeName,
                                 nil];
    [navBar setTitleTextAttributes:navTitleArr];
    navBar.backgroundColor =  color;
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle: title];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:navBar];
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
