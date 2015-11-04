//
//  ItemTableView.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/2.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "ItemTableViewController.h"
#import "SitesViewCell.h"
#import "UIImageView+WebCache.h"
#import "BaseArticleController.h"

@interface ItemTableViewController()

@end

@implementation ItemTableViewController
@synthesize navVC;
- (void)viewDidLoad{
    NSLog(@"viewDidLoad, %@", self.class);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void) setListData:(NSMutableArray *)listData{
    NSLog(@"响应重新加载数据");
    _listData = listData;
    NSLog(@"listData = %@", _listData);
    [self.tableView reloadData];
}

#pragma mark --UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"CellItem";
    SitesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[SitesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
    
    cell.title.text = [dict objectForKey:@"name"];
    
    [cell.thumbnail sd_setImageWithURL:[dict objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *itemInfo = [self.listData objectAtIndex:indexPath.row];
    BaseArticleController *base = [[BaseArticleController alloc] init];
    NSLog(@"你点击了%@", [itemInfo objectForKey: @"name"]);
    base.baseUrl = [NSString stringWithFormat:@"http://api.tuicool.com/api/sites/%@.json", [itemInfo objectForKey:@"id"]];
    base.navigationItem.title = [itemInfo objectForKey: @"name"];
    [base.parameters setObject:@30 forKey:@"size"];
    [self.navVC.navigationController pushViewController:base animated:YES];
}

@end
