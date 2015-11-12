//
//  ArticleService.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/5.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDBManager.h"
#import "AccountModel.h"


@interface StorageService : DataDBManager

+ (instancetype)shareInstance;

+ (instancetype)shareInstance:(NSString *)filename;

#pragma mark -文章简略信息
- (void)saveNewsModelWithArray:(NSArray *)newsModels withCategoryId:(NSInteger)cid;

- (NSArray *)getNewsModelsById: (NSInteger)cid;

- (BOOL)deleteNewsModelsById: (NSInteger)cid;

#pragma mark -用户表信息
- (BOOL)hasLogin;

- (void)addLoginInfo:(AccountModel *)accountModel;

- (AccountModel *)getUserInfo;
@end
