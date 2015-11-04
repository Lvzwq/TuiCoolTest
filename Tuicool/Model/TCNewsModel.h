//
//  TCNewsModel.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/29.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNewsModel : NSObject
/**
 *新闻的id
 */
@property(nonatomic, copy) NSString *id;

/**
 *新闻的标题
 */
@property(nonatomic, copy) NSString *title;

/**
 *新闻的发布时间
 */
@property(nonatomic, copy) NSString *time;

@property(nonatomic, copy) NSString *rectime;

/**
 *rectime的微秒级的时间戳
 */
@property(nonatomic, copy) NSNumber *uts;

/**
 *新闻来源
 */
@property(nonatomic, copy) NSString *feed_title;

/**
 *图片链接
 */
@property(nonatomic, copy) NSString *img;

@property(nonatomic, copy) NSString *abs;

@property(nonatomic, copy) NSNumber *cmt;

/**
 *新闻是否推荐， 0为不推荐， 1为推荐
 */
@property(nonatomic, copy) NSNumber *st;

@property(nonatomic, copy) NSNumber *go;


+ (instancetype)newsModelWithDict:(NSDictionary *)dict;

+ (NSArray *)propertyList;
@end
