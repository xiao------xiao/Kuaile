//
//  ICEFindViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/15.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEFindViewController.h"
#import "TZToolBar.h"
#import "ICEModifierView.h"
#import "ICENearbyGroupViewController.h"
#import "ICENarbyPeopleViewController.h"

#import "ICELiveServeViewController.h"          // 生活服务

#import "ICECreateGroupViewController.h"        // 创建讨论组
#import "ICEUserInfoViewController.h"           // 用户信息
#import "ICEGroupInfoViewController.h"          // 群详情

#import "ICEModelGroup.h"
#import "ICEModelPeople.h"
#import "ICEModelRecommend.h"

#import "WebViewJavascriptBridge.h"
#import "ICECommentViewController.h"
#import "ICEIssueViewController.h"

#import "MWCommon.h"
#import "ICEReportViewController.h"

#import "JZLocationConverter.h"
#import "ICELocationManagerNEW.h"
#import "LocationDemoViewController.h"
#import "ICEForgetViewController.h"

#import "MJPhotoBrowser.h"

@interface ICEFindViewController () <TZToolBarDelegate, UIScrollViewDelegate, UIWebViewDelegate,ICELocationManagerDelegate>
@property (nonatomic, strong) TZToolBar *toolBar; ///< 2个选项卡
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; ///< 大scrollView
@property (nonatomic, strong) UIWebView *webView;   ///< leftWebView
@property (nonatomic, strong) ICEModifierView *iCEModifierView;

@property WebViewJavascriptBridge* bridge;

@property (nonatomic, strong) NSArray *srcStringArray;
// 附近的人数据
@property (nonatomic, strong) NSArray *nearbyPersons;
// 附近群组数据
@property (nonatomic, strong) NSArray *nearbyGruops;
// 推荐群组数据
@property (nonatomic, strong) NSArray *recomGruops;

@property (nonatomic, strong) NSArray *photos;

@end

@implementation ICEFindViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configWebViewJavascriptBridge];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.tabBarItem.title = @"";
    [self configToolBar];
    [self configBigScrollView];
    [self configLeftView];
    [self configRightView];
    [self configRecreationalActivitiesView];
    [self configICEModifierView];
    [self configNaviItem];
    [self configUserInfoImg];
    [self configGroupBtn];
}

- (void)configToolBar {
    _toolBar = [TZToolBar toolBar];
    _toolBar.frame = CGRectMake(0, 0, __kScreenWidth, 50);
    _toolBar.delegate = self;
    [_toolBar.leftBtn setTitle:@"广场" forState:UIControlStateNormal];
    [_toolBar.rightBtn setTitle:@"附近" forState:UIControlStateNormal];
    [self.view addSubview:_toolBar];
}

- (void)configBigScrollView {
    self.view.backgroundColor = __kColorWithRGBA(248, 248, 248, 1.0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(__kScreenWidth * 2, __kScreenHeight- 49 - 64 - 50);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

/** 广场WebView */
- (void)configLeftView {
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, __kScreenWidth,__kScreenHeight - 49 - 64 - 50);
    
    _webView = [[UIWebView alloc] initWithFrame:leftView.frame];
    _webView.delegate = self;
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL* url = [NSURL URLWithString:[ApiSns stringByAppendingString:userModel.uid]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [leftView addSubview:_webView];
    [self.scrollView addSubview:leftView];
    _webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_webView reload];
    }];
}

