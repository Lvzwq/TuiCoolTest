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
#import "ArticleDetailController.h"
#import "StorageService.h"
#import "RequestManager.h"

//获取缓存图片的路径
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
@property (nonatomic,strong) NSMutableDictionary *images;


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
    [self loadDefault];
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

- (void)loadDefault{
    NSInteger cid = [[self.parameters objectForKey: @"cid"] integerValue];
    NSLog(@"cid = %i", cid);
    if (!cid) {
        cid = 0;
    }
    StorageService *service = [StorageService shareInstance];
    NSArray *listModels = [service getNewsModelsById:cid];
    NSLog(@"数据库中listModel = %@", listModels);
    if ([listModels count] == 0) {
        [self loadData];
    }else{
        self.listData = [NSMutableArray arrayWithArray:listModels];
    }
}

#pragma mark -上拉刷新获取数据
- (void) loadData{
    [self loadDataWithType:1 withParameter:self.parameters];
    [self.tableView.header endRefreshing];
}

#pragma mark - 下拉加载更多
- (void)loadMoreData{
    TCNewsModel *model = [self.listData lastObject];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
    [param setObject:@"pn" forKey:[[NSNumber alloc] initWithInt:self.pn + 1]];
    [param setObject:@"last_time" forKey:model.uts];
    [param setObject:@"last_id" forKey:model.id];
    
    [self loadDataWithType:2 withParameter:param];
    [self.tableView.footer endRefreshing];
}

- (void)loadDataWithType:(int)type withParameter: (NSDictionary *) parameter{
    RequestManager *requestManager = [RequestManager sharedRequestManager];
    [requestManager beforeRequest];
    
    [requestManager defaultHTTPHeader];
    [requestManager requestJsonDataWithPath:self.baseUrl withParams:parameter autoShowError:YES withMethodType:GET andBlock:^(id responseObject, NSError *error) {
        //数据正常
        if(responseObject){
            NSDictionary *resp = (NSDictionary *)responseObject;
            NSArray *articles = (NSMutableArray *)[resp objectForKey:@"articles"];
            NSArray *listModels = [TCNewsModel arrayModels:articles];
            if (type == 1) {
                NSInteger cid = [[parameter objectForKey: @"cid"] integerValue];
                StorageService *service = [StorageService shareInstance];
                [service deleteNewsModelsById:cid];
                [service saveNewsModelWithArray:listModels withCategoryId: cid];
                self.listData = [NSMutableArray arrayWithArray: listModels];
            }else if (type == 2){
                [self.listData addObjectsFromArray:listModels];
                NSLog(@"当前加载了count = %lud", (unsigned long)self.listData.count);
            }
            [self.tableView reloadData];
        }
    }];
    
    //[manager.requestSerializer setValue:@"Basic MC4wLjAuMDp0dWljb29s" forHTTPHeaderField:@"Authorization"];
}

#pragma mark -- UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCNewsModel *tcNewsModel = [self.listData objectAtIndex:indexPath.row];
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
    TCNewsModel *model = [self.listData objectAtIndex:indexPath.row];
    ArticleDetailController *detailViewController = [[ArticleDetailController alloc] init];
    detailViewController.newsModel = model;
    [self presentViewController:detailViewController animated:YES completion:^{
        NSLog(@"返回的回调");
    }];
    
}
@end
