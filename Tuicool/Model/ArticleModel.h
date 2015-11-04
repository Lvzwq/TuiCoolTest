//
//  ArticleModel.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCNewsModel.h"

@interface ArticleModel : NSObject

/**
 * 文章简略信息
 */
@property(nonatomic, retain) TCNewsModel *newsModel;

/**
 *文章链接
 */
@property(nonatomic, copy) NSString *url;

/**
 *文章内容
 */
@property(nonatomic, copy) NSString *content;

/**
 *文章涉及的来源
 */
@property(nonatomic, retain) NSArray *topics;

/**
 * 文章中含有的图片
 */
@property(nonatomic, retain) NSArray *images;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
