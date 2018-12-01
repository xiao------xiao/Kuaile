//
//  TZAddFrindTableView.m
//  kuaile
//
//  Created by ttouch on 2016/12/23.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZAddFrindTableView.h"
#import "TZAddFriendCell.h"
#import "XYDetailListCell.h"
#import "XYDetailListCell.h"
#import "XYRecommendFriendModel.h"
#import "XYUserInfoModel.h"
#import "ICESelfInfoViewController.h"
#import "LFindLocationViewController.h"

@interface TZAddFrindTableView ()<UITableViewDelegate,UITableViewDataSource,LFindLocationViewControllerDelegete> {
    BOOL _netFlag;
}
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *hometown;
@property (assign, nonatomic) CGFloat hometownW;
@property (copy, nonatomic) NSString *userCity;
@property (assign, nonatomic) BOOL haveHomeTown;
@end

@implementation TZAddFrindTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style index:(NSInteger)index {
    self = [self initWithFrame:frame style:style];
    if (self) {
        if (index == 0) {
            [self loadRecommendFriendData];
        } else if (index == 1) {
            [self loadFriendsDataFromSamePlace];
        } else {
            [self loadRecommentcolleagueData];
        }
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.sessionId = [mUserDefaults objectForKey:@"sessionid"];
        XYUserInfoModel *model = [TZUserManager getUserModel];
        self.company_name = model.company_name;
        self.hometown = model.hometown;
        self.haveHomeTown = YES;
        if (self.hometown == nil || [self.hometown isEqualToString:@""] || self.hometown.length < 1) {
            self.haveHomeTown = NO;
            self.hometown = [mUserDefaults objectForKey:@"userCity"];
        }
        self.hometownW =  [CommonTools sizeOfText:self.hometown fontSize:14].width;
    }
    return self;
}

// 获取推荐的好友
- (void)loadRecommendFriendData {
    NSString *ses = self.sessionId;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = self.sessionId;
    [TZHttpTool postWithURL:ApiRecommendFriendLists params:params success:^(NSDictionary *result) {
        self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self reloadData];
    } failure:^(NSString *msg) {
        
    }];
}

//获取推荐老乡好友
- (void)loadFriendsDataFromSamePlace {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = self.sessionId;
    params[@"hometown"] = self.hometown;
    [TZHttpTool postWithLoginURL:ApiFriendsFromSamePlace params:params success:^(NSDictionary *result) {
//        NSLog(@"");
//        if (self.haveHomeTown) {
            self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"ans"]];
//        } else {
//            self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//        }
        [self reloadData];

        
    } failure:^(NSString *msg) {
        
    }];
    
//    [TZHttpTool postWithURL:ApiFriendsFromSamePlace params:@{@"sessionid":self.sessionId} success:^(NSDictionary *result) {
//    } failure:^(NSString *msg) {
//        
//    }];
}

