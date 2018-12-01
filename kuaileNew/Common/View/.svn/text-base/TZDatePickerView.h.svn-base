//
//  TZDatePickerView.h
//  kuaile
//
//  Created by liujingyi on 15/9/22.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

// 协议方法 通知外界取消、确定按钮的点击
@class TZDatePickerView;
@protocol  TZDatePickerViewDelegate<NSObject>
- (void)datePickerViewDidClickCancleButton;
- (void)datePickerViewDidClickUntilNowButton;
- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker;
@end

@interface TZDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIButton *untilNowButton;
@property (nonatomic, assign) id<TZDatePickerViewDelegate> delegate;
@end
