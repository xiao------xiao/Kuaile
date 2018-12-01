//
//  TZButtonCell.h
//  yishipi
//
//  Created by ttouch on 16/10/14.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZButtonCell : TZBaseCell

- (void)setGrayStyleWithTitle:(NSString *)title;
- (void)setTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(NSInteger)fontSize;

@property (nonatomic, assign) NSInteger buttonWH;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL isButtonAtRight;

@end



@interface TZImageCell : TZButtonCell
@property (nonatomic, assign) NSInteger topInset;
@property (nonatomic, assign) NSInteger bottomInset;
@end
