//
//  XYSignHomeHeader.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/16.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSignHomeHeader : UIView

@property (nonatomic, copy) void (^didClickSignBtnBlock)();
@property (nonatomic, copy) void (^didClickTaskBtnBlock)();
@property (nonatomic, copy) void (^didClickDetailBtnBlock)();

@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *tips;


@end
