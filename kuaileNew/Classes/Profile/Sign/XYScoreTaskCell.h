//
//  XYScoreTaskCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYPointTaskSingleModel;

typedef NS_ENUM(NSInteger, XYScoreTaskCellType) {
    XYScoreTaskCellTypeButton,
    XYScoreTaskCellTypeLabe,
    XYScoreTaskCellTypeButtonDoing,
    XYScoreTaskCellTypeButtonDone,
};

@interface XYScoreTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;

@property (nonatomic, assign) XYScoreTaskCellType type;
@property (nonatomic, assign) BOOL isRewardBtn;
@property (nonatomic, strong) XYPointTaskSingleModel *model;

@property (nonatomic, copy) void (^receiveRewardBlock)();

@end
