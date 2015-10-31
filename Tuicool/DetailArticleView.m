//
//  DetailArticleView.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "DetailArticleView.h"
#import "Constants.h"
#import "UILabel+FlexibleSize.h"
@interface DetailArticleView()

/**
 * 文章标题
 */
@property(nonatomic, retain) UILabel *articleTitle;

/**
 * 文章发布者
 */
@property(nonatomic, retain) UILabel *feedTitle;

/**
 * 文章发布时间
 */
@property(nonatomic, retain) UILabel *time;


@property(nonatomic, strong) UIWebView *webView;

@end

@implementation DetailArticleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加文章标题
        self.articleTitle = [[UILabel alloc] init];
        self.articleTitle.numberOfLines = 0;
        self.articleTitle.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.articleTitle];
        
        self.feedTitle = [[UILabel alloc] init];
        self.feedTitle.numberOfLines = 1;
        [self addSubview:self.feedTitle];
        
        self.time = [[UILabel alloc] init];
        self.time.numberOfLines = 1;
        [self addSubview:self.time];
        
        self.webView = [[UIWebView alloc] init];
        [self addSubview:self.webView];
    }
    return self;
}


- (void)setArticleModel:(ArticleModel *)articleModel{
    _articleModel = articleModel;
    [self initWithTitle:articleModel.newsModel.title
              feedTitle:articleModel.newsModel.feed_title
                time:articleModel.newsModel.time];

}

- (void) initWithTitle:(NSString *)title feedTitle:(NSString *)feedTitle time:(NSString *)time{
    //适应标题高度
    self.articleTitle.text = title;
    self.articleTitle.frame = CGRectMake(5, 20, DeviceWidth, 0);
    UIFont *titleFont = [UIFont boldSystemFontOfSize:20.0f];
    [self.articleTitle setFont:titleFont];
    [self.articleTitle resizeWithWidth:DeviceWidth];
    
    self.feedTitle.text = feedTitle;
    self.feedTitle.frame = CGRectMake(5, CGRectGetMaxY(self.articleTitle.frame) + 10, 0, 20);
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    [self.feedTitle setFont:font];
    [self.feedTitle resizeWithHeight:20];
    
    self.time.text = time;
    self.time.frame = CGRectMake(CGRectGetMaxX(self.feedTitle.frame) + 10, CGRectGetMaxY(self.articleTitle.frame) + 10, DeviceWidth - CGRectGetWidth(self.feedTitle.frame), 20);
    self.time.font = font;
}

- (void)viewWithContent:(NSDictionary *)dict{
    
    NSString *header = @"<!DOCTYPE html><head lang=\"zh\"><meta charset=\"UTF-8\"> <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"></head><body>";
    
    
    NSString *footer = @"</body></html>";
    self.webView.frame = CGRectMake(2, CGRectGetMaxY(self.feedTitle.frame) + 5, DeviceWidth - 4, DeviceHeight - 60 - CGRectGetMaxY(self.feedTitle.frame));
    self.webView.backgroundColor = [UIColor greenColor];
    
    NSDictionary *article = [dict objectForKey:@"article"];
    NSString *content = [article objectForKey:@"content"];
    NSString *html = [NSString stringWithFormat:@"%@%@%@", header, content, footer];
    NSLog(@"html= %@", html);
    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:html  baseURL:baseURL];
}

@end
