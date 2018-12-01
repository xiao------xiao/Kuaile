//
//  TZAddFriendCell.h
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYRecommendFriendModel;


typedef NS_ENUM(NSInteger, TZAddFriendCellType) {
    TZAddFriendCellTypeNoAttention,
    TZAddFriendCellTypeSingleAttention,
    TZAddFriendCellTypeBothAttention,
    TZAddFriendCellTypeAgreenAttention,
};


@interface TZAddFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreView;
@property (nonatomic, copy) void (^didAttentionBlock)();
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstrain;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelConstraintW;


@property (nonatomic, assign) TZAddFriendCellType type;

@property (nonatomic, strong) XYRecommendFriendModel *recommendFriendMode;

@end
