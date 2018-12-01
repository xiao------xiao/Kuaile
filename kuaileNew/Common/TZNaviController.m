//
//  TZNaviController.m
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import "TZNaviController.h"
#import "UIBarButtonItem+Extension.h"

@interface TZNaviController ()
@end

@implementation TZNaviController

+ (void)initialize {
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = color_darkgray;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSForegroundColorAttributeName] = color_lightgray;
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tapbackground"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundColor:color_white];
//    [self.navigationBa
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.translucent = NO;
    
    self.navigationBar.tintColor = color_darkgray;
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: color_darkgray, NSFontAttributeName:[UIFont boldSystemFontOfSize:19]};
    
    
    
    UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(PopViewController)];
    
    self.navigationItem.leftBarButtonItem= backButton;
}
-(void)PopViewController{
    [self popViewControllerAnimated:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end

