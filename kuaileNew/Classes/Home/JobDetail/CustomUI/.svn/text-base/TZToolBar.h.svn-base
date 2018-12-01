//
//  TZToolBar.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZButton.h"

// 按钮类型，左边按钮和右边按钮
typedef enum : NSUInteger {
    ToolBarButtonTypeLeft,
    ToolBarButtonTypeRight,
} ToolBarButtonType;

// 协议，按钮被点击时要做的事情
@class TZToolBar;
@protocol TZToolBarDelegate <NSObject>
@optional
- (void)toolBar:(TZToolBar *)toolBar didClickButtonWithType:(ToolBarButtonType)buttonType;
@end

@interface TZToolBar : UIView
@property (strong, nonatomic) IBOutlet TZButton *leftBtn;
@property (strong, nonatomic) IBOutlet TZButton *rightBtn;

@property (strong, nonatomic) IBOutlet UIView *leftTipView;
@property (strong, nonatomic) IBOutlet UIView *rightTipView;

@property (nonatomic, assign) id<TZToolBarDelegate> delegate;

+ (instancetype)toolBar;

@property (nonatomic, assign) BOOL showLeftBtn; // 显示左边按钮的tipView
@property (nonatomic, assign) BOOL showRightBtn; // 显示右边按钮的tipView

@end
