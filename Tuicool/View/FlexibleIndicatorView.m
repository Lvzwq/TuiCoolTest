//
//  FlexibleIndicatorView.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "FlexibleIndicatorView.h"

@interface FlexibleIndicatorView ()

@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end
@implementation FlexibleIndicatorView


- (id) initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 40, 40);
        self.backgroundColor = [UIColor yellowColor];
        CALayer *layer = [self layer];
        layer.cornerRadius = 5;
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        self.indicatorView.frame = CGRectMake(0, 0, 20, 20);
        self.indicatorView.center = self.center;
        self.alpha = 0;
        [self addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
    }
    return self;
}

- (void)removeFromSuperview{
    [self.indicatorView stopAnimating];
    [super removeFromSuperview];
    
}

- (void) show{
    self.alpha = 1;
}
@end