/** 配置webView与本地code 的桥接 */
- (void)configWebViewJavascriptBridge {
    if (_bridge) { return; }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        /// 点击Web页面JS
        DLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"showUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        ICEUserInfoViewController *iCEUserInfo = [[ICEUserInfoViewController alloc] init];
        iCEUserInfo.userName = data[@"uid"];
        [self.navigationController pushViewController:iCEUserInfo animated:YES];
    }];
    
    __weak __typeof(self) weakSelf = self;
    [_bridge registerHandler:@"clickImg" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.srcStringArray = data[@"urls"];
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSInteger i = 0 ; i < weakSelf.srcStringArray.count; i++) {
            NSString *strURL = [weakSelf.srcStringArray[i] objectForKey:@"img"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:strURL];
            [photos addObject:photo];
        }
        self.photos = photos;
        
        MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
        photoBrowser.currentPhotoIndex = [data[@"index"] integerValue];
        photoBrowser.photos = photos;
        [photoBrowser show];
    }];
    [_bridge registerHandler:@"addHit" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![TZUserManager isLogin]) return;
        NSString *sns_id = data[@"cid"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"sns_id" : sns_id }];
        RACSignal *sign = [ICEImporter netZanSnsWithParams:params];
        [sign subscribeNext:^(id x) {
            NSString *hits = x[@"data"];
            responseCallback(hits);
        } error:nil];
    }];
    // 举报
    [_bridge registerHandler:@"report" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![TZUserManager isLogin]) return;
        NSString *sns_id = data[@"cid"];
        ICEReportViewController *iCEReport = [[ICEReportViewController alloc] initWithNibName:@"ICEReportViewController" bundle:[NSBundle mainBundle]];
        iCEReport.reportCid = sns_id;
        [self.navigationController pushViewController:iCEReport animated:YES];
    }];
    // 评论
    [_bridge registerHandler:@"addReply" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![TZUserManager isLogin]) return;
        ICECommentViewController *iCEComment = [[ICECommentViewController alloc] initWithNibName:@"ICECommentViewController" bundle:[NSBundle mainBundle]];
        iCEComment.commentStyle = ICECommentStyleComment;
        iCEComment.title = @"评论";
        iCEComment.returnBlock = ^(NSString *text) {
            NSString *sns_id = data[@"cid"];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"content" : text, @"sns_id" : sns_id }];
            [ICEImporter netCommentSnsWithParams:params];
            NSString *commentName = [NSString string];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            if (userModel.nickname == nil) {
                commentName = @"匿名";
            } else {
                commentName = userModel.nickname;
            }
            NSString *strHit = [NSString stringWithFormat:@"<div class=\"content_1_list\"><span class=\"langse\">%@：</span><span class=\"feise\">%@</span></div>", commentName, text];
            responseCallback(strHit);
        };
        [self.navigationController pushViewController:iCEComment animated:YES];
    }];
    // 回复
    [_bridge registerHandler:@"AtComment" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![TZUserManager isLogin]) return;
        ICECommentViewController *iCEComment = [[ICECommentViewController alloc] initWithNibName:@"ICECommentViewController" bundle:[NSBundle mainBundle]];
        iCEComment.commentStyle = ICECommentStyleReback;
        iCEComment.title = @"回复";
        iCEComment.nickName = data[@"nickname"];
        iCEComment.returnBlock = ^(NSString *text) {
            NSString *sns_id = data[@"sns_id"];
            NSString *sns_uid = data[@"uid"];
            NSString *nickName = data[@"nickname"];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                           initWithDictionary:@{
                                                                @"content" : text,
                                                                @"sns_id" : sns_id,
                                                                @"buid" : sns_uid
                                                                }];
            
            [ICEImporter netCommentSnsWithParams:params];
            NSString *commentName = [NSString string];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            if (userModel.nickname == nil) {
                commentName = @"匿名";
            } else {
                commentName = userModel.nickname;
            }
            NSString *strHit = [NSString stringWithFormat:@"<div class=\"content_1_list\"><span class=\"langse showUser\" data-uid=\"%@\">%@</span>&nbsp;回复<span class=\"langse showUser\" data-uid=\"%@\">%@：</span><span class=\"feise\">%@</span></div>", userModel.username, commentName, sns_uid, nickName, text];
            responseCallback(strHit);
        };
        [self.navigationController pushViewController:iCEComment animated:YES];
    }];
    
}

/** 附近View*/
- (void)configRightView {
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth,__kScreenHeight - 49 - 64 - 50);
    _iCEModifierView = [[[NSBundle mainBundle] loadNibNamed:@"ICEModifierView" owner:nil options:nil] lastObject];
    _iCEModifierView.frame = rightView.bounds;
    [rightView addSubview:_iCEModifierView];
    [self.scrollView addSubview:rightView];
    // 此时开始请求网络数据
    [self loadNetData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.iCEModifierView.modifierScrollView.header = header;
}

