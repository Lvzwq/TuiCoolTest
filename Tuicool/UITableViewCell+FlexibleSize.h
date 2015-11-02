//
//  UITableViewCell+FlexibleSize.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/1.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (FlexibleSize)

@property (assign, nonatomic) CGFloat tc_x;
@property (assign, nonatomic) CGFloat tc_y;
@property (assign, nonatomic) CGFloat tc_width;
@property (assign, nonatomic) CGFloat tc_height;
@property (assign, nonatomic) CGSize tc_size;
@property (assign, nonatomic) CGPoint tc_origin;

@end
