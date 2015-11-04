//
//  TCImageView.m
//  Tuicool
//
//  Created by zwenqiang on 15/10/31.
//  Copyright © 2015年 zwenqiang. All rights reserved.
//

#import "TCImageView.h"
#import "UIImageView+WebCache.h"

@interface TCImageView ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) int imageIndex;
@property(nonatomic, retain) UINavigationBar *navBar;
@end

@implementation TCImageView


-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addNavgationBar];

        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        
        //添加手势操作
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
        left.direction = UISwipeGestureRecognizerDirectionRight;
        [self.imageView addGestureRecognizer:left];
        
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
        right.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.imageView addGestureRecognizer:right];
    }
    return self;
}



-(void)setImageURLString:(NSString *)imageURLString{
    _imageURLString = imageURLString;
    NSURL *url = [NSURL URLWithString:imageURLString];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 100, image.size.width, image.size.height);
    self.imageView.center = self.center;
    NSLog(@"image = %@", image);
    
    int count = (int)[self.imageInfo count];
    NSLog(@"url = %@, %@",imageURLString, self.imageInfo);
    for (self.imageIndex = 0; self.imageIndex < count; self.imageIndex++) {
        NSDictionary *img = [self.imageInfo objectAtIndex:self.imageIndex];
        if ([imageURLString isEqualToString: [img objectForKey:@"src"]]) {
            break;
        }
    }
    self.navBar.topItem.title = [NSString stringWithFormat:@"%d/%d", (int)(self.imageIndex + 1), count];
}

#pragma mark -- 滑动手势切换图片
- (void)changeImage:(UISwipeGestureRecognizer *)gesture{
    NSUInteger count = [self.imageInfo count];
    NSLog(@"count = %lu", (unsigned long)count);
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右");
        if (self.imageIndex == 0) {
            [self removeView];
        }else{
            self.imageIndex -= 1;
            [self reloadImage:self.imageIndex];
        }
    }else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"向左");
        if (self.imageIndex == count - 1) {
            //到了最右边
        }else{
            self.imageIndex += 1;
            [self reloadImage:self.imageIndex];
        }
    }
}

#pragma mark 重新载入图片
- (void)reloadImage: (NSUInteger) index{
    NSDictionary *currentImage = [self.imageInfo objectAtIndex:self.imageIndex];
    NSString *imageURLString = [currentImage objectForKey:@"src"];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]]];
    self.imageView.image = image;
    self.navBar.topItem.title = [NSString stringWithFormat:@"%d/%d", (self.imageIndex + 1), (int)[self.imageInfo count]];
    
}

- (void)addNavgationBar{
    //创建一个导航栏
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 44)];
    UIColor *color = [UIColor colorWithRed:0 green:205/255.0f blue:144/255.0f alpha:1.0f];
    self.navBar.barTintColor = color;
    
     //创建一个导航栏集合
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.title = @"1/40";
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [back setImage:[UIImage imageNamed:@"back-25.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    back.tintColor = [UIColor whiteColor];
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
                                                                          
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [self.navBar pushNavigationItem:item animated:NO];
    
    //将标题栏中的内容全部添加到主视图当中
    [self addSubview:self.navBar];
}

- (void)removeView{
    [self removeFromSuperview];
}



@end
