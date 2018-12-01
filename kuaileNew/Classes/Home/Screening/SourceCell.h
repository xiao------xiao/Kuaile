//
//  SourceCell.h
//  kuaile
//
//  Created by 胡光健 on 2017/3/6.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickedBlock)(int index);


@interface SourceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *quanbuButton;
@property (weak, nonatomic) IBOutlet UIButton *kaixinzhizhaoButton;
@property (weak, nonatomic) IBOutlet UIButton *qiyezhizhaoButton;
@property (weak, nonatomic) IBOutlet UIButton *daizhaoButton;

@property (copy,nonatomic) ButtonClickedBlock buttonBlock;

@property(nonatomic,copy)NSString *originStr;//初始化来源
@end
