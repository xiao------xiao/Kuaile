//
//  BaseViewController.m
//  housekeep
//
//  Created by 一盘儿菜 on 16/5/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZBaseViewController.h"
#import "YYPhotoGroupView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XYShowCallView.h"
#import "XYFriendModel.h"

@interface TZBaseViewController ()<TZPopSelectViewDelegate,TZDatePickerViewDelegate,UIAlertViewDelegate>
@end

@implementation TZBaseViewController

- (XYShowCallView *)callView {
    if (_callView == nil) {
        _callView = [[XYShowCallView alloc] init];
        _callView.frame = self.view.bounds;
        _callView.backgroundColor = [UIColor clearColor];
        __weak typeof(_callView) weak_callview = _callView;
        
        [_callView setCoverClickBlock:^{
            weak_callview.hidden = YES;
        }];
        [[_callView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weak_callview.hidden = YES;
        }];
        [[_callView.callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [UIWebView webViewWithNumber:@""];
        }];
        [self.view addSubview:_callView];
    }
    return _callView;
}

- (UIButton *)cover {
    if (_cover == nil) {
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor lightGrayColor];
        cover.alpha = 0.4;
        cover.frame = CGRectMake(0, 0, __kScreenWidth, __kScreenHeight);
        cover.hidden = YES;
        [cover addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cover];
        _cover = cover;
    }
    return _cover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TZControllerBgColor;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.userModel = [TZUserManager getUserModel];
    [mNotificationCenter addObserver:self selector:@selector(didUpdateMemberInfo) name:@"didUpdateMemberInfo" object:nil];
}

- (void)didUpdateMemberInfo {
    self.userModel = [TZUserManager getUserModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.navigationItem.title = navTitle;
}

- (void)setLeftNavTitle:(NSString *)leftNavTitle {
    _leftNavTitle = leftNavTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftNavTitle style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftNavAction)];
}

- (void)setRightNavTitle:(NSString *)rightNavTitle {
    _rightNavTitle = rightNavTitle;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightNavTitle style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightNavAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)setRightNavImageName:(NSString *)rightNavImageName {
    _rightNavImageName = rightNavImageName;
    UIImage *image = [[UIImage imageNamed:rightNavImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightNavAction)];
}

- (void)setLeftNavImageName:(NSString *)leftNavImageName {
    _leftNavImageName = leftNavImageName;
    UIImage *image = [UIImage imageNamed:leftNavImageName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftNavAction)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/// 数据选择器
- (void)setNeedPopSelectView:(BOOL)needPopSelectView {
    _needPopSelectView = needPopSelectView;
    if (needPopSelectView) {
        self.popSelectView = [[TZPopSelectView alloc] init];
        self.popSelectView.hidden = YES;
        self.popSelectView.delegate = self;
        self.popSelectView.labTitle.backgroundColor = TZMainColor;
        [self.cover class];
        [self.view addSubview:self.popSelectView];
    }
}
-(void)showDataPickerView{
    [self.view bringSubviewToFront:self.cover];
    [self.view bringSubviewToFront:self.datePicker];
    self.datePicker.hidden = NO;
    self.cover.hidden = NO;
}
/// 时间选择器
- (void)setNeedDatePicker:(BOOL)needDatePicker {
    _needDatePicker = needDatePicker;
    if (needDatePicker) {
        _datePicker = [[TZDatePickerView alloc] init];
        NSInteger top = (mScreenHeight - 200) / 2 - 64;
        _datePicker.frame = CGRectMake(30, top, __kScreenWidth - 60, 200);
        _datePicker.hidden = YES;
        _datePicker.delegate = self;
        [self.cover class];
        [self.view addSubview:self.datePicker];
    }
}

#pragma mark - 点击事件

- (void)coverBtnClick {
    _cover.hidden = YES;
    self.popSelectView.hidden = YES;
    self.datePicker.hidden = YES;
    
    _cover.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - 公共方法

- (void)showSelectSendTime:(void (^)(NSString *))time {
    
}

- (void)didClickLeftNavAction {
    
}

- (void)didClickRightNavAction {
    
}

- (void)showPhotoBrowseWithImages:(NSArray *)images index:(NSInteger)index {
    NSMutableArray *items = [NSMutableArray new];
    for (NSUInteger i = 0, max = images.count; i < max; i++) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        id image = images[i];
        if ([image isKindOfClass:[NSURL class]]) {
            item.largeImageURL = image;
        } else if ([image isKindOfClass:[NSString class]]) {
            item.largeImageURL = [NSURL URLWithString:image];
        }
        [items addObject:item];
    }
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:nil toContainer:self.tabBarController.view index:index animated:YES completion:nil];
}

