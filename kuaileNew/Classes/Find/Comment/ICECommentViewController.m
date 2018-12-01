//
//  ICECommentViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/27.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICECommentViewController.h"

@interface ICECommentViewController ()
@property (strong, nonatomic) IBOutlet UILabel *placeHolderText;
@end

@implementation ICECommentViewController

#pragma mark 配置界面

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"评论";
    // 设置占位文字
    if ([self.title isEqualToString:@"回复"]) {
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSString *strPlace = [NSString stringWithFormat:@"%@ 回复 %@", userModel.nickname, self.nickName];
        self.placeHolderText.text = strPlace;
    }
    
    if (self.labTitle.length > 0) {
        self.placeHolderText.text = @"";
        self.textView.text = self.labTitle;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self configTextView];
    [self.textView becomeFirstResponder];
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
    if (self.returnBlock) {
        self.returnBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
