//
//  LoginViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/10.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AccountService.h"
#import "RegisterViewController.h"


@interface LoginViewController ()

@property(nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerUser)];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup{
    self.view.backgroundColor = [UIColor colorWithRed:0.90f green:0.87f blue:0.86f alpha:1.0f];
    UIImageView *paperPlane = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceWidth - 100)/2, 80, 100, 100)];
    paperPlane.image = [UIImage imageNamed:@"Paper"];
    [self.view addSubview:paperPlane];
    
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(20, 200, DeviceWidth - 40, 100)];
    [self.view addSubview:self.loginView];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 320, 180, 50)];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    loginButton.backgroundColor = DefaultColor;
    loginButton.layer.cornerRadius = 5;
    [self.view addSubview:loginButton];
    
    UIButton *forgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginButton.frame) + 20, 320, 100, 50)];
    [forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
    
    [forgetPassword setTitleColor:DefaultColor forState:UIControlStateNormal];
    forgetPassword.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:forgetPassword];
    
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    //其他登录方式
    UILabel *otherLoginWay = [[UILabel alloc] init];
    otherLoginWay.frame = CGRectMake((DeviceWidth - 90)/2, 410, 90, 20);
    otherLoginWay.text = @"其他登录方式";
    otherLoginWay.backgroundColor = [UIColor clearColor];
    [otherLoginWay setFont:[UIFont systemFontOfSize:14.0f]];
    [self.view addSubview:otherLoginWay];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(35, 420, (DeviceWidth - 90)/2 - 40, 1)];
    leftLine.backgroundColor = DefaultColor;
    [self.view addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(otherLoginWay.frame), 420, (DeviceWidth - 90)/2 - 40, 1)];
    rightLine.backgroundColor = DefaultColor;
    [self.view addSubview:rightLine];
    
    //微信、微博、QQ
    UIButton *weibo = [[UIButton alloc] init];
    weibo.frame = CGRectMake(DeviceWidth/2 - 56, 460, 24, 24);
    [weibo setImage:[UIImage imageNamed:@"weibo48"] forState:UIControlStateNormal];
    [self.view addSubview:weibo];
    [weibo addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *weixin = [[UIButton alloc] init];
    weixin.frame = CGRectMake(DeviceWidth/2 - 12, 460, 24, 24);
    [weixin setImage:[UIImage imageNamed:@"weixin48"] forState:UIControlStateNormal];
    [self.view addSubview:weixin];
    [weixin addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *qq = [[UIButton alloc] init];
    qq.frame = CGRectMake(DeviceWidth/2 + 32, 460, 24, 24);
    [qq setImage:[UIImage imageNamed:@"qq24"] forState:UIControlStateNormal];
    [self.view addSubview:qq];
    [qq addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//点击登录动作
- (void)login{
    NSLog(@"登录");
    NSString *email = self.loginView.emailField.text;
    NSString *password = self.loginView.passwordField.text;
    NSLog(@"email = %@, password = %@", email, password);
    AccountService *service = [AccountService sharedRequestManager];
    [service loginWithEmail:email Password:password andBlock:^(id responseObject, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)weiboLogin{
    NSLog(@"微博登录");
}

- (void)weixinLogin{
    NSLog(@"微信登录");
}

- (void)qqLogin{
    NSLog(@"qq登录");
}

- (void) registerUser{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}


@end
