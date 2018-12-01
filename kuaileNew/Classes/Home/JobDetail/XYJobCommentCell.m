//
//  XYJobCommentCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobCommentCell.h"
#import "XYJobCommentModel.h"
#import "ICESelfInfoViewController.h"

@interface XYJobCommentCell ()


@end

@implementation XYJobCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentName.font = [UIFont boldSystemFontOfSize:15];
    self.commentImgView.layer.cornerRadius = 25;
    self.commentImgView.clipsToBounds = YES;
    self.replyImgView.layer.cornerRadius = 20;
    self.replyImgView.clipsToBounds = YES;
}

- (void)setModel:(XYJobCommentModel *)model {
    _model = model;
    [self.commentImgView sd_setImageWithURL:model.uvatar placeholderImage:TZPlaceholderAvaterImage];
    self.commentName.text = model.unickname;
    self.commentTime.text = model.create_at;
    self.commentContent.text = model.content;
    XYJobReplyModel *replyModel = model.reply;
    [self.replyImgView sd_setImageWithURL:replyModel.uvatar placeholderImage:TZPlaceholderAvaterImage];
    self.replyName.text = replyModel.name;
    self.replyTime.text = replyModel.time;
    self.replyContent.text = replyModel.content;
}

- (IBAction)userBtnClick:(id)sender {
    ICESelfInfoViewController *vc = [[ICESelfInfoViewController alloc] init];
    NSString *userUid = [mUserDefaults objectForKey:@"userUid"];
    if ([self.model.uid isEqualToString:userUid]) {
        vc.type = ICESelfInfoViewControllerTypeSelf;
    } else {
        vc.type = ICESelfInfoViewControllerTypeOther;
        vc.uid = self.model.uid;
        vc.nickName = self.model.unickname;
    }
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}



@end
