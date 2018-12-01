//
//  XYSearchNaviView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSearchNaviView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityBtnConstraintW;

@end