- (void)refreshDataWithHeader {
    [self loadNetData];
}

- (void)configNaviItem {
    // 创建群按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationItem.leftBarButtonItem = [self configBarButtonItemWithBtn:leftBtn Image:@"createGroup"];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DLog(@"创建组");
        if (![TZUserManager isLogin]) return;
        ICECreateGroupViewController *iCECreateGroup = [[ICECreateGroupViewController alloc] init];
        [self.navigationController pushViewController:iCECreateGroup animated:YES];
    }];
    
    // 发布按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationItem.rightBarButtonItem = [self configBarButtonItemWithBtn:rightBtn Image:@"find"];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DLog(@"发布");
        if (![TZUserManager isLogin]) return;
        ICEIssueViewController *iCEIssue = [[ICEIssueViewController alloc] initWithNibName:@"ICEIssueViewController" bundle:[NSBundle mainBundle]];
        iCEIssue.issueBlock = ^(){
            [self.webView reload];
        };
        [self.navigationController pushViewController:iCEIssue animated:YES];
    }];
}

- (UIBarButtonItem *)configBarButtonItemWithBtn:(UIButton *)button Image:(NSString *)image {
    button.frame = CGRectMake(0,0, 80, 30);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

#pragma mark ToolBar被点击时的代理方法

- (void)toolBar:(TZToolBar *)toolBar didClickButtonWithType:(ToolBarButtonType)buttonType {
    switch (buttonType) {
        case ToolBarButtonTypeLeft: { // 左边按钮  职位信息
            [UIView animateWithDuration:0.15 animations:^{
                CGPoint point = self.scrollView.contentOffset;
                point.x = 0;
                self.scrollView.contentOffset = point;
            }]; }
            break;
        case ToolBarButtonTypeRight: { // 右边按钮  公司信息
            [UIView animateWithDuration:0.15 animations:^{
                CGPoint point = self.scrollView.contentOffset;
                point.x = __kScreenWidth;
                self.scrollView.contentOffset = point;
            }]; }
            break;
        default:
            break;
    }
}

#pragma mark UIScrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    if (offSet.x <= (__kScreenWidth * 0.5)) { // 此时自动回左边，让职位信息成被选中状态
        self.toolBar.showLeftBtn = YES;
    } else if (offSet.x > (__kScreenWidth * 0.5)) { // 此时自动回左边，让公司信息成被选中状态
        self.toolBar.showRightBtn = YES;
    }
}

#pragma mark - 配置ICEModifierView
/** 休闲娱乐模块 */
- (void)configRecreationalActivitiesView {
    [[_iCEModifierView.btnLiveServeS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICELiveServeViewController *iCELiveServe = [[ICELiveServeViewController alloc] init];
        [self.navigationController pushViewController:iCELiveServe animated:YES];
    }];
    
    [[_iCEModifierView.btnSignInGiftsS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (![TZUserManager isLogin]) return;
        ICELoginUserModel *user = [ICELoginUserModel sharedInstance];
        if ([user.rid isEqualToString:@"8"]) {
            [self mySignInGiftsWithParams:@"" lat:@"" lng:@""];
        } else {
            [self baiduLocation];
        }
    }];
    [[_iCEModifierView.btnLotteryActivityS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (![TZUserManager isLogin]) return;
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSString *strURL = [NSString stringWithFormat:@"%@%@", ApiAward, userModel.uid];
        [self pushWebVcWithUrl:strURL title:@"抽奖活动"];
    }];
    [[_iCEModifierView.btnMoreS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showInfoWithPleaseExpect];
    }];
}

