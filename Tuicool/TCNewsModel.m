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
@end
