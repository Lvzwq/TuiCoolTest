//
//  RequestManager.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/4.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "RequestManager.h"

#define HTTPMethodName @[@"GET", @"POST", @"PUT", @"DELETE"]
#define BaseURL @"http://api.tuicool.com/api";

@implementation RequestManager
@synthesize requestURL;

static RequestManager *_SingletonManager = nil;
static dispatch_once_t onceToken;


+ (instancetype)sharedRequestManager{
    dispatch_once(&onceToken, ^{
        _SingletonManager = [[super alloc] init];
    });
    return _SingletonManager;
}

+ (instancetype) changeRequestManager{
    _SingletonManager = [[super alloc] init];
    return _SingletonManager;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HTTPMethodString)method
                       andBlock:(void (^)(id responseObject, NSError *error))block{
    [self requestJsonDataWithPath:aPath withParams:params autoShowError:YES withMethodType:method andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                  autoShowError:(BOOL)autoShowError
                 withMethodType:(HTTPMethodString)method
                       andBlock:(void (^)(id responseObject, NSError *error))block{
    //打印请求日志
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", HTTPMethodName[method], aPath, params);
    if (!aPath || aPath.length <= 0) {
        return;
    }
    //发送请求
    switch (method) {
        case GET:{
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            NSLog(@"localPath = %@", localPath);
            [self GET:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self preHandleResponse:responseObject];
                NSLog(@"error = %@", error);
                if (error) {
                    block(responseObject, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                block(nil, error);
            }];
            break;
        }
        case POST:{
            NSLog(@"POST请求");
            break;
        }
        case PUT:{
            NSLog(@"PUT请求");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 组装HTTPHeader
- (void)defaultHTTPHeader{
    //设置userAgent
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@", [[UIDevice currentDevice] name]];
    userAgent = [userAgent stringByAppendingPathComponent:@"2.13.1"];
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    //设置Base Auth
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"10.0.2.15" password:@"tuicool"];
    
}

#pragma mark - NetError
- (id)preHandleResponse:(id)responseObject{
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        BOOL success = [[responseObject valueForKeyPath:@"success"] boolValue];
        //请求成功
        if (success) {
            NSLog(@"请求参数success = %d", success);
        }else{
            NSNumber *resultCode = [responseObject valueForKeyPath:@"code"];
            error = [NSError errorWithDomain: self.requestURL code:resultCode.intValue userInfo:responseObject];
        }
    }else{
        //如果放回json不是字典类型
        NSIndexSet *statusCodes = self.responseSerializer.acceptableStatusCodes;
        NSLog(@"statusCodes = %@", statusCodes);
    }
    return error;
}

//判断当前网络状态
- (void)beforeRequest{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case 1:
            case 2:
                //网络状态良好
                NSLog(@"当前网络状态良好");
                break;
            default:
                NSLog(@"网络链接出错");
                break;
        }
    }];
    [mgr startMonitoring];
}
@end
