//
//  ArticleService.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/5.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "StorageService.h"
#import "TCNewsModel.h"

 

#define Filename @"tuicool.sqlite"
#define ArticleTable @"article"
#define AccountTable @"account"

@implementation StorageService

+ (instancetype)shareInstance:(NSString *)filename
{
    static StorageService *manager = nil;
    static dispatch_once_t onceToken;
    NSLog(@"path = %@", [StorageService defaultPath:filename]);
    dispatch_once(&onceToken, ^{
        manager = [[StorageService alloc] initWithPath:[StorageService defaultPath:filename]];
    });
    return manager;
}


+ (instancetype)shareInstance{
    return [self shareInstance:Filename];
}

- (void) createDB:(NSString *)sql{
    NSLog(@"TABLE_SQL = %@", sql);
    [self beforeExec:sql];
}


#pragma mark - 对文章表的数据库操作
+ (NSString *) articleSQL{
    NSString *createSQL =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (cid INTEGER, id TEXT, title TEXT, feed_title TEXT, time TEXT, rectime TEXT, img TEXT, uts INTEGER, abs TEXT, cmt INTEGER, st INTEGER, go INTEGER)", ArticleTable];
    return createSQL;
}

//保存文章列表到数据库
- (void)saveNewsModelWithArray:(NSArray *)newsModels withCategoryId:(NSInteger)cid{
    [self createDB:[StorageService articleSQL]];
    NSString *insertSQL = @"INSERT INTO article (cid, id, title, feed_title, time, rectime, img, uts, abs, cmt, st, go) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    for(TCNewsModel *modfl in newsModels){
        [self executeUpdate:insertSQL, [NSNumber numberWithInteger:cid], modfl.id, modfl.title, modfl.feed_title, modfl.time, modfl.rectime, modfl.img, modfl.uts, modfl.abs, modfl.cmt, modfl.st, modfl.go];
    }
}

//查询栏目下的文章列表
- (NSArray *)getNewsModelsById: (NSInteger)cid{
    [self createDB:[StorageService articleSQL]];
    NSString *selectSQL = @"SELECT * FROM article WHERE cid = ?";
    NSMutableArray *models = [[NSMutableArray alloc] init];
    FMResultSet *resultSet = [self executeQuery:selectSQL, [NSNumber numberWithInteger:cid]];
    
    while([resultSet next]){
        TCNewsModel *model = [TCNewsModel modelWithResult:resultSet];
        [models addObject:model];
    }
    return models;
}

//删除栏目下的文章列表
- (BOOL)deleteNewsModelsById: (NSInteger)cid{
    [self open];
    NSString *deleteSQL = @"DELETE FROM article WHERE cid = ?";
    return [self executeUpdate:deleteSQL, [NSNumber numberWithInteger:cid]];
}


#pragma mark - 对用户信息表的数据操作
+ (NSString *)accountSQL{
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (id INTEGER, email TEXT, name TEXT, uid INTEGER, profile TEXT, token TEXT, weibo_id INTEGER, weibo_name TEXT, qq_id TEXT, qq_name TEXT, weixin_name TEXT, flyme_name TEXT)", AccountTable];
    return createSQL;
}

//用户登录，添加登录信息
- (void)addLoginInfo:(AccountModel *)accountModel{
    [self createDB:[StorageService accountSQL]];
    NSString *insertSQL = @"INSERT INTO account (id, email, name, uid, profile, token, weibo_id, weibo_name, qq_id, qq_name, weixin_name, flyme_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    if ([self hasLogin]) {
        NSString *deleteSQL = @"DELETE FROM account";
        [self executeUpdate:deleteSQL];
    }
    [self executeUpdate:insertSQL, accountModel.id, accountModel.email, accountModel.name, accountModel.uid, accountModel.profile, accountModel.token, accountModel.weibo_id, accountModel.weibo_name, accountModel.qq_id, accountModel.qq_name, accountModel.weixin_name, accountModel.flyme_name];
}

//判读是否已经登录
- (BOOL)hasLogin{
    [self createDB:[StorageService accountSQL]];
    NSString *hasLoginSQL = @"SELECT * FROM account";
    FMResultSet *resultSet = [self executeQuery:hasLoginSQL];
    if([resultSet next]){
        return YES;
    }
    return NO;
}

- (AccountModel *)getUserInfo{
    NSString *selectSQL = @"SELECT * FROM account";
    FMResultSet *resultSet = [self executeQuery:selectSQL];
    NSLog(@"resultSet = %@", resultSet);
    NSLog(@"count = %d", [resultSet columnCount]);
    while ([resultSet next]) {
        NSLog(@"resultSet = %@", resultSet);
        AccountModel *model = [AccountModel modelFromResult:resultSet];
        NSLog(@"model = %@", model);
        return model;
    }
    return nil;
}

@end
