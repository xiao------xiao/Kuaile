//
//  XYJobCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZJobModel;


@interface XYJobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelConstraint;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnHConstraint;

@property (nonatomic, strong) TZJobModel *model;

@property (nonatomic, copy) void (^didClickDeleteBtnBlock)();

@end
