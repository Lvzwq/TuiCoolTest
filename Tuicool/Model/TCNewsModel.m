//
//  TCNewsModel.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/29.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "TCNewsModel.h"
#import<objc/runtime.h>


@implementation TCNewsModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict{
    TCNewsModel *newsModel = [[self alloc] init];
    [newsModel setValuesForKeysWithDictionary:dict];
    return newsModel;
}

+ (NSMutableArray *)arrayModels:(NSArray *)arr{
    NSMutableArray *listModels = [[NSMutableArray alloc] init];
    NSLog(@"listModels = %@", listModels);
    for (NSDictionary *dict in arr) {
        NSLog(@"数组中dict = %@", dict);
        TCNewsModel *model = [TCNewsModel newsModelWithDict:dict];
        [listModels addObject: model];
    }
    return listModels;
}

//获得所有的属性名
+ (NSArray*)propertyList{
    unsigned int outCount, i;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        [array addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    return array;
}

+ (TCNewsModel *)modelWithResult:(FMResultSet *)result{
    TCNewsModel *model = [[TCNewsModel alloc] init];
    model.id = [result stringForColumn:@"id"];
    model.title = [result stringForColumn:@"title"];
    model.feed_title = [result stringForColumn:@"feed_title"];
    model.time = [result stringForColumn:@"time"];
    model.rectime = [result stringForColumn:@"rectime"];
    model.img = [result stringForColumn:@"img"];
    model.uts = [NSNumber numberWithInt:[result intForColumn:@"uts"]];
    model.abs = [result stringForColumn:@"abs"];
    model.cmt = [NSNumber numberWithInt:[result intForColumn:@"cmt"]];
    model.go = [NSNumber numberWithInt:[result intForColumn:@"go"]];
    model.st = [NSNumber numberWithInt:[result intForColumn:@"st"]];
    return model;
}
@end
