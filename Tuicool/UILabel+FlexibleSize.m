//
//  UILabel+FlexibleSize.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "UILabel+FlexibleSize.h"

@implementation UILabel (FlexibleSize)


- (void)resizeWithWidth: (CGFloat)width{
    //设置文本属性
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    //设定属性
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin;
    CGSize fitToWidth = CGSizeMake(width, 500);
    CGRect labelFrame = [self.text boundingRectWithSize: fitToWidth options:options attributes:attributes context:nil];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, CGRectGetHeight(labelFrame))];

}

- (void)resizeWithHeight: (CGFloat)height{
    //设置文本属性
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    //设定属性
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin;
    CGSize fitToWidth = CGSizeMake(500, height);
    CGRect labelFrame = [self.text boundingRectWithSize: fitToWidth options:options attributes:attributes context:nil];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(labelFrame), height)];

}
@end
