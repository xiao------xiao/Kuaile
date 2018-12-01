//
//  XYGroupMemberAvatarView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/4.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYGroupMemberModel;

@interface XYGroupMemberAvatarView : UITableViewCell

@property (nonatomic, strong) NSArray *avatars;

@property (nonatomic, assign) BOOL haveAddAvatar;

@property (nonatomic, copy) void (^didClickAddAvatarBlock)(XYGroupMemberModel *model);

- (CGFloat)tableView:(UITableView *)tableView cellHeightForAtIndexPath:(NSIndexPath *)indexPath;

@end
