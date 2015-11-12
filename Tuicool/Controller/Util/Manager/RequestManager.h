//
//  RequestManager.h
//  Tuicool
//
//  Created by zwenqiang on 15/11/4.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum{
    GET = 0,
    POST,
    PUT,
    DELETE
}HTTPMethodString;

@interface RequestManager : AFHTTPRequestOperationManager

@property(nonatomic, strong) NSString *requestURL;

+ (instancetype)sharedRequestManager;

+ (instancetype) changeRequestManager;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HTTPMethodString)method
                       andBlock:(void (^)(id responseObject, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                      autoShowError:(BOOL)autoShowError
                 withMethodType:(HTTPMethodString)method
                       andBlock:(void (^)(id responseObject, NSError *error))block;

- (void)defaultHTTPHeader;
- (void)beforeRequest;
- (id)preHandleResponse:(id)responseObject;
@end