- (void)configICEModifierView {
    // 附近的人
    [[_iCEModifierView.btnNeabyPeopleAll rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICENarbyPeopleViewController *iCENeabyPeople = [[ICENarbyPeopleViewController alloc] init];
        iCENeabyPeople.gender = @"2";
        [self.navigationController pushViewController:iCENeabyPeople animated:YES];
    }];
    // 附近的群
    [[_iCEModifierView.btnNeabyGroupAll rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICENearbyGroupViewController *iCENeabyGroup = [[ICENearbyGroupViewController alloc] init];
        iCENeabyGroup.title = @"附近的群";
        iCENeabyGroup.type = ICENearbyGroupViewControllerTypeNear;
        [self.navigationController pushViewController:iCENeabyGroup animated:YES];
    }];
    // 推荐的群
    [[_iCEModifierView.btnNeabyGourpRecommond rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICENearbyGroupViewController *iCENeabyGroup = [[ICENearbyGroupViewController alloc] init];
        iCENeabyGroup.title = @"推荐的群";
        iCENeabyGroup.type = ICENearbyGroupViewControllerTypeRecommed;
        [self.navigationController pushViewController:iCENeabyGroup animated:YES];
    }];
}

#pragma mark 附近的人
- (void)configUserInfoImg {
    [[_iCEModifierView.btnImgOne rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self gotoUserInfoVc:x];
    }];
    [[_iCEModifierView.btnImgTwo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self gotoUserInfoVc:x];
    }];
    [[_iCEModifierView.btnImgThree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self gotoUserInfoVc:x];
    }];
    [[_iCEModifierView.btnImgFour rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self gotoUserInfoVc:x];
    }];
}

- (void)gotoUserInfoVc:(id)x {
    UIButton *btn = (UIButton *)x;
    NSInteger num = btn.tag-101;
    ICEModelPeople *model = self.nearbyPersons[num];
    ICEUserInfoViewController *iCEUserInfo = [[ICEUserInfoViewController alloc] init];
    iCEUserInfo.userName = model.username;
    [self.navigationController pushViewController:iCEUserInfo animated:YES];
}

