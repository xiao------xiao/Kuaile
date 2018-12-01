//
//  XYJobExperienceCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/3/2.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZJobExpModel;

@interface XYJobExperienceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewConstraintH;

@property (nonatomic, strong) TZJobExpModel *model;

@end
