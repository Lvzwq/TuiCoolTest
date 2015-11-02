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

@property(nonatomic, strong) UILabel *numLabel;

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
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.thumbnail.frame) + 15, 0, 200, self.rowHeight)];
        [self addSubview:self.title];
        
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.frame = CGRectMake(DeviceWidth - 40, 7, 30, 30);
        self.numLabel.layer.cornerRadius = 15;
        
        self.numLabel.clipsToBounds = YES;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void)setNum:(int)num{
    if (num == 0) {
        self.numLabel.alpha = 0;
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"%d", num];
        self.numLabel.alpha = 1.0f;
    }
    
}


- (CGFloat)rowHeight{
    return _rowHeight ? _rowHeight : 44.0f;
}

@end
