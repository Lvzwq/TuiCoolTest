//
//  ArticleCellTableViewCell.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/27.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "ArticleCell.h"

#define DeviceWidth  ([UIScreen mainScreen].bounds.size.width)
@interface ArticleCell()
/**
 * 设置背景视图
 */
@property(nonatomic, retain) UIView *bgView;

/**
 *  文章的缩略图
 */
@property(nonatomic, retain) UIImageView *imageIcon;

/**
 *  文章的标题
 */
@property(nonatomic, retain) UILabel *title;

/**
 *  文章的来源
 */
@property(nonatomic, retain) UILabel *feedTitle;

/**
 *  文章的时间
 */
@property(nonatomic, retain) UILabel *rectime;

@end

@implementation ArticleCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        [self addSubview:self.bgView];
        
        //文章标题
        self.title = [[UILabel alloc] init];
        self.title.numberOfLines = 0;
        [self.bgView addSubview:self.title];
        
        //文章来源
        self.feedTitle = [[UILabel alloc] init];
        self.feedTitle.numberOfLines = 1;
        [self.bgView addSubview:self.feedTitle];
        
        //文章发布时间
        self.rectime = [[UILabel alloc] init];
        self.rectime.numberOfLines = 1;
        [self.bgView addSubview:self.rectime];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewsModel:(TCNewsModel *)newsModel{
    _newsModel = newsModel;
    self.bgView.frame = CGRectMake(2, 2, CGRectGetWidth(self.frame) - 4, [ArticleCell rowForHeight:newsModel] - 2);
    
    self.title.text = self.newsModel.title;
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    self.title.font = [UIFont systemFontOfSize:15.0f];
    if (![newsModel.img isEqualToString:@""]) {
        //如果文章含有缩略图
        NSLog(@"有图片，链接为%@, 标题为: %@", newsModel.img, newsModel.title);
        self.imageIcon = [[UIImageView alloc] init];
        self.imageIcon.frame = CGRectMake(DeviceWidth - 90, 10, 80, 50);
        self.imageIcon.image = [UIImage imageNamed:@"myKing.jpg"];
        [self.bgView addSubview:self.imageIcon];
        self.title.frame = CGRectMake(5, 0, DeviceWidth - CGRectGetWidth(self.imageIcon.frame) - 20, 50);
        [self setLabelFlexable:self.title
                         frame:self.title.frame
                          text:self.newsModel.title
                          font:[UIFont systemFontOfSize:15.0f]];
    }else{
        //文章不含缩略图
        self.title.frame = CGRectMake(5, 0, DeviceWidth - 10, 50);
    }
    
    UIFont *smallFont = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    //设置文章来源
    self.feedTitle.frame = CGRectMake(5, CGRectGetMaxY(self.title.frame), 200, 20);
    self.feedTitle.font = smallFont;
    self.feedTitle.text = self.newsModel.feed_title;
    [self setLabelFlexable:self.feedTitle
                     frame:self.feedTitle.frame
                      text:self.newsModel.feed_title
                      font:smallFont];
    
    //设置文章发布时间
    self.rectime.frame = CGRectMake(CGRectGetMaxX(self.feedTitle.frame) + 20, CGRectGetMaxY(self.title.frame), 100, 20);
    self.rectime.font = smallFont;
    self.rectime.text = self.newsModel.rectime;
    
}

- (void)loadImage: (UIImage *)image{
    self.imageIcon.image = image;
}

/**
 * 设置自适应文本
 */
- (void)setLabelFlexable:(UILabel *)label frame:(CGRect)frame text:(NSString *)text font: (UIFont *)font{
    //设置文本属性
    NSDictionary *attributes = @{NSFontAttributeName: font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelFrame = [text boundingRectWithSize:frame.size options:options attributes:attributes context:nil];
    [label setFrame:CGRectMake(frame.origin.x, frame.origin.y, CGRectGetWidth(labelFrame), frame.size.height)
     ];
}
                    

+ (NSString *)idForRow:(TCNewsModel *)newsModel{
    if ([newsModel.img isEqualToString:@""]) {
        return @"ArticleTextCell";
    }else{
        return @"ArticleImgCell";
    }
}


+ (CGFloat) rowForHeight:(TCNewsModel *)newsModel{
    return 70;
}
@end
