//
//  ICEHeadTableViewCell.h
//  hxjj
//
//  Created by ttouch on 15/7/20.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYUserInfoModel;

@interface ICEHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *imgHeadBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *careText;
@property (weak, nonatomic) IBOutlet UILabel *fanText;
@property (weak, nonatomic) IBOutlet UILabel *tieText;

@property (weak, nonatomic) IBOutlet UILabel *careNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *fanBtn;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIButton *tieBtn;
@property (weak, nonatomic) IBOutlet UILabel *tiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *distance_timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopMarginConstraintH;


@property (nonatomic, copy) void (^blockEditHeadImg)();
@property (nonatomic, copy) void (^didClickChangeBtnBlock)();
@property (nonatomic, copy) void (^didClickAttentionBtnBlock)();
@property (nonatomic, copy) void (^didClickCoverBtnBlock)();
@property (nonatomic, copy) void (^didClickTieBtnBlock)();
@property (nonatomic, copy) void (^didClickFanBtnBlock)();

@property (nonatomic, strong) XYUserInfoModel *model;

@end
