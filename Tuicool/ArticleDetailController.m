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

@property(nonatomic, strong) UIToolbar *toolBar;
@end

@implementation ArticleDetailController
@synthesize newsModel = _newsModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"进入到viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailArticle = [[DetailArticleView alloc] initWithFrame:CGRectMake(0, 20, DeviceWidth, DeviceHeight)];
    
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
    [self addToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArticle{
    // http://api.tuicool.com/api/articles/RBrmiqj.json?need_image_meta=1
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
        NSLog(@"JSON: %@", responseObject);
        [self.indicatorView removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)addToolBar{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, DeviceHeight - 40, DeviceWidth, 40.0f)];
    UIImage *back = [UIImage imageNamed:@"left_filled-25"];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:back
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(dismissController)];
    item1.tintColor = [UIColor greenColor];
    
    UIImage *star = [UIImage imageNamed:@"Star"];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:star
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(starArticle)];
    item2.tintColor = [UIColor greenColor];
    
    UIImage *share = [UIImage imageNamed:@"Share"];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:share
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(shareArticle)];
    item3.tintColor = [UIColor greenColor];
    
    UIImage *comment = [UIImage imageNamed:@"Bubble"];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:comment
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(commentArticle)];
    item4.tintColor = [UIColor greenColor];
    
    UIImage *more = [UIImage imageNamed:@"Star"];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithImage:more
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(more)];
    item5.tintColor = [UIColor greenColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                              target:nil
                              action:nil];
    

    [self.toolBar setItems:[NSArray arrayWithObjects:item1, item, item2, item, item3, item, item4, item, item5, nil]];
    [self.view addSubview:self.toolBar];
}

- (void)dismissController{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)starArticle{
    NSLog(@"收藏");
}

- (void)shareArticle{
    
}

- (void)commentArticle{
    
}

- (void)more{
    
}


@end
