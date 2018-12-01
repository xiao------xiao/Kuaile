//
//  XYCommentLikeCell.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCommentLikeCell.h"
#import "ChatListCell.h"
#import "ORTimeTool.h"
#import "XYMessageModel.h"

@interface XYCommentLikeCell ()

@end

@implementation XYCommentLikeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.userInteractionEnabled = NO;
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    _chatView = [[ChatListCell alloc] init];
    _chatView.frame = CGRectMake(0, 0, self.width, 60);
    _chatView.isSystemCell = NO;
    [self.contentView addSubview:_chatView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(10, 60, self.width - 20, self.height - 60 - 10);
    _contentLabel.backgroundColor = TZColorRGB(250);
    _contentLabel.textColor = TZGreyText150Color;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_contentLabel];
}

- (void)setModel:(XYMessageModel *)model {
    
    /*
     
     @property (nonatomic, strong) NSURL *imageURL;
     @property (nonatomic, strong) UIImage *placeholderImage;
     @property (nonatomic, strong) NSString *name;
     @property (nonatomic, strong) NSString *detailMsg;
     @property (nonatomic, strong) NSString *time;
     @property (nonatomic) NSInteger unreadCount;
     
     @property (nonatomic, strong) MessageModel *model;
     
     @property (nonatomic, assign) BOOL isSystemCell;
     */
    
    _model = model;
    self.chatView.imageURL = [NSURL URLWithString:model.uavatar];
    self.chatView.name = model.unickname;
    self.chatView.time = [ORTimeTool timeShortStr:model.create_at.integerValue];
    self.chatView.detailMsg = model.title;
    
    switch (model.data_type.integerValue) {
        case 301:
            self.contentLabel.text = [NSString stringWithFormat:@"回复我的帖子：%@", model.content];
            break;
        case 302:
            self.contentLabel.text = model.content;
            break;
        case 303:
            self.contentLabel.text = [NSString stringWithFormat:@"回复我的评论：%@", model.content];
            break;
        default:
            break;
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _chatView.frame = CGRectMake(0, 0, self.width, 68);
    _contentLabel.frame = CGRectMake(10, 60, self.width - 20, self.height - 68 - 10);
}


@end




