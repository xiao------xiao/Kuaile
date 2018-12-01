//
//  ICEMySelfHeadTableViewCell.h
//  hxjjyh
//
//  Created by ttouch on 15/8/25.
//  Copyright (c) 2015年 陈冰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYUserInfoModel;

@interface ICEMySelfHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *commissionLbl;
@property (weak, nonatomic) IBOutlet UILabel *labPoints;
@property (weak, nonatomic) IBOutlet UIButton *QRcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *vertifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vertifyTextW;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn;
@property (weak, nonatomic) IBOutlet UIButton *commissionBtn;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;


@property (nonatomic, strong) XYUserInfoModel *model;

@property (nonatomic, copy) void (^didCheckCodeBlock)();
@property (nonatomic, copy) void (^didClickVertifyBtnBlock)(NSString *text);

@property (nonatomic, copy) void (^didClickHeaderBtnsBlock)(NSInteger tag);

@end
