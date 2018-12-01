//
//  TZBottomToolBar.h
//  kuaile
//
//  Created by liujingyi on 15/9/18.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZBottomToolBarButtonTypeLeft = 1,
    TZBottomToolBarButtonTypeMiddle,
    TZBottomToolBarButtonTypeRight,
} TZBottomToolBarButtonType;

// 这里改用通知了,代理不用了
@class TZBottomToolBar;
@protocol  TZBottomToolBarDelegate<NSObject>
- (void)toolBarDidClickButton:(TZBottomToolBarButtonType)buttonType button:(UIButton *)button;
@end

@interface TZBottomToolBar : UIView
@property (nonatomic, assign) id<TZBottomToolBarDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *midBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@end
