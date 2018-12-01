//
//  TZJobListScreeningView.h
//  kuaile
//
//  Created by liujingyi on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZScreeningViewButtonTypeArea = 1, // 区域
    TZScreeningViewButtonTypeSalary,   // 薪资
    TZScreeningViewButtonTypeWelfare,  // 福利
    TZScreeningViewButtonTypeScreening,  // 筛选
    TZScreeningViewButtonTypeNone
} TZScreeningViewButtonType;

@class TZJobListScreeningView;
@protocol  TZJobListScreeningViewDelegate<NSObject>

- (void)screeningView:(TZJobListScreeningView *)screeningView didClickButtonType:(TZScreeningViewButtonType)type;

@end
@interface TZJobListScreeningView : UIView

@property (nonatomic, assign) id<TZJobListScreeningViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *areaBtn;
@property (strong, nonatomic) IBOutlet UIButton *salaryBtn;
@property (strong, nonatomic) IBOutlet UIButton *welfareBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;

@property (nonatomic, assign) BOOL hideTipsView;

@property (nonatomic, assign) BOOL upAreaMoreView;
@property (nonatomic, assign) BOOL upSalaryMoreView;
@property (nonatomic, assign) BOOL upWelfareMoreView;
@property (nonatomic, assign) BOOL upscreenTipView;

@property (nonatomic, assign) BOOL downMoreView;

@end