// 获取推荐同事好友
- (void)loadRecommentcolleagueData {
    [TZHttpTool postWithURL:ApiRecommentColleague params:@{@"sessionid":self.sessionId} success:^(NSDictionary *result) {
        if (self.haveHomeTown) {
            NSArray *data = result[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                return;
            }
            
            self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"ans"]];
        } else {
            self.friendModels = [XYRecommendFriendModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        }
        [self reloadData];
    } failure:^(NSString *msg) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case TZAddFriendTableViewTypeAddFriend:
            return self.friendModels.count;
            break;
        case TZAddFriendTableViewTypeNewFriendNews:
            return 5;
            break;
        case TZAddFriendTableViewTypeNewFriendPosts:
            return 5;
            break;
        default:return 0;break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case TZAddFriendTableViewTypeAddFriend:
            return 60;
            break;
        case TZAddFriendTableViewTypeNewFriendNews:
            return 40;
            break;
        case TZAddFriendTableViewTypeNewFriendPosts:
            return 80;
            break;
        default:return 0;break;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case TZAddFriendTableViewTypeAddFriend:{
            TZAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAddFriendCell"];
            cell.moreView.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.distanceLabel.hidden = YES;
            XYRecommendFriendModel *model = self.friendModels[indexPath.row];
            cell.recommendFriendMode = model;
            if (model.isconcern) {
                cell.type = TZAddFriendCellTypeBothAttention;
            } else {
                cell.type = TZAddFriendCellTypeNoAttention;
            }
            [cell addBottomSeperatorViewWithHeight:1];
            [cell setDidAttentionBlock:^{ // 关注
                
                model.isconcern = !model.isconcern;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                if ([self.tzdelegate respondsToSelector:@selector(addFrindTableView:didClickAttentionWithBuddyName:)]) {
                    [self.tzdelegate addFrindTableView:self didClickAttentionWithBuddyName:model.username];
                }
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        case TZAddFriendTableViewTypeNewFriendNews:{
            XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
            cell.text = self.texts[indexPath.row];
            cell.subText = self.subTexts[indexPath.row];
            [cell addBottomSeperatorViewWithHeight:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } break;
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultTableviewCell"];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TZAddFriendTableViewTypeAddFriend) {
        ICESelfInfoViewController *friendVc = [[ICESelfInfoViewController alloc] init];
        
        MJWeakSelf
        friendVc.addBlock = ^(BOOL isadd) {
            XYRecommendFriendModel *model = self.friendModels[indexPath.row];
            model.isconcern = isadd;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([weakSelf.tzdelegate respondsToSelector:@selector(addFrindTableView:didClickAttentionWithBuddyName:)]) {
                [weakSelf.tzdelegate addFrindTableView:self didClickAttentionWithBuddyName:model.username];
            }
        };
        
        friendVc.type = ICESelfInfoViewControllerTypeOther;
        XYRecommendFriendModel *remodel = self.friendModels[indexPath.row];
        friendVc.otherUsername = remodel.username;
        friendVc.nickName = remodel.nickname;
        [[UIViewController currentViewController].navigationController pushViewController:friendVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (self.type) {
        case TZAddFriendTableViewTypeAddFriend:
            return 36;
            break;
            
        default: return 0; break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == TZAddFriendTableViewTypeAddFriend) {
        if (self.index == 0 || self.index == 2) {
            UILabel *lable = [UILabel new];
            lable.backgroundColor = TZControllerBgColor;
            [lable setTitle:@"" font:@13 color:TZColorRGB(128) alignment:NSTextAlignmentLeft];
            if (self.index == 0) {
                lable.text = @"   可能感兴趣的人";
            } else {
                if (self.company_name) {
                    lable.attributedText = [CommonTools createAttrStrWithStrArray:@[@"   都来自",self.company_name] colorArray:@[@128,@44] fontArray:@[@13,@13]];
                }
            }
            return lable;
        } else {
            UIView *view = [UIView new];
            view.backgroundColor = TZControllerBgColor;
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 12, 50, 30);
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = TZColorRGB(128);
            label.text = @"都来自";
            [view addSubview:label];
            
            UIButton *btn = [UIButton new];
            btn.frame = CGRectMake(label.right + 5, 12, self.width - 50, 30);
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.titleLabel.text = self.hometown;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:self.hometown forState:0];
            [btn setImage:[UIImage imageNamed:@"morecompany"] forState:0];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, self.hometownW + 8, 0, 0)];
            [btn setTitleColor:TZGreyText74Color forState:0];
            [btn addTarget:self action:@selector(cityBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            return view;
        }
        
//        switch (self.index) {
//            case 0: {
//                
//            } break;
//            case 1: {
//                lable.attributedText = [CommonTools createAttrStrWithStrArray:@[@"   都来自",self.hometown] colorArray:@[@128,@44] fontArray:@[@13,@13]];
//            } break;
//            case 2: {
//               
//            } break;
//            default: break;
//        }
////        return lable;
    
    } else {
        return nil;
    }
}

- (void)cityBtnClick {
    LFindLocationViewController *cityChooseVc = [[LFindLocationViewController alloc] init];
    cityChooseVc.delegete = self;
    cityChooseVc.loctionCity = [mUserDefaults objectForKey:@"userCity"];
    [[UIViewController currentViewController].navigationController pushViewController:cityChooseVc animated:YES];
}

- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    self.hometown = city;
    self.hometownW = [CommonTools sizeOfText:city fontSize:14].width;
    [self loadFriendsDataFromSamePlace];
}





@end
