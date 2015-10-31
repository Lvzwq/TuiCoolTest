//
//  TCNewsModel.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/29.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "TCNewsModel.h"

@implementation TCNewsModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict{
    TCNewsModel *newsModel = [[self alloc] init];
    [newsModel setValuesForKeysWithDictionary:dict];
    return newsModel;
}
@end
