//
//  RecomendViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "ArticleDetailController.h"
#import "DetailArticleView.h"
#import "FlexibleIndicatorView.h"
#import "Constants.h"
#import "AFNetworking.h"

@interface ArticleDetailController ()

@property(nonatomic, strong) DetailArticleView *detailArticle;

@property(nonatomic, strong) FlexibleIndicatorView *indicatorView;


@end

@implementation ArticleDetailController
@synthesize newsModel = _newsModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"进入到viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailArticle = [[DetailArticleView alloc] initWithFrame:CGRectMake(0, 20, DeviceWidth, DeviceHeight - 20)];
    self.detailArticle.vc = self;
    [self.detailArticle initWithTitle:_newsModel.title
                            feedTitle:_newsModel.feed_title
                              time:_newsModel.time];
    [self.view addSubview:self.detailArticle];
    
    //添加手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.detailArticle addGestureRecognizer:swipe];
    
    //添加等待视图
    self.indicatorView = [[FlexibleIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicatorView];
    
    //加载文章内容
    [self loadArticle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArticle{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    const NSString *baseURL = @"http://api.tuicool.com/api/articles";
    NSString *url = [baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", self.newsModel.id]];
    NSDictionary *params = @{@"need_image_meta": @1};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@", [[UIDevice currentDevice] name]];
    userAgent = [userAgent stringByAppendingPathComponent:@"2.13.1"];
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"Basic MC4wLjAuMDp0dWljb29s" forHTTPHeaderField:@"Authorization"];

    [self.indicatorView show];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.detailArticle viewWithContent:(NSDictionary *)responseObject];
        [self.indicatorView removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)dismissController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
