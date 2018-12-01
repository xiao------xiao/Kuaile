//
//  TZBaseCell.m
//  yishipi
//
//  Created by ttouch on 16/9/26.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZBaseCell.h"

@implementation TZBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configSubviews];
        
        self.titleH = 25;
        self.subTitleH = 20;
        self.titleTop = 10;
    }
    return self;
}

- (void)configSubviews {
    [self configImgView];
    [self configTitleLable];
    [self configSubtitleLable];
}

- (void)configImgView {
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.image = [UIImage imageNamed:@"xiaoxi_linlifuwu"];
    self.imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
}

- (void)configTitleLable {
    _titleLable = [[UILabel alloc] init];
    _titleLable.numberOfLines = 0;
    _titleLable.textColor = TZColorRGB(44);
    _titleLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLable];
}

- (void)configSubtitleLable {
    _subTitleLable = [[UILabel alloc] init];
    _subTitleLable.textColor = TZColorRGB(128);
    _subTitleLable.font = [UIFont systemFontOfSize:13];
    _subTitleLable.numberOfLines = 0;
    _subTitleLable.clipsToBounds = YES;
    [self.contentView addSubview:_subTitleLable];
}

- (void)setCellType:(TZBaseCellType)cellType {
    _cellType = cellType;
    switch (cellType) {
        case TZBaseCellTypeNormal: {
            
        } break;
        case TZBaseCellTypeLable: {
            _subTitleLable.textAlignment = NSTextAlignmentRight;
            _subTitleLable.font = [UIFont systemFontOfSize:15];
        } break;
        case TZBaseCellTypeDoubleLable: {
            [self configCenterLable];
            _subTitleLable.textAlignment = NSTextAlignmentCenter;
        } break;
        case TZBaseCellTypeAvatar: {
            [self configAvatarImageView];
        } break;
        case TZBaseCellTypeSwitch: {
            [self configSwitchView];
        } break;
        default:  break;
    }
}

- (void)configCenterLable {
    _centerLable = [[UILabel alloc] init];
    _centerLable.font = [UIFont systemFontOfSize:15];
    _centerLable.textColor = TZColorRGB(128);
    _centerLable.textAlignment = NSTextAlignmentCenter;
    _centerLable.clipsToBounds = YES;
    [self.contentView addSubview:_centerLable];
}

- (void)configSwitchView {
    _switchView = [[UISwitch alloc] init];
    [self.contentView addSubview:_switchView];
}

- (void)configAvatarImageView {
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    self.avatarImageW = 60;
    self.avatarImageCircular = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_imgViewWidth) _imgViewWidth = self.height - 20;
    if (_hideImgView) _imgViewWidth = 0;
    _imgView.frame = CGRectMake(12, (self.height - _imgViewWidth) / 2, _imgViewWidth, _imgViewWidth);
    
    CGFloat maxImgViewX = CGRectGetMaxX(_imgView.frame);
    if (_imgViewWidth == 0) {
        maxImgViewX = 12;
    }
    
    if (self.hideSubTitleLable) {
        _titleH = self.height - 20;
        _subTitleH = 0;
        _titleTop = (self.height - _titleH) / 2;
    }
    
    NSInteger selfWidth = self.accessoryType == UITableViewCellAccessoryNone ? self.width : self.width - 25;
    switch (self.cellType) {
        case TZBaseCellTypeNormal: {
            _titleLable.frame = CGRectMake(maxImgViewX + 10, _titleTop, selfWidth - maxImgViewX - 20, _titleH);
            _subTitleLable.frame = CGRectMake(_titleLable.mj_x, self.height - _subTitleH - 10, _titleLable.width, _subTitleH);
        } break;
        case TZBaseCellTypeLable: {
            NSInteger lableW = (selfWidth - maxImgViewX - 20) / 2;
            if (self.subTitleLableW) {
                lableW = lableW + lableW - self.subTitleLableW;
            }
            _titleLable.frame = CGRectMake(maxImgViewX + 10, 0, lableW, self.height);
            _subTitleLable.frame = CGRectMake(CGRectGetMaxX(_titleLable.frame), 0, self.subTitleLableW ? self.subTitleLableW : lableW, self.height);
        } break;
        case TZBaseCellTypeDoubleLable: {
            NSInteger lableW = (selfWidth - maxImgViewX - 30) / 3;
            _titleLable.frame = CGRectMake(maxImgViewX + 10, 0, lableW, self.height);
            _centerLable.frame = CGRectMake(CGRectGetMaxX(_titleLable.frame), 0, lableW, self.height);
            lableW = self.subTitleLableW ? self.subTitleLableW : lableW;
            _subTitleLable.frame = CGRectMake(selfWidth - 10 - lableW, self.height / 2 - 10, lableW, 20);
        } break;
        case TZBaseCellTypeAvatar: {
            _titleLable.frame  = CGRectMake(10, 0, 200, 40);
            
//            _titleLable.frame = CGRectMake(maxImgViewX + 10, 0, selfWidth - maxImgViewX - 20, self.height);
            _avatarImageView.frame = CGRectMake(selfWidth - 10 - self.avatarImageW, (self.height - self.avatarImageW) / 2, self.avatarImageW, self.avatarImageW);
            if (self.avatarImageCircular) {
                _avatarImageView.layer.cornerRadius = self.avatarImageW / 2;
            }
        } break;
        case TZBaseCellTypeSwitch: {
            _titleLable.frame = CGRectMake(maxImgViewX + 10, 0, selfWidth - maxImgViewX - 20, self.height);
            self.accessoryView = self.switchView;
        } break;
        default:  break;
    }
}

- (void)setHideSubTitleLable:(BOOL)hideSubTitleLable {
    _hideSubTitleLable = hideSubTitleLable;
    _subTitleLable.hidden = hideSubTitleLable;
    [self setNeedsLayout];
}

@end
