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


- (void)setTc_x:(CGFloat)tc_x{
    CGRect frame = self.frame;
    frame.origin.x = tc_x;
    self.frame = frame;
}

-(CGFloat)tc_x{
    return self.frame.origin.x;
}

- (void)setTc_y:(CGFloat)tc_y{
    CGRect frame = self.frame;
    frame.origin.y = tc_y;
    self.frame = frame;
}

- (CGFloat)tc_y{
    return self.frame.origin.y;
}

- (void)setTc_width:(CGFloat)tc_width{
    CGRect frame = self.frame;
    frame.size.width = tc_width;
    self.frame = frame;
}

- (CGFloat)tc_width{
    return self.frame.size.width;
}

- (void)setTc_height:(CGFloat)tc_height{
    CGRect frame = self.frame;
    frame.size.height = tc_height;
    self.frame = frame;
}

- (CGFloat)tc_height{
    return self.frame.size.height;
}

- (void)setTc_size:(CGSize)tc_size{
    CGRect frame = self.frame;
    frame.size = tc_size;
    self.frame = frame;
}

- (CGSize)tc_size{
    return self.frame.size;
}

- (void)setTc_origin:(CGPoint)tc_origin{
    CGRect frame = self.frame;
    frame.origin = tc_origin;
    self.frame = frame;
}

- (CGPoint)tc_origin{
    return self.frame.origin;
}


@end
