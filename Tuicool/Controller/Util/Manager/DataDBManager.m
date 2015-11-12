//
//  DataDBManager.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/5.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "DataDBManager.h"

@implementation DataDBManager

#pragma mark -- 默认的路径
+ (NSString *)defaultPath: (NSString *)filename{
    if (!filename || filename.length <= 0) {
        return filename;
    }
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArr objectAtIndex:0];
    return [path stringByAppendingPathComponent:filename];
}

- (BOOL)beforeExec:(NSString *)sql{
    if ([self open]) {
        BOOL isCreateTable = [self executeUpdate:sql];
        return isCreateTable;
    }
    return NO;
}


@end
