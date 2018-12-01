//
//  XYContactCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/6/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XYContactCellType) {
    XYContactCellTypeAdd,
    XYContactCellTypeAddDone,
};

@class XYContactModel;

@interface XYContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) XYContactModel *model;
@property (nonatomic, assign) XYContactCellType type;

@property (nonatomic, copy) void (^didClickAddBtnBlock)();

@end
