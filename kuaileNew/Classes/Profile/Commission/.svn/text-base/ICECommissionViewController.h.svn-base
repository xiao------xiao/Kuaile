//
//  ICECommissionViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICECommissionType) {
    ICECommissionTypeNormal,    // 第一次进入，没有审核过
    ICECommissionTypePassing,   // 正在进行审核
    ICECommissionTypeNoPass     // 审核未通过
};

typedef NS_ENUM(NSInteger, ICECommissionStyle) {
    ICECommissionStyleCommiss,  // 佣金
    ICECommissionStyleWage      // 工资
};

@interface ICECommissionViewController : TZBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *labFirstDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil commissionType:(ICECommissionType)type;

@property (nonatomic, assign) ICECommissionStyle style;

@end
