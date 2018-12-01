//
//  HJZanListCell.h
//  kuaile
//
//  Created by 胡光健 on 2017/3/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HJZanListCellType) {
    HJZanListCellTypeNoAttention,
    HJZanListCellTypeAttention,
};

@class HJZanListModel;
@interface HJZanListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UIButton *focousBtn;

@property (nonatomic, strong) HJZanListModel * model;
@property (assign, nonatomic) HJZanListCellType type;
@property (copy, nonatomic) void (^didClickAttentionBtnBlock)();
@end
