//
//  TZInputBaseCell.h
//  yishipi
//
//  Created by ttouch on 16/10/14.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZBaseCell.h"

@interface TZInputBaseCell : TZBaseCell

@property (nonatomic, strong) UITextField *textFeild;
@property (nonatomic, assign) NSInteger titleW;

/// 需要在右边显示一个Lable
@property (nonatomic, strong) UILabel *rightLable;
@property (nonatomic, assign) NSInteger rightLableW;
@property (nonatomic, assign) NSInteger rightLableH;
@property (nonatomic, assign) BOOL showRightLable;

@property (nonatomic, copy) void (^didTextChangeBlock)(NSString *text);

@end
