//
//  SecondViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SiteViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "BaseArticleController.h"
#import "SitesViewCell.h"

@interface SiteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listData;
@end

@implementation SiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"加载进入%@", self.class);
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"站点";
    //加载默认数据
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"default_sites" ofType:@"plist"];
    NSArray *sitesArray = [[NSArray alloc] initWithContentsOfFile:path];
    self.listData = [NSMutableArray arrayWithArray:sitesArray];
    NSLog(@"self.listData = %@", self.listData);
}

#pragma mark --UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.listData count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *cellIdentify = @"DefaultSitesCell";
        SitesViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[SitesViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        NSInteger row = indexPath.row;
        NSDictionary *sites = [self.listData objectAtIndex:row];
        
        cell.title.text = [sites objectForKey:@"name"];
        cell.num = 30;
        [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:[sites objectForKey:@"image"]]
                  placeholderImage:[UIImage imageNamed:@"placeholder_icon.png"]];
        
        return cell;
    }else {
        static NSString *addedCellIdentify = @"AddedSitesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addedCellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addedCellIdentify];
        }
        cell.textLabel.text = @"+ 订阅更多站点";
        cell.textLabel.frame = cell.frame;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index = %lu, section = %lu", (long)indexPath.row, (long)indexPath.section);
    if(indexPath.section == 0){
        NSLog(@"进入主题查看");
        NSInteger row = indexPath.row;
        NSDictionary *sites = [self.listData objectAtIndex:row];
        
        BaseArticleController *baseArticleController = [[BaseArticleController alloc] init];
        baseArticleController.view.frame = self.view.bounds;
        baseArticleController.view.backgroundColor = [UIColor yellowColor];
        baseArticleController.navigationItem.title = [sites objectForKey:@"name"];
        baseArticleController.baseUrl = [NSString stringWithFormat:@"http://api.tuicool.com/api/sites/%@.json", [sites objectForKey:@"id"]];
        baseArticleController.parameters = nil;
        [self.navigationController pushViewController:baseArticleController animated:YES];
    }else{
        NSLog(@"添加更多主题");
    }
}

@end
