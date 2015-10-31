//
//  HotViewController.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseArticleController : UITableViewController

@property(nonatomic, retain) NSString *baseUrl;
@property(nonatomic, retain) NSMutableDictionary *parameters;
@end
