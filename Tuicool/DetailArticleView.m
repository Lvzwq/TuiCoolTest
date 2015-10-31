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
#import "TCImageView.h"
@interface DetailArticleView()<UIWebViewDelegate>

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

/**
 * 工具栏
 */
@property(nonatomic, strong) UIToolbar *toolBar;

@end

@implementation DetailArticleView
@synthesize articleModel;
@synthesize vc;

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
        [self addToolBar];
        
    }
    return self;
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

//根据网页加载内容初始化webview
- (void)viewWithContent:(NSDictionary *)dict{
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.feedTitle.frame) + 5, DeviceWidth, self.frame.size.height - 40 - CGRectGetMaxY(self.feedTitle.frame));
    self.webView.backgroundColor = [UIColor greenColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    self.articleModel = [ArticleModel modelWithDict:[dict objectForKey:@"article"]];
    
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendString:@"<html>"];
    [content appendString:@"<head>"];
    [content appendString:@"<meta charset=\"utf-8\">"];
    [content appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [content appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [content appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [content appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [content appendString:@"<style>img{width:100%;}</style>"];
    [content appendString:@"</head>"];
    [content appendString:@"<body width=320px style=\"word-wrap:break-word; font-family:Arial\">"];
    NSDictionary *article = [dict objectForKey:@"article"];
    [content appendString:[article objectForKey:@"content"]];
    [content appendString:@"</body></html>"];
    NSLog(@"content = %@", content);
    
    // 获取当前应用的根目录, 从而加载css文件
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:content  baseURL:baseURL];
}

//适应屏幕的宽度(可以去掉)
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    NSRange range =  NSMakeRange(0, str.length);
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}


#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
     NSString  *jsString = @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        for(var i=0;i<objs.length;i++){\
            objs[i].onclick=function(){\
                 document.location=\"myweb:imageClick:\"+  this.src;\
            };\
        };\
        return objs.length;\
    };";
    //注入js方法
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    //调用js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = [[request URL] absoluteString];
    
    NSLog(@"urlString = %@", urlString);
    if ([urlString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [urlString substringFromIndex:@"myweb:imageClick:".length];
        TCImageView *tcImageView = [[TCImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
        [self addSubview:tcImageView];
        tcImageView.imageInfo = self.articleModel.images;
        tcImageView.imageURLString = imageUrl;
    }
    return YES;
}


#pragma mark -- 添加toolBar
- (void)addToolBar{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, DeviceWidth, 40.0f)];
    UIImage *back = [UIImage imageNamed:@"Left"];
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
    [self addSubview:self.toolBar];
}


- (void)dismissController{
    NSLog(@"返回");
    [self.vc dismissViewControllerAnimated:YES completion:nil];
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


