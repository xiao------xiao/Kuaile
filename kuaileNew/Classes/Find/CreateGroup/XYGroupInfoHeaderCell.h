//
//  XYGroupInfoHeaderCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYGroupInfoModel;

@interface XYGroupInfoHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgAvatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *avatarContentView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (nonatomic, copy) void (^didChangeBgAvatarBlock)();
@property (nonatomic, copy) void (^didChangeAvatarBlock)();

@property (nonatomic, strong) XYGroupInfoModel *model;

@end
