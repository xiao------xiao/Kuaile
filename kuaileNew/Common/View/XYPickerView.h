//
//  XYPickerView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYPickerView;

typedef NS_ENUM(NSInteger, XYPickerViewType) {
    XYPickerViewTypeCover,
    XYPickerViewTypeNoCover,
};

@protocol XYPickerViewDelegate <NSObject>

@optional

- (void)pickerView:(XYPickerView *)pickerView didClickFinishButtonWithSelectedRow:(NSInteger)selectedRow;

@end


@interface XYPickerView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL haveCover;
@property (nonatomic, assign) XYPickerViewType type;

- (instancetype)initWithPickerType:(XYPickerViewType)type;



@end
