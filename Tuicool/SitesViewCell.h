//
//  SitesViewCell.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/2.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SitesViewCell : UITableViewCell


/**
 * 文章标题
 */
@property(nonatomic, strong) UILabel *title;

/**
 * 缩略图
 */
@property(nonatomic, strong) UIImageView *thumbnail;

/**
 * 高度
 */
@property(nonatomic, assign) CGFloat rowHeight;

- (void) addWithNum:(int)num;

- (void) addWithImage:(UIImage *)image;

@end
