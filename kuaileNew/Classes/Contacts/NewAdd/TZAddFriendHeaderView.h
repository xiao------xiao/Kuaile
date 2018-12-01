//
//  TZAddFriendHeaderView.h
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZAddFriendHeaderView : UIView
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic, copy) void (^didTapAddressBookViewBlock)();
@property (nonatomic, copy) void (^didClickSearchBtnBlock)();
@end
