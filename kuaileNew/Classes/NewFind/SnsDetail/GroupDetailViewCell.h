//
//  GroupDetailViewCell.h
//  kuaile
//
//  Created by 胡光健 on 2017/3/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GroupDetailViewCellType) {
    GroupDetailViewCellTypelocation,
    GroupDetailViewCellTypelabName,
    GroupDetailViewCellTypegroupNum,
};
@protocol  GroupDetailViewCellDelegate<NSObject>
- (void)GroupDetailViewCellDelegate:(NSInteger)tag;
@end

@class HJGroupDetailModel;
@interface GroupDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *swith;
@property (weak, nonatomic) IBOutlet UILabel *groupNum;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *groupLocation;
@property (weak, nonatomic) IBOutlet UIButton *groupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPeople;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchLayout;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (nonatomic, assign) GroupDetailViewCellType type;
@property (nonatomic, assign) id<GroupDetailViewCellDelegate> delegate;
@end
