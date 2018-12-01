//
//  GroupDetailViewController.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "HeaderView.h"
#import "HJNavBarView.h"
//#import "GroupDetailCell.h"
#import "GroupDetailViewCell.h"
#import "BottomView.h"
#import "HJGroupDetailModel.h"
#import "ChatViewController.h"
#import "GroupDetail.h"
#import "EMChatManagerChatroomDelegate.h"
#import "GroupPeopleViewController.h"
#import "LocationViewController.h"
#import "ICESelfInfoViewController.h"

@interface GroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource,IChatManagerGroup,GroupDetailViewCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) HeaderView * headView;
@property (nonatomic, strong) HJNavBarView *naviBar;
@property (nonatomic, strong) NSArray * array;
@property (nonatomic, strong) BottomView *bottomView;
@property (nonatomic, strong) NSMutableDictionary * dic;//数据字典
@property (nonatomic, assign) NSInteger is_join;
@property (nonatomic, assign) NSNumber * is_admin;
@property (strong, nonatomic) EMGroup *chatGroup;
@property (nonatomic, strong) NSString* gidd;// 传值群id
@property (nonatomic,strong) NSMutableArray * memberArr; // 人数数组
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *bgImg;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GroupDetailViewController
-(NSMutableArray *)memberArr {
    
    if (!_memberArr) {
        _memberArr = [NSMutableArray array];
    }
    return _memberArr;
}

-(NSMutableDictionary *)dic {
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

-(NSArray *)array {
    if (!_array) {
        _array = @[@"屏蔽群消息",@"群 号",@"创建于",@"群位置",@"群标签",@"群主",@"群成员"];
    }
    return _array;
}
/** 配置这个页面特有的naviBar */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *isAnimated = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAnimated"];
    if (isAnimated.integerValue == 1) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self configTZNaviBarView];
    [self createRefreshUI];
}

-(void)createRefreshUI {
    NSString * lng = [ICELoginUserModel sharedInstance].lng;
    NSString * lat = [ICELoginUserModel sharedInstance].lat;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    params[@"gid"] = self.gid;
    params[@"lng"] =@(lng.doubleValue);
    params[@"lat"] =@(lat.doubleValue);
    MJWeakSelf;
    [TZHttpTool postWithURL:ApiSnsGroupInfo params:params success:^(NSDictionary *result) {
        self.dic = result[@"data"];
        self.is_join = [self.dic[@"is_join"]  integerValue];
        self.is_admin = self.dic[@"is_admin"];// /0普通成员1创建者
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headView.headImage sd_setImageWithURL:TZImageUrlWithShortUrl(self.dic[@"avatar"]) placeholderImage:TZPlaceholderImage];
            self.headView.titleLabel.text = self.dic[@"owner"];
            [self.headView.backGroundImage sd_setImageWithURL:TZImageUrlWithShortUrl(self.dic[@"background"]) placeholderImage:TZPlaceholderImage];
            self.headView.titlContentLabel.text = self.dic[@"desc"];
            _naviBar.titleLabel.text = self.dic[@"owner"];
            if (self.is_admin.integerValue == 0) {
                NSString * str = [NSString stringWithFormat:@"%.2fkm",self.dic[@"distance"]];
                [self.headView.buton setTitle:str forState:UIControlStateNormal];
            }else {
                [self.headView.buton setTitle:@"换背景" forState:UIControlStateNormal];
                [self.headView.buton setImage:[UIImage imageNamed:@"hbeij"] forState:UIControlStateNormal];
                [self.headView.buton addTarget:self action:@selector(changeBackgroudImage) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if (self.is_join == 0) {
                [self.bottomView.signUpButton setTitle:@"申请加群" forState:UIControlStateNormal];
                [self.bottomView.signUpButton setBackgroundImage:[UIImage imageNamed:@"changlan"] forState:UIControlStateNormal];
            }else {
                [self.bottomView.signUpButton setTitle:@"退出群" forState:UIControlStateNormal];
                [self.bottomView.signUpButton setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
            }
            NSArray * array = [memberModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"members"]];
            [self.memberArr addObjectsFromArray:array];
            [self.tableView reloadData];
        });
        [self.tableView endUpdates];
    } failure:^(NSString *msg) {
        [self showInfo:msg];
    }];
}

