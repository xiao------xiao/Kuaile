//
//  TZResumeRootController.h
//  kuaile
//
//  Created by liujingyi on 15/9/24.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZPopSelectView.h"
#import "TZDatePickerView.h"
#import "TZResumeRootCell.h"

@interface TZResumeRootController : TZBaseViewController

#pragma mark 公共属性

/** datePickerView相关 */
@property (nonatomic, weak) TZDatePickerView *datePickerView;
/** tableView相关 */
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles1;
@property (nonatomic, strong) NSArray *cellTitles2;
@property (nonatomic, strong) NSArray *cellTitles3;
@property (nonatomic, strong) NSArray *cellTitles4;
@property (nonatomic, strong) NSArray *cellTitles5;
@property (nonatomic, strong) NSArray *cellTitles6;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles1;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles2;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles3;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles4;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles5;
@property (nonatomic, strong) NSMutableArray *cellDetailTitles6;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
/** selectView相关 */
@property (nonatomic, weak) TZPopSelectView *selectView;
//@property (nonatomic, strong) UIButton *cover;
/** 其他属性 */
@property (nonatomic, assign) NSInteger number;

#pragma mark 公共方法

/** 设置cell.detailTitle的外观 */
- (void)configCell:(TZResumeRootCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)configTableView;
- (void)configDatePickerView;
// 弹出选择框相关
- (void)showSelectViewWithYears;
- (void)showPopSelectViewWithArray:(NSArray *)options;
- (void)coverClick;
// 选择框代理方法 TZPopselectViewDelegate
- (void)popSelectViewDidClickCancleButton;
- (void)popSelectViewDidSelectedCell:(NSString *)cellName index:(NSInteger)index;
// datePickerView相关
- (void)showDatePickerView;
// TZDatePickerViewDelegate
- (void)datePickerViewDidClickCancleButton;
- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker;
// 私有方法
- (void)refreshCellDetailNamesWith:(NSString *)name;
// 按钮的点击方法
- (void)done;
- (void)showAlertView;
@end