/// 倒计时
- (void)countDown:(id)view {
    [self countDown:view enableBorderColor:TZMainColor disableBorderColor:TZColorRGB(166) enableTextColor:TZColorRGB(44) disableTextColor:TZColorRGB(166)];
}

- (void)countDown:(id)view enableBorderColor:(UIColor *)color1 disableBorderColor:(UIColor *)color2 enableTextColor:(UIColor *)textColor1 disableTextColor:(UIColor *)textColor2 {
    UIButton *btn;
    UILabel *label;
    if ([view isKindOfClass:[UIButton class]]) {
        btn = (UIButton *)view;
    } else if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *)view;
    } else {
        return;
    }
    __block NSInteger timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([view isKindOfClass:[UIButton class]]) {
                if (timeout <= 0) {
                    // 倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    if (btn) {
                        btn.userInteractionEnabled = YES;
                        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        btn.layer.borderColor = color1.CGColor;
                        [btn setTitleColor:textColor1 forState:UIControlStateNormal];
                    } else {
                        label.text = @"获取验证码";
                        label.layer.borderColor = color1.CGColor;
                        label.textColor = textColor1;
                    }
                } else {
                    NSString *timeStr = [NSString stringWithFormat:@"%.2ld秒后重发",(long)timeout];
                    if (btn) {
                        btn.userInteractionEnabled = NO;
                        [btn setTitle:timeStr forState:UIControlStateNormal];
                        btn.layer.borderColor = color2.CGColor;
                        [btn setTitleColor:textColor2 forState:UIControlStateNormal];
                    } else {
                        label.text = timeStr;
                        label.layer.borderColor = color2.CGColor;
                        label.textColor = textColor2;
                    }
                    timeout--;
                }
            }
            
        });
    });
    dispatch_resume(_timer);
}

#pragma mark - TZPopSelectViewDelegate

- (void)popSelectViewDidClickCancleButton {
    [self coverBtnClick];
}

#pragma mark - TZDatePickerViewDelegate

- (void)datePickerViewDidClickCancleButton {
    [self coverBtnClick];
}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

/// 跳转到网页
- (void)pushWebVcWithUrl:(NSString *)url title:(NSString *)title {
    [self pushWebVcWithUrl:url shareImage:nil title:title content:nil];
}

