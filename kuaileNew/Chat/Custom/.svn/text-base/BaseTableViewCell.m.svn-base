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

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
@property (nonatomic, strong) UILabel *unreadLabel;
@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _bottomLineView = [[UIView alloc] init];
//        _bottomLineView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 /255.0 blue:246 / 255.0 alpha:0.7];
//        [self.contentView addSubview:_bottomLineView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = TZColorRGB(20);
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 2, 18, 18)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];
    }
    return self;
}


- (void)setIsSystemCell:(BOOL)isSystemCell {
    _isSystemCell = isSystemCell;
    if (isSystemCell) {
        self.textLabel.textColor = TZGreyText74Color;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
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
    
    self.imageView.frame = CGRectMake(10, 8, 40, 40);
//    self.imageView.layer.cornerRadius = 20;
    self.imageView.clipsToBounds = YES;
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = rect;
    
//    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
    self.textLabel.frame = CGRectMake(68, 20, 175, 20);
    if (self.isGroupMemberCell) {
        self.textLabel.frame = CGRectMake(68, 20, self.width - 10 - 68, 20);
    }
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)]) {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setUsername:(NSString *)username {
    _username = username;
    _usernameNick = username;
    NSString *newUserName = [TZEaseMobManager nickNameWithUsername:username];
    if ([ICETools isMobileNumber:newUserName]) {
//        self.textLabel.text = [NSString stringWithFormat:@"%@****%@",[newUserName substringToIndex:3],[newUserName substringFromIndex:7]];
        self.textLabel.text = newUserName;
    } else {
        self.textLabel.text = newUserName;
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:@"groupPublicHeader"];
    if (self.placeHolderImage) {
        placeholderImage = [UIImage imageNamed:self.placeHolderImage];
    }
    
    NSString *avatar = [TZEaseMobManager avatarWithUsername:username];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:placeholderImage options:SDWebImageRefreshCached];
}

- (void)setUsernameNick:(NSString *)usernameNick {
    _usernameNick = usernameNick;
//    [self.textLabel setTextWithUsername:_username];
    self.textLabel.text = usernameNick;
}

@end
