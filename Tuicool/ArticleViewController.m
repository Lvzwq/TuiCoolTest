//
//  FirstViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "ArticleViewController.h"
#import "BaseArticleController.h"
#import "Constants.h"

@interface ArticleViewController () <UIScrollViewDelegate>
@property(nonatomic, retain) UIScrollView *titleBarScollView;
@property(nonatomic, retain) UIScrollView *contentScollView;
@property(nonatomic, retain) UITableView *listView;
@property(nonatomic, retain) NSArray *arrayList;
@property(nonatomic, readwrite) NSUInteger pageIndex;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"进入%@", ArticleViewController.class);
    self.titleBarScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, 40)];
    //去掉水平方向的滚动条
    self.titleBarScollView.showsHorizontalScrollIndicator = NO;
    self.titleBarScollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleBarScollView];
    [self addNavgationBar];
    [self addTitleBar];
    
    
    //添加控制器
    [self addController];
    CGFloat contextX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    CGFloat ControllerHeight = [UIScreen mainScreen].bounds.size.height - 104 - 49;
    self.contentScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, DeviceWidth, ControllerHeight)];
    
    self.contentScollView.contentSize = CGSizeMake(contextX, ControllerHeight);
    self.contentScollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScollView.backgroundColor = [UIColor whiteColor];
    self.contentScollView.pagingEnabled = YES;
    self.contentScollView.scrollEnabled = YES;
    
    //添加默认控制器
    BaseArticleController *defaultVC = [self.childViewControllers firstObject];
    defaultVC.view.frame = self.contentScollView.bounds;
    [self.contentScollView addSubview:defaultVC.view];
    self.contentScollView.delegate = self;
    [self.view addSubview:self.contentScollView];
    self.pageIndex = 0;
    UILabel *defaultLabel = (UILabel *)self.titleBarScollView.subviews[self.pageIndex];
    defaultLabel.textColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark -- 使用懒加载
- (NSArray *)arrayList{
    if(_arrayList == nil){
        _arrayList = [[NSArray alloc] initWithObjects:@"热门", @"推荐", @"科技", @"创投", @"数码", @"技术", @"设计", @"营销", nil];
    }
    return _arrayList;
}

//添加导航栏下的标题列表
- (void)addTitleBar{
    for (int i = 0; i < [self arrayList].count; i++) {
        CGFloat titleBarHeight = 40;
        CGFloat titleBarPerWidth = 50;
        CGFloat titleBarY = 0;
        CGFloat titleBarX = i * titleBarPerWidth + 20;
        UILabel *ub = [[UILabel alloc] initWithFrame:CGRectMake(titleBarX, titleBarY, titleBarPerWidth, titleBarHeight)];
        ub.font = [UIFont systemFontOfSize:14.0f];
        ub.text = [self.arrayList objectAtIndex:i];
        ub.tag = i + 30;
        ub.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTitle:)];
        [ub addGestureRecognizer:tap];
        [self.titleBarScollView addSubview:ub];
    }
    self.titleBarScollView.contentSize = CGSizeMake(20 + 50 *[self.arrayList count], 40);
}

/** 添加子控制器 */
- (void)addController
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Articles" ofType:@"plist"];
    NSDictionary *articles = [[NSDictionary alloc] initWithContentsOfFile:path];
    for (int i=0; i<self.arrayList.count ;i++){
        NSString *key = [self.arrayList objectAtIndex:i];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[articles objectForKey:key]];
        Boolean needLogin = [[dict objectForKey:@"needLogin"] boolValue];
        if (needLogin == NO) {
            BaseArticleController *vc = [[BaseArticleController alloc] init];
            vc.baseUrl = [dict objectForKey:@"url"];
            vc.parameters = [dict objectForKey:@"parameters"];
            [self addChildViewController:vc];
        }else{
            UIViewController *vc = [[UIViewController alloc] init];
            [self addChildViewController:vc];
        }
        
        
    }
}

//自定义导航栏
- (void)addNavgationBar{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 64)];
    UIColor *color = [UIColor colorWithRed:0 green:205/255.0f blue:144/255.0f alpha:1.0f];

    //设置导航栏标题属性
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont systemFontOfSize:18.0f], NSFontAttributeName,
                                 [UIColor whiteColor], NSForegroundColorAttributeName,
                                 nil];
    [navBar setTitleTextAttributes:navTitleArr];
    navBar.barTintColor = color;
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle: @"文章"];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:navBar];
}

//设置导航栏下标题点击事件
- (void)changeTitle: (UITapGestureRecognizer *)recognizer{
    UILabel *titlelabel = (UILabel *)recognizer.view;
    NSLog(@"轻击了%@", titlelabel.text);
    CGFloat offsetX = (titlelabel.tag - 30) * self.contentScollView.frame.size.width;
    
    CGFloat offsetY = self.contentScollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.contentScollView setContentOffset:offset animated:YES];
}


#pragma mark -- UIScrollViewDelegate代理方法实现
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 滚动结束后调用（代码导致）*/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScollView.frame.size.width;
    NSLog(@"滚动结束 %ld", (unsigned long)index);
    // 滚动标题栏
    UILabel *titleLabel = (UILabel *)self.titleBarScollView.subviews[index];
    titleLabel.textColor = [UIColor greenColor];
    
    UILabel *prevLabel = (UILabel *)self.titleBarScollView.subviews[self.pageIndex];
    if (index != self.pageIndex) {
        prevLabel.textColor = [UIColor blackColor];
    }
    self.pageIndex = index;
    
    CGFloat offsetX = titleLabel.center.x - self.titleBarScollView.frame.size.width * 0.5;

    CGFloat offsetMax = self.titleBarScollView.contentSize.width - self.titleBarScollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetX, self.titleBarScollView.contentOffset.y);
    [self.titleBarScollView setContentOffset:offset animated:YES];
    // 添加控制器
    UIViewController *newsVc = self.childViewControllers[index];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.contentScollView addSubview:newsVc.view];
}

//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    int leftIndex = (int)value;
    NSLog(@"index = %d", leftIndex);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
}



@end
