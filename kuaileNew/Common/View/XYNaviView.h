//
//  XYNaviView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/4/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYNaviView : UIView

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *rightBarbtnNormalTitle;
@property (nonatomic, copy) NSString *rightBarbtnSelectedTitle;
@property (nonatomic, copy) NSString *rightImage;
@property (nonatomic, strong) UIButton *rightBarbutton;

@property (nonatomic, copy) void (^didClickBackBtnBlock)();
@property (nonatomic, copy) void (^didClickRightBarBtnBlock)(BOOL selected);

@end
