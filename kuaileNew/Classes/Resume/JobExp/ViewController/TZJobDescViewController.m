//
//  ICEJobDescViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobDescViewController.h"

@interface TZJobDescViewController ()
@property (strong, nonatomic) IBOutlet UILabel *placeHolderText;
@end

@implementation TZJobDescViewController

#pragma mark 配置界面

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置占位文字
    if (![self.title isEqualToString:@"工作描述"]) {
        self.placeHolderText.text = @"请介绍一下你自己（不超过500个字）";
    }
    
    if (self.labTitle.length > 0) {
        self.placeHolderText.text = @"";
        self.textView.text = self.labTitle;
    }
    
    // 在这里关掉智能键盘
//    IQKeyboardManager *mgr = [IQKeyboardManager sharedManager];
//    mgr.enableAutoToolbar = NO;
//    mgr.enable = NO;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self configTextView];
}

- (void)configTextView {
    [self.textView.rac_textSignal subscribeNext:^(NSString *x) {
        if (x.length == 0) {
            self.labPlaceholder.hidden = NO;
        } else {
            self.labPlaceholder.hidden = YES;
        }
    }];
}

#pragma mark 按钮点击事件

- (void)done {
    DLog(@"确定按钮被点击");
    self.returnJobDesc(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