-(void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, mScreenWidth, mScreenHeight + 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    self.headView = [[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:nil options:nil].lastObject;
    self.headView.frame = CGRectMake(0, 0, mScreenWidth, 250 );
    _tableView.tableHeaderView = self.headView;
    
    self.bottomView = [[NSBundle mainBundle]loadNibNamed:@"View" owner:nil options:nil].firstObject;
    self.bottomView.frame = CGRectMake(0, 0, mScreenWidth, 150);
    [self.bottomView.signUpButton addTarget:self action:@selector(signUpGroupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = self.bottomView;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addSubview:self.headView];
    [_tableView registerNib:[UINib nibWithNibName:@"GroupDetailViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"GroupDetail" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    
    [self.view addSubview:self.tableView];
}
- (void)configTZNaviBarView {
    _naviBar = [[HJNavBarView alloc] init];
    _naviBar.frame = CGRectMake(0, 0, __kScreenWidth, 64);
    _naviBar.changeButton.hidden = YES;
//    [_naviBar.changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar.backBtn addTarget:self action:@selector(backbuttonCliced) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_naviBar];
    
}

#pragma mark - UIScrollViewDelegate
// 让导航条也跟着scrollView滑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        // 1.让导航条背景色的透明度变化 130是范围 越大渐变越慢
        CGPoint offSet = scrollView.contentOffset;
        CGFloat alpha = 0;
        alpha = (offSet.y) / 90;
        self.naviBar.navBarBack.alpha = alpha;
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
       GroupDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (self.dic) {
            if (self.is_join == 0) {
                cell.switchLayout.constant = 0;
                cell.switchView.hidden = YES;
                cell.lab.hidden =YES;
            }else{
                cell.switchView.hidden = NO;
                cell.lab.hidden = NO;
                cell.switchLayout.constant = 40;
            }
            cell.groupNum.text = self.dic[@"group_id"];
            cell.createTime.text = [CommonTools getTimeStrBytimeStamp:self.dic[@"created"]];
            cell.groupLocation.text = self.dic[@"address"];
            [cell.groupLabel setTitle:self.dic[@"lab_name"] forState:UIControlStateNormal];
            [cell.headImage sd_setImageWithURL:TZImageUrlWithShortUrl(self.dic[@"avatar"]) placeholderImage:TZPlaceholderImage];
            cell.nameLabel.text = self.dic[@"grouper"];
            cell.numPeople.text = [NSString stringWithFormat:@"%@人",self.dic[@"total_member"]];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else  {
        GroupDetail * groupCell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray * arr = [NSMutableArray array];
        for (memberModel * model in self.memberArr) {
            [arr addObject:model.avatar];
        }
        groupCell.model = arr;
        return groupCell;
    }
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     CGFloat width = (mScreenWidth - 48 - 30) / 7;
    if (indexPath.row == 0) {
        if (self.is_join == 0) {
            return 331;
        }else{
           return 373;
        }
    }else {
        return (self.memberArr.count / 7 + 1) * (width +10);
    }
}


#pragma mark -- 屏蔽群消息switch
-(void)switchOption:(UISwitch *)swi {
    if (swi.on = YES) {
        NSString *title = @"开启消息免打扰";
        NSArray *ignoredGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
        if ([ignoredGroupIds containsObject:_chatGroup.groupId]) {
            title = @"关闭消息免打扰";
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
        [sheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
            if (x.integerValue == 0) {
                if ([title isEqualToString:@"开启消息免打扰"]) {
                    [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:YES];
                    [self showInfo:@"开启消息免打扰成功"];
                } else {
                    [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:NO];
                    [self showInfo:@"关闭消息免打扰成功"];
                }
            }
        }];
        [sheet showInView:self.view];
    }
   
}
-(void)backbuttonCliced {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 加群
-(void)signUpGroupButtonClicked {
    
    if (self.is_join == 0) {
       __weak typeof(self) weakSelf = self;
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:self.dic[@"group_id"] withGroupname:self.groupName message:@"" completion:^(EMGroup *group, EMError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (!error) {
                        NSLog(@"申请成功");
                        NSMutableDictionary * params = [NSMutableDictionary dictionary];
                        params[@"sessionid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
                        params[@"gid"] = self.gid;
                        params[@"huanxinId"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"easeMobUsername"];
                        [TZHttpTool postWithURL:ApiSnsGetjoinGroup params:params success:^(NSDictionary *result) {
                            [weakSelf showInfo:result[@"msg"]];
                        } failure:^(NSString *msg) {
                            [weakSelf showInfo:@"申请失败"];
                        }];
                        }
                     });
            } onQueue:nil];
         });
    }else{
        DLog(@"退出群组");
        __weak typeof(self) weakSelf = self;
        [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            [[EaseMob sharedInstance].chatManager asyncLeaveGroup:self.dic[@"group_id"] completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                    if (error) {
                        [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
                        [self performSelector:@selector(backbuttonCliced) withObject:nil afterDelay:1.5f];
                    }
                });
            } onQueue:nil];
        });
    }
}

