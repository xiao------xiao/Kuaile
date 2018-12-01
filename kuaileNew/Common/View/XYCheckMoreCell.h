//
//  XYCheckMoreCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCheckMoreCell : UITableViewCell

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void (^didClickBtnBlock)();

@property (nonatomic, assign) BOOL handleImage;

- (void)configButtonWithImg:(NSString *)img text:(NSString *)text;

@end
