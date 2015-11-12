//
//  AccountModel.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "AccountModel.h"


@implementation AccountModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict{
    AccountModel *newsModel = [[self alloc] init];
    [newsModel setValuesForKeysWithDictionary:dict];
    return newsModel;
}

+ (instancetype)modelFromResult:(FMResultSet *)result{
    AccountModel *model = [[AccountModel alloc] init];
    model.id = [NSNumber numberWithInt:[result intForColumn:@"id"]];
    model.uid = [NSNumber numberWithInt:[result intForColumn:@"uid"]];
    model.name = [result stringForColumn:@"name"];
    model.profile = [result stringForColumn:@"profile"];
    model.email = [result stringForColumn:@"email"];
    model.token = [result stringForColumn:@"token"];
    model.weibo_id = [NSNumber numberWithInt:[result intForColumn:@"weibo_id"]];
    model.weibo_name = [result stringForColumn:@"weibo_name"];
    model.weixin_name = [result stringForColumn:@"weixin_name"];
    model.qq_id = [result stringForColumn:@"qq_id"];
    model.qq_name = [result stringForColumn:@"qq_name"];
    model.flyme_name = [result stringForColumn:@"flyme_name"];
    return model;
}

@end
