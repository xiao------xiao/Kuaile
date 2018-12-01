//
//  XYResumeListCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/21.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZResumeModel;

@interface XYResumeListCell : UITableViewCell

@property (nonatomic, copy) void (^didClickEditBlock)();
@property (nonatomic, copy) void (^didClickSettingBlock)(UIButton *btn);
@property (nonatomic, copy) void (^didClickDeleteBlock)();
@property (nonatomic, copy) void (^didClickPreviewBlock)();

@property (nonatomic, strong) TZResumeModel *model;

@end
