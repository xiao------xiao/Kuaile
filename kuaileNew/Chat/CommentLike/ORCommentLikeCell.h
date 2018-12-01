//
//  ORCommentLikeCell.h
//  kuaile
//
//  Created by 欧阳荣 on 2017/4/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYMessageModel;

@interface ORCommentLikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;


@property (nonatomic, strong) XYMessageModel *model;

@end