#pragma mark 附近的群
- (void)configGroupBtn {
    // 附近群组
    [_iCEModifierView.btnGroupOne addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.btnGroupTwo addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.btnGroupThree addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.btnGroupFour addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    // 推荐群组
    [_iCEModifierView.recomGruop1 addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.recomGruop2 addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.recomGruop3 addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [_iCEModifierView.recomGruop4 addTarget:self action:@selector(gotoGruopDetailVc:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotoGruopDetailVc:(UIButton *)button {
    // 自定义的群model
    if (![TZUserManager isLogin]) return;
    ICEModelGroup *model;
    if (5 <= button.tag && button.tag <= 8) {
        model = self.recomGruops[button.tag - 5]; // tag从5开始  推荐群组 5 - 8
    } else {
        model = self.nearbyGruops[button.tag - 9]; //  tag从9开始  附近群组 9 - 12
    }
    ICEGroupInfoViewController *iCEGroupInfoVc = [[ICEGroupInfoViewController alloc] initWithNibName:@"ICEGroupInfoViewController" bundle:[NSBundle mainBundle] groupID:model.group_id];
    [self.navigationController pushViewController:iCEGroupInfoVc animated:YES];
}

#pragma mark - 签到功能

/** 签到区分业务员还是求职者 */
- (void)mySignInGiftsWithParams:(NSString *)address lat:(NSString *)latitude lng:(NSString *)longitude {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{
                                                        @"address" : address,
                                                        @"lat" : latitude,
                                                        @"lng" : longitude
                                                        }];
    RACSignal *sign = [ICEImporter signWithParams:params];
    [sign subscribeNext:^(id x) {
        [self hideHud];
        UIAlertView *nameAlertView =  [[UIAlertView alloc] initWithTitle:x[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [nameAlertView show];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *lat = [mUserDefaults objectForKey:@"latitude"];
    NSString *lng = [mUserDefaults objectForKey:@"longitude"];
    if (lat != nil && lng != nil ) {
        RACSignal *sign = [ICEImporter locationWithLatitude:lat withLongitude:lng];
    }
}

// 加载网络数据
- (void)loadNetData {
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSDictionary *params = @{ @"lat" : @"", @"lng" : @"" };
    if (latitude != nil && longitude != nil ) {
        params = @{ @"lat" : latitude, @"lng" : longitude, @"gender" : @"2" };
    }
    RACSignal *signGroup = [ICEImporter nearGroupsParams:params];
    [signGroup subscribeNext:^(id x) {
        NSArray *groupAry = [ICEModelGroup mj_objectArrayWithKeyValuesArray:x[@"data"]];
        // 若有附近群数据 把值赋过去后 会显示出数据
        _iCEModifierView.nearGruopModels = groupAry;
        self.nearbyGruops = groupAry;
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    } error:^(NSError *error) {
        _iCEModifierView.viewNearGroup.hidden = YES;
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    }];
    RACSignal *signPeople = [ICEImporter nearPeopleParams:params];
    [signPeople subscribeNext:^(id x) {
        NSArray *peopleAry = [ICEModelPeople mj_objectArrayWithKeyValuesArray:x[@"data"]];
        self.nearbyPersons = peopleAry;
        [self loadPeopleInfoWithArr:peopleAry];
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    } error:^(NSError *error) {
        _iCEModifierView.viewNearPeople.hidden = YES;
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    }];
    RACSignal *signRecommend = [ICEImporter getRecommendGroups];
    [signRecommend subscribeNext:^(id x) {
        NSArray *recomAry = [ICEModelRecommend mj_objectArrayWithKeyValuesArray:x[@"data"]];
        // 若有推荐群数据 把值赋过去后 会显示出数据
        _iCEModifierView.recomGruopModels = recomAry;
        self.recomGruops = recomAry;
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    } error:^(NSError *error) {
        _iCEModifierView.viewRecomGroup.hidden = YES;
        [self.iCEModifierView.modifierScrollView.header endRefreshing];
    }];
}

// 加载附近的人数据
- (void)loadPeopleInfoWithArr:(NSArray *)peopleArr {
    if (peopleArr.count > 0) {
        ICEModelPeople *model = peopleArr[0];
        if (model.avatar != nil && ![model.avatar isEqualToString:@""]) {
            [_iCEModifierView.imgViewOne sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        _iCEModifierView.btnImgOne.enabled = YES;
        _iCEModifierView.imgViewOne.hidden = NO;
    }
    if (peopleArr.count > 1) {
        ICEModelPeople *model = peopleArr[1];
        if (model.avatar != nil && ![model.avatar isEqualToString:@""]) {
            [_iCEModifierView.imgViewTwo sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        _iCEModifierView.btnImgTwo.enabled = YES;
        _iCEModifierView.imgViewTwo.hidden = NO;
    }
    if (peopleArr.count > 2) { // 3和4 头像图片的命名对调了
        ICEModelPeople *model = peopleArr[2];
        if (model.avatar != nil && ![model.avatar isEqualToString:@""]) {
            [_iCEModifierView.imgViewFour sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        _iCEModifierView.btnImgThree.enabled = YES;
        _iCEModifierView.imgViewFour.hidden = NO;
    }
    if (peopleArr.count > 3) {
        ICEModelPeople *model = peopleArr[3];
        if (model.avatar != nil && ![model.avatar isEqualToString:@""]) {
            [_iCEModifierView.imgViewThree sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        _iCEModifierView.btnImgFour.enabled = YES;
        _iCEModifierView.imgViewThree.hidden = NO;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView.scrollView.header endRefreshing];
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache storeCachedResponse:webView.request forRequest:webView.request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView.scrollView.header endRefreshing];
}

#pragma mark - 用户签到

- (void)baiduLocation {
    LocationDemoViewController *locationController = [[LocationDemoViewController alloc] init];
    [locationController setDidGetLocationInfoBlock:^(double lat, double lng, NSString *address) {
        [self mySignInGiftsWithParams:address lat:[@(lat) stringValue] lng:[@(lng) stringValue]];
    }];
    [self.navigationController pushViewController:locationController animated:YES];
}

@end