/*!
 @method
 @brief 申请加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didApplyJoinPublicGroup:(EMGroup *)group error:(EMError *)error{
    if (!error) {
        [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EaseMob sharedInstance].chatManager joinPublicGroup:group.groupId error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
                }
                else{
                    [weakSelf showHint:error];
                }
            });
        });
    }
}
/*!
 @method
 @brief 离开一个群组后的回调
 @param group  所要离开的群组对象
 @param reason 离开的原因
 @param error  错误信息
 @discussion
 离开的原因包含主动退出、被别人请出、和销毁群组三种情况
 */
-(void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error {
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager leaveGroup:group.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf hideHud];
            switch (reason) {
                case eGroupLeaveReason_BeRemoved:
                    [weakSelf showHint:@"移除出群"];
                    break;
                case eGroupLeaveReason_UserLeave:
                    [weakSelf showHint:@"退出群"];
                    break;
                case eGroupLeaveReason_Destroyed:
                    [weakSelf showHint:@"群被人销毁"];
                    break;
                default:
                    break;
            }
        });
    });
}

#pragma mark -- cell点击事件跳转
-(void)GroupDetailViewCellDelegate:(NSInteger)tage {
    if (tage == 10) {
       [self skipLocationView];
    }else if (tage == 11) {
        [self ICESelfInfoView:ICESelfInfoViewControllerTypeOther];
    }else if (tage == 12) {
        [self groupPeopleView];
    }
}
// 跳转群组列表页
-(void)groupPeopleView {
    GroupPeopleViewController * vc = [[GroupPeopleViewController alloc]init];
    vc.gid = self.dic[@"gid"];
    [self.navigationController pushViewController:vc animated:YES];
}
//跳转到定位视图
-(void)skipLocationView {
    __weak typeof(self) weakSelf = self;
    double lat = (double)[weakSelf.dic[@"lat"] floatValue];
    double lng = (double)[weakSelf.dic[@"lng"] floatValue];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:coordinate];
    [weakSelf.navigationController pushViewController:locationController animated:YES];
}
// 跳转到个人信息页面
-(void)ICESelfInfoView:(ICESelfInfoViewControllerType) type {
    ICESelfInfoViewController *vc = [[ICESelfInfoViewController alloc]init];
    vc.otherUsername = self.dic[@"grouper"];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 更换背景
-(void)changeBackgroudImage {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * photoAct = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction * imageAct = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:photoAct];
    [alert addAction:imageAct];
    [alert addAction:cancelAction];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 拍照
- (void)takePhoto {
    if (self.dataArray.count >= 9) {
        [self showInfo:@"你最多只能选择9张图片"]; return;
    }
}



@end
