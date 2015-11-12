//
//  DataDBManager.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/5.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataDBManager : FMDatabase

+ (NSString *)defaultPath: (NSString *)filename;
- (BOOL)beforeExec:(NSString *)sql;

@end
