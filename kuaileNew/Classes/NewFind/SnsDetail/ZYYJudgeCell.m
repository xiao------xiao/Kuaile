//
//  ZYYJudgeCell.m
//  cgdream
//
//  Created by 一盘儿菜 on 16/5/18.
//  Copyright © 2016年 织梦网. All rights reserved.
//

#import "ZYYJudgeCell.h"
#import "TZFindSnsModel.h"
#import "ICESelfInfoViewController.h"

@interface ZYYJudgeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *orcontentLabel;

@property (weak, nonatomic) IBOutlet UIView *textViewContainer;
@end

@implementation ZYYJudgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    _imgView.layer.cornerRadius = 20;
    
    UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtapAvatar)];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:longtap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)];
    _imgView.userInteractionEnabled = YES;
    [_imgView addGestureRecognizer:tap];
    
//    _textView = [[HWStatusTextView alloc] init];
//    [self.textViewContainer addSubview:_textView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textView.frame = self.textViewContainer.bounds;
}

- (void)longtapAvatar {
    if (self.tapAvatarBlock) {
        self.tapAvatarBlock(_model);
    }
}

- (void)tapAvatar {
    ICESelfInfoViewController *userInfoVc = [[ICESelfInfoViewController alloc] init];
    if (self.isMine) {
        userInfoVc.type = ICESelfInfoViewControllerTypeSelf;
    } else {
        userInfoVc.type = ICESelfInfoViewControllerTypeOther;
        userInfoVc.uid = self.model.uid;
        userInfoVc.nickName = self.model.unickname;
    }
    [[UIViewController currentViewController].navigationController pushViewController:userInfoVc animated:YES];
}

- (void)setModel:(TZSnsCommentModel *)model {
    _model = model;
    _timeLable.text = model.updated_at;
    _titleLable.text = model.unickname;
    if ([model.type isEqual:@"2"]) {
        _orcontentLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@：%@",model.bunickname,model.content]];
    }else {
        _orcontentLabel.attributedText = model.contentAtr;
    }
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.uvatar] placeholderImage:TZPlaceholderAvaterImage];
}

@end
