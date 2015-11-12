//
//  AccountModel.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface AccountModel : NSObject

@property(nonatomic, copy) NSNumber *id;

@property(nonatomic, copy) NSNumber *uid;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *profile;

@property(nonatomic, copy) NSString *email;

@property(nonatomic, copy) NSString *token;

@property(nonatomic, copy) NSNumber *weibo_id;

@property(nonatomic, copy) NSString *weibo_name;

@property(nonatomic, copy) NSString *qq_id;

@property(nonatomic, copy) NSString *qq_name;

@property(nonatomic, copy) NSString *weixin_name;

@property(nonatomic, copy) NSString *flyme_name;


+ (instancetype)newsModelWithDict:(NSDictionary *)dict;

+ (instancetype)modelFromResult:(FMResultSet *)result;

@end
