//
//  TZJobContactCell.h
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZJobContactCellButtonCall = 1, // 打电话
    TZJobContactCellButtonMail,     // 发邮件
} TZJobContactCellButtonType;

@class TZJobContactCell,TZJobModel;
@protocol TZJobContactCellDelegate <NSObject>
- (void)contactCellDidClickButton:(TZJobContactCellButtonType)type;
@end

@interface TZJobContactCell : UIView
@property (nonatomic, assign) TZJobContactCellButtonType type;
@property (nonatomic, assign) id<TZJobContactCellDelegate> delegate;
@property (nonatomic, strong) TZJobModel *model;
@property (strong, nonatomic) IBOutlet UILabel *contact_name;
@property (strong, nonatomic) IBOutlet UILabel *contact_tel;
@end
