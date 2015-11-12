//
//  AccountService.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "AccountService.h"
#import "AFNetworking.h"
#import "StorageService.h"
#import "AccountModel.h"

@implementation AccountService


- (void)loginWithEmail:(NSString *)email Password:(NSString *)password andBlock:(void (^)(id responseObject, NSError *error))block{
    NSLog(@"发送请求");
    self.requestURL = @"http://api.tuicool.com/api/login.json";
    
    //转化为json字符串
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [self defaultHTTPHeader];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.requestURL]];
    [request setAllHTTPHeaderFields:[self.requestSerializer HTTPRequestHeaders]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        id error = [self preHandleResponse:responseObject];
        if(error){     //登录信息有误
            NSString *errorMsg = [responseObject objectForKey:@"error"];
            NSLog(@"errorMsg = %@", errorMsg);
            block(responseObject, nil);
        }else{        //登录成功
            NSDictionary *user = [responseObject objectForKey:@"user"];
            AccountModel *model = [AccountModel newsModelWithDict:user];
            StorageService *service = [StorageService shareInstance];
            [service addLoginInfo:model];
            block(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
        block(nil, error);
    }];
    [self.operationQueue addOperation:operation];
}

@end
