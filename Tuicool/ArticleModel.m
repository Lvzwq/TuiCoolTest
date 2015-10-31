//
//  ArticleModel.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel


+ (instancetype)modelWithDict:(NSDictionary *)dict{
    ArticleModel *instance = [[ArticleModel alloc] init];
    instance.url = [dict objectForKey:@"url"];
    instance.images = [dict objectForKey:@"images"];
    instance.content = [dict objectForKey:@"content"];
    instance.topics = [dict objectForKey:@"topics"];
    return instance;
}
@end
