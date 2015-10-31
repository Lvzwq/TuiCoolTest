//
//  DetailArticleView.h
//  Tuicool
//
//  Created by zwenqiang on 15/10/30.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

@interface DetailArticleView : UIView

@property(nonatomic, retain) ArticleModel *articleModel;

- (void) initWithTitle:(NSString *)title feedTitle:(NSString *)feedTitle time:(NSString *)time;

- (void)viewWithContent:(NSDictionary *)dict;

@end
