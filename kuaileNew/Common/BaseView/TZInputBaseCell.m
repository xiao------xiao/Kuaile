//
//  TZInputBaseCell.m
//  yishipi
//
//  Created by ttouch on 16/10/14.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZInputBaseCell.h"

@interface TZInputBaseCell ()
@end

@implementation TZInputBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configTextField];
        self.titleW = 80;
    }
    return self;
}

- (void)configTextField {
    self.hideImgView = YES;
    self.hideSubTitleLable = YES;
    
    self.textFeild = [[UITextField alloc] init];
    self.textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFeild.font = [UIFont systemFontOfSize:14];
    self.textFeild.textAlignment = NSTextAlignmentRight;
    [mNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.textFeild];
    [self.contentView addSubview:self.textFeild];
}

- (void)setShowRightLable:(BOOL)showRightLable {
    _showRightLable = showRightLable;
    if (showRightLable && !_rightLable) {
        _rightLable = [UILabel new];
        _rightLable.textAlignment = NSTextAlignmentRight;
        _rightLable.textColor = TZColorRGB(114);
        _rightLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_rightLable];
    }
    _rightLable.hidden = !showRightLable;
}

- (void)textDidChange {
    if (self.didTextChangeBlock) {
        self.didTextChangeBlock(self.textFeild.text);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLable.frame = CGRectMake(10, 10, self.titleW, self.height - 20);
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        self.textFeild.frame = CGRectMake(self.titleW + 20, 4, self.width - self.titleW - 30 - self.rightLableW, self.height - 8);
    } else {
        self.textFeild.frame = CGRectMake(self.titleW + 20, 4, self.width - self.titleW - 50 - self.rightLableW, self.height - 8);
    }
    self.rightLable.frame = CGRectMake(CGRectGetMaxX(_textFeild.frame), self.textFeild.mj_y, self.rightLableW, self.rightLableH ? self.rightLableH : self.textFeild.height);
}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

@end
