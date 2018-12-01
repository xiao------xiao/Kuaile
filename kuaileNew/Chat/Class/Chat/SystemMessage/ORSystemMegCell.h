//
//  ORSystemMegCell.h
//  kuaile
//
//  Created by 欧阳荣 on 2017/3/28.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYMessageModel;

@interface ORSystemMegCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tintImage;
@property (weak, nonatomic) IBOutlet UILabel *timeMLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)loadModelData:(XYMessageModel *)model;


@end
