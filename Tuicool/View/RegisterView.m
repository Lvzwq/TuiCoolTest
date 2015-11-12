//
//  RegisterView.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/11.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView ()<UITextFieldDelegate>

@end

@implementation RegisterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        self.email = [[UITextField alloc] init];
        self.email.placeholder = @"邮箱";
        
        self.name = [[UITextField alloc] init];
        self.name.placeholder = @"用户名";
        
        self.password = [[UITextField alloc] init];
        self.password.placeholder = @"密码(6-12位)";
        self.password.secureTextEntry = YES;
        
        self.passwordAgain = [[UITextField alloc] init];
        self.passwordAgain.placeholder = @"重复密码";
        self.passwordAgain.secureTextEntry = YES;
        
        [self addTextField:self.email withFrame:CGRectMake(0, 0, self.frame.size.width, 50)andImageName:@"Message"];
        
        [self addTextField:self.name withFrame:CGRectMake(0, 60, self.frame.size.width, 50)andImageName:@"user50"];
        
        [self addTextField:self.password withFrame:CGRectMake(0, 120, self.frame.size.width, 50)andImageName:@"Privacy"];
        
        [self addTextField:self.passwordAgain withFrame:CGRectMake(0, 180, self.frame.size.width, 50) andImageName:@"Privacy"];
        
        self.name.delegate = self;
        self.email.delegate = self;
        self.password.delegate = self;
        self.passwordAgain.delegate = self;
        
        self.email.keyboardType = UIKeyboardTypeEmailAddress;
        self.email.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (void)addTextField:(UITextField *)textField withFrame:(CGRect)frame andImageName:(NSString *)imageName{
    UIView *textView = [[UIView alloc] initWithFrame:frame];
    textView.layer.cornerRadius = 5;
    textView.backgroundColor = [UIColor colorWithRed:0.99f green:0.98f blue:0.96f alpha:1.0f];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    imageView.image = [UIImage imageNamed:imageName];
    textField.frame = CGRectMake(55, 0, frame.size.width - 65, 50);
    [textView addSubview:imageView];
    [textView addSubview:textField];
    [self addSubview:textView];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"关闭键盘");
    [textField resignFirstResponder];
    self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGFloat keyboardHeight = 216.0f;
    if (textField.keyboardType == UIKeyboardTypeDefault || textField.keyboardType == UIKeyboardTypeEmailAddress) {
        keyboardHeight += 40.0f;
    }
    NSLog(@"开始输入 键盘类型 = %ld, keyboardHeight = %f", (long)textField.keyboardType, keyboardHeight);
    UIView *superView = [textField superview];
    NSLog(@"textField = %@", NSStringFromCGRect(superView.frame));
    NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
    CGFloat offset = keyboardHeight + self.frame.origin.y + CGRectGetMaxY(superView.frame) - DeviceHeight;
    
    NSLog(@"height = %f", offset);
    
    if (offset > 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - offset, self.frame.size.width, self.frame.size.height);
    }
}



@end
