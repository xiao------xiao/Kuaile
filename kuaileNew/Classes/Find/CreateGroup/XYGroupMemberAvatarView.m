//
//  XYGroupMemberAvatarView.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/4.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYGroupMemberAvatarView.h"
#import "XYGroupInfoModel.h"

@interface XYGroupMemberAvatarView()

@property (nonatomic, strong) NSMutableArray *imgs;
//@property (nonatomic, strong) NSMutableArray *allImgs;

@property (nonatomic, assign) CGFloat totalHeight;

@end

@implementation XYGroupMemberAvatarView

- (NSMutableArray *)imgs {
    if (_imgs == nil) {
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.haveAddAvatar = NO;
    }
    return self;
}

- (void)setHaveAddAvatar:(BOOL)haveAddAvatar {
    _haveAddAvatar = haveAddAvatar;
}

- (void)setAvatars:(NSArray *)avatars {
    _avatars = avatars;
    for (int i = 0; i < avatars.count; i++) {
        UIButton *btn = [self createdAvatarView:i];
        btn.tag = i;
        [btn addTarget:self action:@selector(avatarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        XYGroupMemberModel *model = avatars[i];
        if (self.haveAddAvatar) {
            if (i >= avatars.count - 2) {
                [btn setImage:[UIImage imageNamed:model.avatar] forState:UIControlStateNormal];
            } else {
                [btn sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) forState:UIControlStateNormal placeholderImage:TZPlaceholderAvaterImage];
            }
        } else {
            [btn sd_setImageWithURL:TZImageUrlWithShortUrl(model.avatar) forState:UIControlStateNormal placeholderImage:TZPlaceholderAvaterImage];
        }
    }
}

- (UIImageView *)createdAvatarView:(NSInteger)tag {
    UIButton *avatarView;
    if (tag < self.imgs.count) {
        avatarView = self.imgs[tag];
    } else {
        avatarView = [[UIButton alloc] init];
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.layer.cornerRadius = 18;
        avatarView.clipsToBounds = YES;
        [self.imgs addObject:avatarView];
        [self.contentView addSubview:avatarView];
    }
    return avatarView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imgW = 36;
    CGFloat imgH = imgW;
    CGFloat margin = 10;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    NSInteger row = 0;
    NSInteger loc = 0;
    for (int i = 0; i < self.imgs.count; i++) {
        UIButton *imgView = self.imgs[i];
        imgX = margin + (imgW + margin) * loc;
        if (imgX + imgW >= self.width) {
            row += 1;
            loc = 0;
            imgX = margin + (imgW + margin) * loc;
        }
        loc += 1;
        imgY = margin + (imgH + margin) * row;
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        if (i == self.imgs.count - 1) {
            self.totalHeight = imgY + imgH + margin;
        }
    }
}

- (void)avatarBtnClick:(UIButton *)btn {
    XYUserInfoModel *model = self.avatars[btn.tag];
    if (self.didClickAddAvatarBlock) {
        self.didClickAddAvatarBlock(model);
    }
}


- (CGFloat)tableView:(UITableView *)tableView cellHeightForAtIndexPath:(NSIndexPath *)indexPath {
    return self.totalHeight;
}

@end
