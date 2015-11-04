//
//  ArticleCellTableViewCell.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNewsModel.h"

@interface ArticleCell : UITableViewCell
@property(nonatomic, strong) TCNewsModel *newsModel;

/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(TCNewsModel *)NewsModel;

/**
 * 设置行高
 */
+ (CGFloat) rowForHeight:(TCNewsModel *)newsModel;

/**
 * 设置文章缩略图
 */
- (void)loadImage: (UIImage *)image;

@end
