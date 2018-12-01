/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "ChatListCell.h"
#import "MessageModel.h"
#import "MessageModelManager.h"
#import "ORTimeTool.h"
#import "XYGroupInfoModel.h"
#import "EMConversation+Gropp.h"

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(__kScreenWidth - 120 - 10, 7, 120, 16)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = TZGreyText150Color;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 18, 18)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 35, mScreenWidth - 80, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = TZColorRGB(74);
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.imageView.layer.cornerRadius = 20;
        self.imageView.backgroundColor = [UIColor redColor];
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, 0.5)];
//        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
//        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setIsSystemCell:(BOOL)isSystemCell {
    _isSystemCell = isSystemCell;
    if (isSystemCell) {
        self.textLabel.font = [UIFont systemFontOfSize:18];
        _detailLabel.textColor = TZGreyText150Color;
        self.textLabel.textColor = TZGreyText74Color;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        self.imageView.layer.cornerRadius = 4;
    } else {
        self.imageView.layer.cornerRadius = 22.5;
        self.textLabel.font = [UIFont boldSystemFontOfSize:18];
        self.textLabel.textColor = TZGreyText74Color;
        _detailLabel.textColor = TZGreyText74Color;
        _detailLabel.font = [UIFont systemFontOfSize:15];
    }
    self.imageView.clipsToBounds = YES;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setModel:(MessageModel *)model {
    _model = model;
}

- (void)setHpCSonversation:(EMConversation *)hpCSonversation {
    if (!hpCSonversation.latestMessage) {
        return;
    }
    _model = [MessageModelManager modelWithMessage:hpCSonversation.latestMessage];
    _detailMsg = _model.type == eMessageBodyType_Image ? @"[图片]" : _model.content;
    _unreadCount = hpCSonversation.unreadMessagesCount;
    _time = [ORTimeTool timeStr:hpCSonversation.latestMessage.timestamp];

}

- (void)setConversation:(EMConversation *)conversation {
    
    _conversation = conversation;
    _model = [MessageModelManager modelWithMessage:conversation.latestMessage];
    _detailMsg = _model.type == eMessageBodyType_Image ? @"[图片]" : _model.content;
    _unreadCount = conversation.unreadMessagesCount;
    _time = [ORTimeTool timeStr:conversation.latestMessage.timestamp];
//    _placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
    _placeholderImage = TZPlaceholderAvaterImage;
;

    if (conversation.groupAvator.length > 0) {
        _imageURL = [NSURL URLWithString:conversation.groupAvator];
        [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
        _name = conversation.groupName;
        return;
    }
    
    _name = conversation.chatter;
    _imageURL = [TZEaseMobManager avatarWithUsername:conversation.chatter];
    
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];

    
    
//    [TZHttpTool postWithURL:ApiDeletefetAvatar params:@{@"usernames" : conversation.chatter} success:^(NSDictionary *result) {
//        NSArray *datas = result[@"data"];
//        if (datas.count > 0) {
//            _imageURL = [NSURL URLWithString:result[@"data"][0][@"avatar"]];
//            [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
//        }
//        
//    } failure:^(NSString *msg) {
////        [[UIViewController currentViewController] showHint:@"请登录"];
//    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];

#warning 20151103 陈冰 聊天群组照片
    if (self.imageURL != nil) {
        [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    } else {
        [self.imageView imageWithUsername:_name placeholderImage:_placeholderImage];
    }
    
    self.imageView.frame = CGRectMake(10, 7, 45, 45);
    
//    self.textLabel.text = _name;
    [self.textLabel setTextWithUsername:_name];
    CGFloat nameW = [CommonTools sizeOfText:_name fontSize:18].width + 3;
    CGFloat maxNameW = 0;
    if (mScreenWidth < 375) {
        if ([_time containsString:@"-"]) {
            maxNameW = self.width * 0.4;
        } else {
            maxNameW = self.width * 0.6;
        }
    } else {
        if ([_time containsString:@"-"]) {
            maxNameW = self.width * 0.5;
        } else {
            maxNameW = self.width * 0.7;
        }
    }
    nameW = nameW > maxNameW ? maxNameW : nameW;
    self.textLabel.frame = CGRectMake(64, 7, nameW, 20);
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
//    CGRect frame = self.imageView.frame;
//    CGRect frame = _lineView.frame;
//    frame.origin.y = self.contentView.frame.size.height - 1;
//    _lineView.frame = frame;
}

-(void)setName:(NSString *)name{
    _name = name;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
