//
//  TZFeedBackViewController.m
//  刷刷
//
//  Created by 谭真 on 16/2/16.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZFeedBackViewController.h"

@interface TZFeedBackViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITextView *tvContent;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, strong) UILabel *labPlaceholder;
@property (nonatomic, strong) UIView *tfPhoneBg;
@property (nonatomic, strong) UIButton *btnSubmit;
@end

@implementation TZFeedBackViewController
@synthesize tvContent;
@synthesize tfPhone;
@synthesize placeholderStr;
@synthesize labPlaceholder;
@synthesize tfPhoneBg;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TZColorRGB(248);
    
    // 容器View
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, 150)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    // 输入UITextView
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, contentView.width - 10, contentView.height - 10)];
    tvContent.returnKeyType = UIReturnKeyNext;
    tvContent.text = self.textViewText;
    tvContent.textAlignment = NSTextAlignmentLeft;
    tvContent.font = [UIFont systemFontOfSize:14];
    tvContent.tag = 2;
    tvContent.delegate = self;
    [contentView addSubview:tvContent];
    
    // 不同的type，不同的界面
    CGFloat phoneBgViewHeight = 0.0, labPlaceholderHeight = 0.0;
    if (self.type == TZInputVcTypeFeedBack) {
        self.navigationItem.title = @"意见反馈";
        placeholderStr = @"如果你有任何对于开心工作的意见或建议，欢迎反馈给我们，帮助开心工作变得更好。";
        
        labPlaceholderHeight = 40;
        phoneBgViewHeight = 40;
    }
    
    // 占位文字
    labPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, contentView.width - 15, labPlaceholderHeight)];
    labPlaceholder.textColor = TZColorRGB(128);
    labPlaceholder.textAlignment = NSTextAlignmentLeft;
    labPlaceholder.numberOfLines = 0;
    labPlaceholder.text = placeholderStr;
    labPlaceholder.font = [UIFont systemFontOfSize:14];
    labPlaceholder.userInteractionEnabled = YES;
    labPlaceholder.hidden = self.textViewText ? YES : NO;
    [contentView addSubview:labPlaceholder];
    
    // 联系方法View
    tfPhoneBg = [[UIView alloc] initWithFrame:CGRectMake(contentView.left, contentView.bottom + 10, contentView.width, phoneBgViewHeight)];
    tfPhoneBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tfPhoneBg];
    
    // 联系方式输入框
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, contentView.width - 10, tfPhoneBg.height)];
    tfPhone.textAlignment = NSTextAlignmentLeft;
    tfPhone.backgroundColor = [UIColor whiteColor];
    tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"联系方式（必填,方便我们联系您）" attributes:@{NSForegroundColorAttributeName: TZColorRGB(128)}];
    tfPhone.font = [UIFont systemFontOfSize:14];
    tfPhone.delegate = self;
    tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    [tfPhoneBg addSubview:tfPhone];
    
    // 提交按钮
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(tfPhoneBg.left, tfPhoneBg.bottom + 30, tfPhoneBg.width, 44)];
    [self.btnSubmit setBackgroundColor:__kNaviBarColor];
    self.btnSubmit.enabled = NO;
    [self.btnSubmit setBackgroundImage:[ICETools imageCreateWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 4;
    self.btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBtnEnableStatus) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tvContent becomeFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self refreshBtnEnableStatus];
    labPlaceholder.hidden = tvContent.text.length >= 1 ? YES : NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self refreshBtnEnableStatus];
    return YES;
}

#pragma mark - 点击事件

/// 提交按钮点击事件
- (void)btnSubmitAction {
    [self.view endEditing:YES];
    if (![ICETools isMobileNumber:tfPhone.text]) {
        [self showErrorHUDWithError:@"请填写正确的手机号"]; return;
    }
    // 意见反馈
    if (self.type == TZInputVcTypeFeedBack) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"phone"] = tfPhone.text;
        params[@"content"] = tvContent.text;
        [TZHttpTool postWithURL:ApiFeedBack params:params success:^(NSDictionary *result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSuccessHUDWithStr:@"提交成功,感谢你的参与"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSString *error) {
            [self showErrorHUDWithError:error];
        }];
    }
}

#pragma mark - 私有方法

/// 刷新提交按钮的enable状态
- (void)refreshBtnEnableStatus {
    if (tfPhoneBg.height > 0) {
        self.btnSubmit.enabled = (self.tvContent.text.length > 0 && self.tfPhone.text.length > 10);
    } else {
        self.btnSubmit.enabled = (self.tvContent.text.length > 0);
    }
}

@end
