//
//  BaseViewController.h
//  housekeep
//
//  Created by 一盘儿菜 on 16/5/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYShowCallView.h";

@class TZPopSelectView,TZDatePickerView,XYUserInfoModel,TZProductModel,TZPopHintView,MPMoviePlayerViewController;
@interface TZBaseViewController : UIViewController

@property (nonatomic, assign) BOOL netFlag;

@property (nonatomic, strong) XYUserInfoModel *userModel;

@property (nonatomic, strong) XYShowCallView *callView;

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *leftNavImageName;
@property (nonatomic, copy) NSString *rightNavImageName;
@property (nonatomic, copy) NSString *leftNavTitle;
@property (nonatomic, copy) NSString *rightNavTitle;

- (void)didClickLeftNavAction;
- (void)didClickRightNavAction;
- (void)showSelectSendTime:(void(^)(NSString *time))time;
- (void)showPhotoBrowseWithImages:(NSArray *)images index:(NSInteger)index;

/// 倒计时
- (void)countDown:(id)view;
- (void)countDown:(id)view enableBorderColor:(UIColor *)color1 disableBorderColor:(UIColor *)color2 enableTextColor:(UIColor *)textColor1 disableTextColor:(UIColor *)textColor2;

/// 数据选择器
@property (nonatomic, strong) TZPopSelectView *popSelectView;
@property (nonatomic, assign) BOOL needPopSelectView;
/// 时间选择器
@property (nonatomic, strong) TZDatePickerView *datePicker;
@property (nonatomic, assign) BOOL needDatePicker;
@property (nonatomic, strong) UIButton *cover;
//放出dataPickerView；
-(void)showDataPickerView;
- (void)coverBtnClick;
// 播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerVc;
- (void)mediaPlayerPlaybackStateChange;

/// 跳转到网页
- (void)pushWebVcWithUrl:(NSString *)url title:(NSString *)title;
- (void)pushWebVcWithFilename:(NSString *)filename title:(NSString *)title;
- (void)pushWebVcWithUrl:(NSString *)url shareImage:(id)shareImage title:(NSString *)title content:(NSString *)content;

- (void)didUpdateMemberInfo;


/// 环信
@property (nonatomic, copy) NSString *buddyName;
- (void)checkAttentionStatusWithBuddyName:(NSString *)buddyName;


@end
