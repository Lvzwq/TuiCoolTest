//
//  LoginView.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginView ()<UITextFieldDelegate>


@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.99f green:0.98f blue:0.96f alpha:1.0f];
        CALayer *layer = [self layer];
        layer.cornerRadius = 5;
        [self.layer setMasksToBounds:YES];
        
        UIImageView *mailImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        mailImage.image = [UIImage imageNamed:@"Message"];
        self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, frame.size.width - 80, 50)];
        self.emailField.layer.cornerRadius = 5;
        self.emailField.backgroundColor = [UIColor clearColor];
        self.emailField.placeholder = @"Email Address";
        [self addSubview:mailImage];
        [self addSubview:self.emailField];
        
        UIImageView *privacyImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 60, 30, 30)];
        privacyImage.image = [UIImage imageNamed:@"Privacy"];
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(65, 50, frame.size.width - 80, 50)];
        self.passwordField.layer.cornerRadius = 5;
        self.passwordField.backgroundColor = [UIColor clearColor];
        self.passwordField.placeholder = @"Password";
        self.passwordField.secureTextEntry = TRUE;
        [self addSubview:privacyImage];
        [self addSubview:self.passwordField];
        // 设置是否有清除按钮，在什么时候显示，用于一次性删除输入框中的所有内容
        self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordField.returnKeyType = UIReturnKeyDone;
        //设置代理
        self.passwordField.delegate = self;
        self.emailField.delegate = self;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    //设置粗细
    CGContextSetLineWidth(context, 0.2);
    //开始绘图
    CGContextBeginPath(context);
    //移动到开始绘图点
    CGContextMoveToPoint(context, 65, 50);
    //移动到第二个点
    CGContextAddLineToPoint(context, self.frame.size.width-10, 50);
    //关闭路径
    CGContextClosePath(context);
    //设置颜色
    [[UIColor grayColor] setStroke];
    //绘图
    CGContextStrokePath(context);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"关闭键盘");
    [textField resignFirstResponder];
    return YES;
}


@end
