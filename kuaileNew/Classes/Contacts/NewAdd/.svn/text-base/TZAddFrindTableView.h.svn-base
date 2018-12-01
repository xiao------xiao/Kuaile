//
//  TZAddFrindTableView.h
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZAddFrindTableView;

typedef NS_ENUM(NSInteger, TZAddFriendTableViewType) {
    TZAddFriendTableViewTypeAddFriend,
    TZAddFriendTableViewTypeNewFriendNews,
    TZAddFriendTableViewTypeNewFriendPosts,
};

@protocol TZAddFrindTableViewDelegate <NSObject>

@optional

- (void)addFrindTableView:(TZAddFrindTableView *)addFrindTableView didClickAttentionWithBuddyName:(NSString *)buddyName;

@end

@interface TZAddFrindTableView : UITableView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) TZAddFriendTableViewType type;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *subTexts;
@property (nonatomic, strong) NSArray *friendModels;

@property (nonatomic, weak) id<TZAddFrindTableViewDelegate> tzdelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style index:(NSInteger)index;

//- (void)loadRecommendFriendData;
//- (void)loadFriendsDataFromSamePlace;


@end
