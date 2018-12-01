//
//  XYProfileView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYSalaryUserModel;

@interface XYProfileView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@property (nonatomic, strong) XYSalaryUserModel *model;

@end
