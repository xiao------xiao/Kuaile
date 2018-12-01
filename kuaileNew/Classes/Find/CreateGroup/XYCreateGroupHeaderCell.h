//
//  XYCreateGroupHeaderCell.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCreateGroupHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avaterView;

@property (nonatomic, copy) void (^didClickAvaterViewBlock)();
@end