- (void)pushWebVcWithFilename:(NSString *)filename title:(NSString *)title {
    TZWebViewController *vc = [TZWebViewController new];
    vc.navTitle = title;
    vc.filename = filename;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWebVcWithUrl:(NSString *)url shareImage:(id)shareImage title:(NSString *)title content:(NSString *)content {
    TZWebViewController *vc = [TZWebViewController new];
    vc.shareTitle = title;
    vc.shareContent = content;
    if ([url isKindOfClass:[NSURL class]]) {
        NSURL *shareUrl = (NSURL *)url;
        vc.url = shareUrl.absoluteString;
    } else {
        vc.url = url;
    }
    if ([shareImage isKindOfClass:[UIImage class]]) {
        vc.shareImage = shareImage;
    } else if ([shareImage isKindOfClass:[NSURL class]]) {
        NSURL *shareImageUrl = (NSURL *)shareImage;
        vc.shareImageUrlStr = shareImageUrl.absoluteString;
    } else if ([shareImage isKindOfClass:[NSString class]]) {
        vc.shareImageUrlStr = shareImage;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Get

- (MPMoviePlayerViewController *)moviePlayerVc {
    if (!_moviePlayerVc) {
        _moviePlayerVc = [[MPMoviePlayerViewController alloc] init];
        _moviePlayerVc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [mNotificationCenter addObserver:self selector:@selector(mediaTypesAvailable:) name:MPMovieMediaTypesAvailableNotification object:self.moviePlayerVc.moviePlayer];
        [mNotificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerVc.moviePlayer];
        [mNotificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerVc.moviePlayer];
        [mNotificationCenter addObserver:self selector:@selector(mediaPlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayerVc.moviePlayer];
    }
    return _moviePlayerVc;
}

#pragma mark - 通知方法



- (void)mediaTypesAvailable:(NSNotification *)notification {
    
}

- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    // 不允许转屏
    [mUserDefaults setObject:@"0" forKey:@"allowRotation"];
    [mUserDefaults synchronize];
}

/// 播放状态改变，注意播放完成时的状态是暂停
- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    [self mediaPlayerPlaybackStateChange];
}

- (void)mediaPlayerPlaybackStateChange {
    switch (self.moviePlayerVc.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            [mUserDefaults setObject:@"1" forKey:@"allowRotation"]; break;
        case MPMoviePlaybackStatePaused:
            [mUserDefaults setObject:@"0" forKey:@"allowRotation"];
            NSLog(@"暂停播放.");  break;
        case MPMoviePlaybackStateStopped:
            [mUserDefaults setObject:@"0" forKey:@"allowRotation"];
            NSLog(@"停止播放."); break;
        default:  break;
    }
    [mUserDefaults synchronize];
}

- (void)mediaPlayerLoadStateDidChange:(NSNotification *)notification {
    switch (self.moviePlayerVc.moviePlayer.loadState) {
        case MPMovieLoadStateStalled: {
            
        } break;
        case MPMovieLoadStateUnknown: {
            
        } break;
        case MPMovieLoadStatePlayable: {
            
        } break;
        case MPMovieLoadStatePlaythroughOK: {
            
        } break;
        default: break;
    }
    NSLog(@"%zd",self.moviePlayerVc.moviePlayer.loadState);
}


/// 环信  ---- 关注

- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName {
    
    self.buddyName = buddyName;
    
//    if ([self didBuddyExist:buddyName]) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), buddyName];
//        [EMAlertView showAlertWithTitle:message
//                                message:nil
//                        completionBlock:nil
//                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                      otherButtonTitles:nil];
//        
//    } else if([self hasSendBuddyRequest:buddyName]) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), buddyName];
//        [EMAlertView showAlertWithTitle:message
//                                message:nil
//                        completionBlock:nil
//                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                      otherButtonTitles:nil];
//    } else {
////        [self showMessageAlertView];
//        [self sendFriendApplyWithBuddyName:buddyName message:nil];
//    }
    
//    if ([self didBuddyExist:buddyName]) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), buddyName];
//        [EMAlertView showAlertWithTitle:message
//                                message:nil
//                        completionBlock:nil
//                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                      otherButtonTitles:nil];
//
//    } else {
//        
//    }
    [self sendFriendApplyWithBuddyName:buddyName message:nil];
}

//- (BOOL)hasSendBuddyRequest:(NSString *)buddyName {
//    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
//    for (EMBuddy *buddy in buddyList) {
//        if ([buddy.username isEqualToString:buddyName] &&
//            buddy.followState == eEMBuddyFollowState_NotFollowed &&
//            buddy.isPendingApproval) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (BOOL)didBuddyExist:(NSString *)buddyName {
    
//    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
//    for (EMBuddy *buddy in buddyList) {
//        if ([buddy.username isEqualToString:buddyName] &&
//            buddy.followState != eEMBuddyFollowState_NotFollowed) {
//            return YES;
//        }
//    }
//    return NO;
    
    // 根据后台数据进行判断
    NSArray *buddyList = [TZUserManager getUserFriends];
    for (XYRecommendFriendModel *buddy in buddyList) {
        if ([buddy.uid isEqualToString:buddyName]) {
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"saySomething", @"say somthing")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@",messageTextField.text];
        } else{
            messageStr = @"无";
        }
        [self sendFriendApplyWithBuddyName:self.buddyName message:messageStr];
    }
}

- (void)sendFriendApplyWithBuddyName:(NSString *)buddyName message:(NSString *)message {
    if (buddyName && buddyName.length > 0) {
        BOOL needShowMsg = YES;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        if ([CommonTools isMobileNumber:buddyName]) {
            params[@"buid"] = buddyName;
//            params[@"username"] = buddyName;
            needShowMsg = NO;
        } else {
            params[@"username"] = buddyName;
        }
        [TZHttpTool postWithURL:ApiSnsConcernUser params:params success:^(NSDictionary *result) {
            if (needShowMsg) {
                [self showSuccessHUDWithStr:result[@"msg"]];
            }
            [mNotificationCenter postNotificationName:@"didAddFriendNoti" object:nil];
            // 加好友添加积分
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            RACSignal *sign = [ICEImporter addFriendsIntegralWithParams:params];
        } failure:^(NSString *msg) {
        }];
    }
}



@end
