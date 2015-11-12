//
//  SettingLoginCell.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "SettingLoginCell.h"
@interface SettingLoginCell()
@property(nonatomic, assign)BOOL isLoged;
@end

@implementation SettingLoginCell
@synthesize avatar;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.frame = CGRectMake(20, 10, 50, 50);
        self.avatar.image = [UIImage imageNamed:@"user_default"];
        [self addSubview:self.avatar];
        
        self.nickName = [[UILabel alloc] init];
        self.nickName.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 20, 10, 200, 50);
        self.nickName.text = @"点击登录";
        self.nickName.numberOfLines = 1;
        self.nickName.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.nickName];
    }
    return self;
}



@end
