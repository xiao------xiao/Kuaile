//
//  XYSlideNavView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSlideNavView : UIView
@property (nonatomic, strong) UIButton *forwardBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy) void (^didClickBackBtnBlock)();
@property (nonatomic, copy) void (^didClickForwardBtnBlock)();

@end
