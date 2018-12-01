//
//  XYNewFriendHeaderView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/8.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYNewFriendHeaderView : UIView

@property (nonatomic, strong) TZButtonsHeaderView *selHeaderView;
@property (nonatomic, copy) void (^didClickButtonsViewBlock)(NSInteger index);

@end
