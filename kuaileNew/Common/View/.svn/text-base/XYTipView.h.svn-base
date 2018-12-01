//
//  XYTipView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYTipView : UIView
@property (nonatomic, strong) UIColor *btnCoverBgColor;
@property (nonatomic, strong) UIColor *btnBgColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) CGFloat titleLeftEdge;
@property (nonatomic, assign) CGFloat imageRightEdge;

@property (nonatomic, assign) BOOL showShadow;
@property (nonatomic, assign) BOOL noCover;

@property (nonatomic, copy) void (^didClickCoverBtnBlock)();
@property (nonatomic, copy) void (^didClickBtnBlock)(NSInteger row);

- (void)configTipBtnsWithTitles:(NSArray *)titles images:(NSArray *)images;

@end
