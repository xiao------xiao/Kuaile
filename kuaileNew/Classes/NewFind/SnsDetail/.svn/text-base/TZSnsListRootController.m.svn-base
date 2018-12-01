//
//  TZReportRootController.m
//  DemoProduct
//
//  Created by 谭真 on 16/6/9.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "TZSnsListRootController.h"
#import <Photos/Photos.h>
#import "IQKeyboardManager.h"
#import "TZFindSnsCell.h"
#import "ZYYSnsDetailController.h"

@interface TZSnsListRootController ()<UITextViewDelegate> {
    NSInteger _row;
    NSInteger _section;
    CGFloat _keyboardH;
    
    BOOL _isComment;
}
@end

@implementation TZSnsListRootController

- (HWEmotionKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[HWEmotionKeyboard alloc] init];
        // 键盘的宽度
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyboardH = 216;
    _textViewHeight = 50;
    [self setupContentView];
    // 添加输入控件
    [self setupTextView];
    // 添加工具条
    [self setupToolbar];
    [self configTableView];
}

- (void)configTableView {
    [super configTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TZFindSnsCell" bundle:nil] forCellReuseIdentifier:@"TZFindSnsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TZColorRGB(246);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [manager setEnable:NO];
    [manager setEnableAutoToolbar:NO];
    [TZUserManager isLogin];
    [self configNotification];
}

- (void)configNotification {
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
//    [mNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // 删除文字的通知
//    [mNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HWEmotionDidDeleteNotification object:nil];
    // 发送文字的通知
    [mNotificationCenter addObserver:self selector:@selector(emotionDidSend) name:HWEmotionDidSendNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [manager setEnable:YES];
    [manager setEnableAutoToolbar:YES];
    [mNotificationCenter removeObserver:self];
}

- (void)setupContentView {
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, mScreenHeight, mScreenWidth, _textViewHeight + _keyboardH);
    _contentView.backgroundColor = TZColorRGB(251);
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];
}

/// 添加输入控件
- (void)setupTextView {
    // 垂直方向上永远可以拖拽（有弹簧效果）
//    _textView = [[HWEmotionTextView alloc] init];
//    _textView.alwaysBounceVertical = YES;
//    _textView.placeholderMarginX = 8;
//    _textView.placeholderMarginY = 8;
//    _textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    _textView.font = [UIFont systemFontOfSize:15];
//    _textView.delegate = self;
//    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
//    _textView.returnKeyType = UIReturnKeySend;
//    _textView.placeholder = @"说点什么吧...";
//    _textView.frame = CGRectMake(10,8, mScreenWidth - 56, _textViewHeight - 16);
//    //在右边加一个切换表情按钮
//    _changeKBbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_changeKBbtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
//    _changeKBbtn.frame = CGRectMake(10 + mScreenWidth - 56, 8, 40, 40);
//    [[_changeKBbtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        [self switchKeyboard];
//    }];
//    _textView.layer.borderColor = TZColorRGB(222).CGColor;
//    _textView.layer.borderWidth = 1.0;
//    _textView.layer.cornerRadius = 5;
//    _textView.clipsToBounds = YES;
//    [_contentView addSubview:_textView];
//    [_contentView addSubview:_changeKBbtn];
}

/// 添加工具条
- (void)setupToolbar {
    HWComposeToolbar *toolbar = [[HWComposeToolbar alloc] init];
    toolbar.type = HWComposeToolbarTypeReport;
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = 0;
    toolbar.delegate = self;
//    [_contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)setTextViewHeight:(CGFloat)textViewHeight {
    _textViewHeight = textViewHeight;
    _textView.height = _textViewHeight;
}

#pragma makr - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZFindSnsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZFindSnsCell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    if (_noDismissKeyboard) {
        return;
    }
    self.dismissFromScroll = YES;
    [self.view endEditing:YES];
}

#pragma mark - 通知方法

/// 删除文字
- (void)emotionDidDelete {
    [self.textView deleteBackward];
}


#pragma mark -- 发送emoJ表情
- (void)emotionDidSend {
    [self sendBtnClick];
}

/// 表情被选中了
- (void)emotionDidSelect:(NSNotification *)notification {
    HWEmotion *emotion = notification.userInfo[HWSelectEmotionKey];
    [self.textView insertEmotion:emotion];
}

/// 键盘的frame发生改变时调用（显示、隐藏等）
//- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    // 如果正在切换键盘，就不要执行后面的代码
//    if (self.switchingKeybaord) return;
//    NSDictionary *userInfo = notification.userInfo;
//    // 动画的持续时间
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 键盘的frame
//    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    _keyboardH = _keyboardH;
//    _contentView.height = _textViewHeight + _keyboardH;
//    // 执行动画
//    [UIView animateWithDuration:duration animations:^{
//        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
//        if (keyboardF.origin.y >= self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
//            if (self.navigationController.childViewControllers.count <= 1) {
//                [self.tabBarController.tabBar setHidden:NO];
//            }
//            self.contentView.y = self.view.height;
//            [self.view bringSubviewToFront:self.contentView];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.isReply = NO;
//            });
//        } else {
//            [self.tabBarController.tabBar setHidden:YES];
//            self.contentView.y = keyboardF.origin.y - self.toolbar.height - 64 - _textViewHeight;
//        }
//    }];
//}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

#pragma mark - HWComposeToolbarDelegate
//- (void)composeToolbar:(HWComposeToolbar *)toolbar didClickButton:(HWComposeToolbarButtonType)buttonType {
//    switch (buttonType) {
//        case HWComposeToolbarButtonTypeMention: { // @
//            NSLog(@"--- @");
//        }  break;
//        case HWComposeToolbarButtonTypeTrend:   // #
//            NSLog(@"--- #");
//            [self.view endEditing:YES];
//            break;
//        case HWComposeToolbarButtonTypeEmotion: // 表情\键盘
//            [self switchKeyboard]; break;
//        case HWComposeToolbarButtonTypeSend: {  // 发送
//            [self sendBtnClick];
//        } break;
//    }
//}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnClick];
    }
//    else if ([text isEmoji]) {
//        // [self showInfo:@"暂不支持输入法中的表情噢"];
//        return (self.uid.integerValue == 626 || self.uid.integerValue == 5 || self.uid.integerValue == 601 || self.uid.integerValue == 599);
//    }
    return YES;
}

- (void)sendBtnClick {
   
    
    
}

- (void)refreshTableView {
}

#pragma mark - 私有方法

/// 切换键盘
- (void)switchKeyboard {
    // self.textView.inputView == nil : 使用的是系统自带的键盘
   
}

//- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self saveTextViewAttriText];
//}
//
//- (void)saveTextViewAttriText {
//    [mUserDefaults setObject:self.textView.fullTextWithID forKey:self.key];
//    [mUserDefaults synchronize];
//}

#pragma mark - 私有方法

- (void)showInputTextViewWithTipTitle:(NSString *)tipTitle inputType:(InputType)inputType {
    if ([TZUserManager isLogin]) {
        _noDismissKeyboard = YES;
        self.inputType = inputType;
        self.textView.placeholder = tipTitle;
        
        [self.textView becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _noDismissKeyboard = NO;
        });
    }
}

@end
