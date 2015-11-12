//
//  AccountService.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"

@interface AccountService : RequestManager
/**
 * 使用邮箱、密码登录
 */
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password andBlock:(void (^)(id responseObject, NSError *error))block;

@end
