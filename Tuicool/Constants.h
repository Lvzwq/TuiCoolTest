//
//  Constant.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)

#define DeviceWidth  ([UIScreen mainScreen].bounds.size.width)
#define DeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)
