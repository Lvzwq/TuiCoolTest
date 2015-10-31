//
//  HotViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "BaseArticleController.h"
#import "ArticleCell.h"
#import "TCNewsModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ArticleDetailController.h"

#define CacheImagePath(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]


@interface BaseArticleController ()
/**
 * 存放所有加载的数据
 */
@property(nonatomic, strong) NSMutableArray *listData;

/**
 *  存放所有下载操作的队列
 */
@property (nonatomic,strong) NSOperationQueue* queue;

/**
 *  存放所有的下载操作（url是key，operation对象是value）
 */
@property (nonatomic,strong) NSMutableDictionary* operations;

/**
 *  存放所有下载完成的图片，用于缓存
 */
@property (nonatomic,strong) NSMutableDictionary* images;


/**
 *  发送http请求时的页数
 */
@property(nonatomic, readwrite) int pn;

@end

@implementation BaseArticleController
@synthesize baseUrl;
@synthesize parameters;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad, %@", self.class);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //内存警告时, 移除所有的下载操作缓存
    [self.queue cancelAllOperations];
    [self.operations removeAllObjects];
    // 移除所有的图片缓存
    [self.images removeAllObjects];
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)operations
{
    if (nil == _operations) {
        self.operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)images
{
    if (nil == _images) {
        self.images = [NSMutableDictionary dictionary];
    }
    return _images;
}


- (void) loadData{
    
    [self loadDataWithType:1 withParameter:self.parameters];
    [self.tableView.header endRefreshing];
}

- (void)loadMoreData{
    NSLog(@"load more Data");
    TCNewsModel *model = [TCNewsModel newsModelWithDict:[self.listData lastObject]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
    [param setObject:@"pn" forKey:[[NSNumber alloc] initWithInt:self.pn + 1]];
    [param setObject:@"last_time" forKey:model.uts];
    [param setObject:@"last_id" forKey:model.id];
    
    [self loadDataWithType:2 withParameter:param];
    [self.tableView.footer endRefreshing];
}

- (void)loadDataWithType:(int)type withParameter: (NSDictionary *)parameters{
    //判断网络状态
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
    }];
    [mgr startMonitoring];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //获取设备的User-Agent
    //NSString *userAgent = [manager.requestSerializer valueForHTTPHeaderField:@"User-Agent"];
    
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@", [[UIDevice currentDevice] name]];
    userAgent = [userAgent stringByAppendingPathComponent:@"2.13.1"];
    NSLog(@"user-agent = %@", userAgent);
    
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"Basic MC4wLjAuMDp0dWljb29s" forHTTPHeaderField:@"Authorization"];
    
    [manager GET:self.baseUrl parameters: self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resp = (NSDictionary *)responseObject;
        NSArray *articles = (NSMutableArray *)[resp objectForKey:@"articles"];
        
        if (type == 1) {
            self.listData = [NSMutableArray arrayWithArray:articles];
        }else if (type == 2){
            [self.listData addObjectsFromArray:articles];
            NSLog(@"count = %lud", (unsigned long)self.listData.count);
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark -- UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCNewsModel *tcNewsModel = [TCNewsModel newsModelWithDict:[self.listData objectAtIndex:indexPath.row]];
    NSString *cellIdentify = [ArticleCell idForRow:tcNewsModel];
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.newsModel = tcNewsModel;
    
    //文章中含有图片缩略图
    if (![tcNewsModel.img isEqualToString:@""]) {
        // 先从images缓存中取出图片url对应的UIImage
        UIImage *image = self.images[tcNewsModel.id];
        if (image) {
            //图片已经缓存，不需重新下载
            [cell loadImage:image];
        }else{
            //获取缓存图片存放路径
            NSString *imagePath = CacheImagePath(tcNewsModel.img);
            NSData  *imageData = [NSData dataWithContentsOfFile:imagePath];
            if (imageData) {
                //缓存中有图片
                [cell loadImage:[UIImage imageWithData:imageData]];
            }else{
                //到子线程执行下载操作
                //取出当前URL对应的下载下载操作
                NSBlockOperation *operation = self.operations[tcNewsModel.id];
                NSLog(@"执行下载操作, operation = %@", operation);
                if (nil == operation) {
                    
                    //创建下载操作
                    __weak typeof(self) vc = self;
                    operation = [NSBlockOperation blockOperationWithBlock:^{
                        
                        NSURL* url = [NSURL URLWithString: tcNewsModel.img];
                        NSData* data =  [NSData dataWithContentsOfURL:url];
                        UIImage* image = [UIImage imageWithData:data];
                        
                        //下载完成的图片放入缓存字典中
                        if (image) {
                            //防止下载失败为空赋值造成崩溃
                            vc.images[tcNewsModel.id] = image;
                            
                            //下载完成的图片存入沙盒中
                            
                            // UIImage --> NSData --> File（文件）
                            NSData* imageData = UIImagePNGRepresentation(image);
                            
                            [imageData writeToFile:CacheImagePath(tcNewsModel.img) atomically:YES];
                        }
                        //回到主线程刷新表格
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //从字典中移除下载操作
                            [self.operations removeObjectForKey:tcNewsModel.id];
                            //刷新当前行的图片数据
                            [vc.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }];

                    }];
                }
                //添加操作到队列中
                [self.queue addOperation:operation];
                //添加到字典中
                self.operations[tcNewsModel.id] = operation;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCNewsModel *tcNewsModel = [self.listData objectAtIndex:indexPath.row];
    return [ArticleCell rowForHeight:tcNewsModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCNewsModel *model = [TCNewsModel newsModelWithDict:[self.listData objectAtIndex:indexPath.row]];
    ArticleDetailController *detailViewController = [[ArticleDetailController alloc] init];
    detailViewController.newsModel = model;
    [self presentViewController:detailViewController animated:YES completion:^{
        NSLog(@"hello world");
    }];
    NSLog(@"你点击进入的model.text = %@", model.title);
}
@end
