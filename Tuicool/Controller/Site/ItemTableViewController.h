//
//  ItemTableView.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/2.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *listData;

@property(nonatomic, retain) UIViewController *navVC;
@end
