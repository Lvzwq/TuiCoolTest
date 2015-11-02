//
//  SitesViewCell.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/2.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SitesViewCell.h"
#import "Constants.h"
@interface SitesViewCell()

@property(nonatomic, strong) UIView *rightView;

@end
@implementation SitesViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.frame = CGRectMake(10, 7, 30, 30);
        CALayer *layer = self.thumbnail.layer;
        layer.cornerRadius = 15;
        [self addSubview:self.thumbnail];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.thumbnail.frame) + 15, 0, CGRectGetWidth(self.bounds) - 80 , self.rowHeight)];
        [self addSubview:self.title];
        self.rightView = [[UIView alloc] init];
        [self addSubview: self.rightView];
    }
    return self;
}


//显示当前未读文章数目
- (void) addWithNum:(int)num{
    NSLog(@"num = %d", num);
    if (num == 0) {
        if (self.rightView) {
            [self.rightView removeFromSuperview];
        }
    }else{
        NSLog(@"width = %f, dw = %f", self.frame.size.width, DeviceWidth);
        self.rightView.frame = CGRectMake(DeviceWidth - 40, 7, 30, 30);
        NSArray *subViews = self.rightView.subviews;
        NSLog(@"subViews = %@", subViews);
        UILabel *label = nil;
        if ([subViews count] == 0) {
            label = [[UILabel alloc] init];
            label.frame = self.rightView.bounds;
            label.backgroundColor = [UIColor redColor];
            label.layer.cornerRadius = 15;
            label.clipsToBounds = YES;
            [self.rightView addSubview:label];
        }else{
            label = (UILabel *)[subViews firstObject];
            NSLog(@"label = %@", label);
        }
        
        label.text = [NSString stringWithFormat:@"%d", num];
        label.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)addWithImage:(UIImage *)image{
    
}


- (CGFloat)rowHeight{
    return _rowHeight ? _rowHeight : 44.0f;
}

@end
