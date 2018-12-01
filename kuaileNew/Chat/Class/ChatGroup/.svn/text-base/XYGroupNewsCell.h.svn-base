//
//  XYGroupNewsCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/4.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYRecommendFriendModel;

@interface XYGroupNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsName;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIImageView *groupAvatar;
@property (weak, nonatomic) IBOutlet UILabel *peopleName;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@property (nonatomic, strong) XYRecommendFriendModel *model;

@property (nonatomic, copy) void (^doGroupNewsBlock)(BOOL isAgreen);

@end
