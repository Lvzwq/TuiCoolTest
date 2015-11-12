//
//  RegisterViewController.m
//  Tuicool
//
//  Created by zwenqiang on 15/11/11.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"

@interface RegisterViewController ()

@property(nonatomic, strong) RegisterView *registerView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:0.90f green:0.87f blue:0.86f alpha:1.0f];
    [self load];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)load{
    UIImageView *registerIcon = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceWidth - 100)/2, 80, 100, 100)];
    registerIcon.image = [UIImage imageNamed:@"ios8"];
    [self.view addSubview:registerIcon];
    
    self.registerView = [[RegisterView alloc] initWithFrame:CGRectMake(20, 200, DeviceWidth-40, 240)];
    [self.view addSubview:self.registerView];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 440, DeviceWidth-40, 50)];
    [registerButton setTintColor:[UIColor whiteColor]];
    [registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.cornerRadius = 5;
    registerButton.backgroundColor = DefaultColor;
    [self.view addSubview:registerButton];
}

- (void)registerUser{
    NSLog(@"注册用户");
    [self.navigationController popViewControllerAnimated:YES];
    
}

 
@end
