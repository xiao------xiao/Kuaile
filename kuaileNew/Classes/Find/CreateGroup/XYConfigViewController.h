//
//  XYConfigViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZBaseViewController.h"

typedef NS_ENUM(NSInteger, XYConfigViewControllerType) {
    XYConfigViewControllerTypeTextField,
    XYConfigViewControllerTypeTextView,
    XYConfigViewControllerTypeTableView,
    XYConfigViewControllerTypeTableViewWithSaveRightItem,
};

@interface XYConfigViewController : TZBaseViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *placeText;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, assign) XYConfigViewControllerType type;

@property (nonatomic, copy) void (^didClickConformBtnBlock)(NSString *text);

@property (nonatomic, copy) void (^didSelecteTableViewRowBlock)(NSString *text, NSInteger selRow, BOOL didClickTableView);

@property (nonatomic, copy) void (^didClickSaveBtnBlick)(NSString *title,NSString *laidStr, NSArray *selModels);
/// 选中的row
@property (nonatomic, assign) NSInteger selRow;
/// 是否选中过
@property (nonatomic, assign) BOOL didClickTableView;
/// 选中的数据模型
@property (nonatomic, strong) NSArray *selectedModels;

@end
