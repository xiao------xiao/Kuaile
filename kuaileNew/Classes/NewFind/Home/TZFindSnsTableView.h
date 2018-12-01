//
//  TZFindSnsTableView.h
//  kuaile
//
//  Created by ttouch on 2016/12/21.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZFindSnsTableView;


@protocol TZFindSnsTableViewDelegate <NSObject>

@optional

- (void)addFrindTableView:(TZFindSnsTableView *)addFrindTableView didClickAttentionWithBuddyName:(NSString *)buddyName;

@end

@interface TZFindSnsTableView : UITableView
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *models;

@property (assign, nonatomic) BOOL needRefresh;

@property (nonatomic, weak) id<TZFindSnsTableViewDelegate> tz_delegate;

- (void)loadGetSameTown;
- (void)loadNetworkData;
- (void)loadDataWork;

- (void)loadViewDataWithIndex:(NSInteger)index;

@end
