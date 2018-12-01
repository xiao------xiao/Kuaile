//
//  TZJobDetailViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobDetailViewController.h"
#import "TZToolBar.h"
#import "TZJobModel.h"
#import "TZButton.h"
#import "TZJobBodyCell.h"
#import "TZJobTitleCell.h"
#import "TZJobContactCell.h"

#import "TZCompanyIntroduceCell.h"
#import "TZCompanyTitleCell.h"
#import "TZCompanyTitleModel.h"
#import "TZBottomToolView.h"
#import "TZJobListCell.h"

#import "TZJobListViewController.h"
#import <MessageUI/MessageUI.h>
#import "ICELoginViewController.h"
#import "TZNaviController.h"
#import "LocationViewController.h"
#import "ChatViewController.h"

#import "XYDetailListCell.h"
#import "XYJobCommentCell.h"
#import "XYJobCommentModel.h"
#import "XYCheckMoreCell.h"
#import "XYJobCommentViewController.h"
#import "XYResumeListViewController.h"
#import "XYCreateResumeViewController.h"

#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>

@interface TZJobDetailViewController ()<TZToolBarDelegate,UIScrollViewDelegate,TZBottomToolViewDelegate,TZJobContactCellDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,TZJobBodyCellDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView; // 大scrollView
@property (nonatomic, strong) UIScrollView *leftScrollView;

/** 职位信息的三个View */
@property (nonatomic, strong) TZJobBodyCell *bodyView;
@property (nonatomic, strong) TZJobTitleCell *titleView;
@property (nonatomic, strong) TZJobContactCell *contactView;

/** 公司信息的两个View */
@property (nonatomic, strong) TZCompanyTitleCell *cmyTitleView;
@property (nonatomic, strong) TZCompanyIntroduceCell *cmyIntroView;

@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) TZToolBar *toolBar;
@property (nonatomic, strong) TZBottomToolView *toolView;
@property (nonatomic, strong) NSArray *jobs;

@property (nonatomic, strong) NSArray *jobComments;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) XYCheckMoreCell *checkMoreView;
@property (nonatomic, strong) XYDetailListCell *commentHeaderView;

@property (nonatomic, strong) UITextField *commentField;

@property (nonatomic, strong, getter=getGiftView) ICEGiftView *giftView;
@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;


@property(nonatomic,strong) NSString * shareContent;
@property(nonatomic,strong) NSString * recruit_name;
@end

@implementation TZJobDetailViewController


#pragma mark 懒加载和配置界面
- (TZJobContactCell *)contactView {
    if (_contactView == nil) {
        _contactView = [[TZJobContactCell alloc] init];
        _contactView.frame = CGRectMake(0, CGRectGetMaxY(self.bodyView.frame) + 10, __kScreenWidth, 62);
        _contactView.delegate = self;
    }
    return _contactView;
}

- (TZJobBodyCell *)bodyView {
    if (_bodyView == nil) {
        _bodyView = [[TZJobBodyCell alloc] initWithJobIntroduce:self.model.job_desc welfare:self.model.welfare];
        _bodyView.delegate = self;
        MJWeakSelf
        [_bodyView setBlockChangeViewH:^(CGRect frame) {
            _bodyView.frame = frame;
            _contactView.frame = CGRectMake(0, CGRectGetMaxY(frame) +10, __kScreenWidth, 64 + 53);
            CGFloat headerY = CGRectGetMaxY(_contactView.frame) + 14;
            _commentHeaderView.frame = CGRectMake(0, headerY, mScreenWidth, 44);
            CGFloat commentTableViewY = CGRectGetMaxY(_commentHeaderView.frame)+1;
            _commentTableView.frame = CGRectMake(0, commentTableViewY, mScreenWidth, self.tableViewHeight);
            
            CGFloat maxY = 0;
            if (self.jobComments.count) {
                CGFloat moreViewY = CGRectGetMaxY(_commentTableView.frame);
                weakSelf.checkMoreView.frame = CGRectMake(0, moreViewY, mScreenWidth, 44);
                maxY = CGRectGetMaxY(weakSelf.checkMoreView.frame) + 20;
                _leftScrollView.contentSize = CGSizeMake(0, maxY);
            } else {
                maxY = CGRectGetMaxY(_commentTableView.frame) + 20;
                _leftScrollView.contentSize = CGSizeMake(0, maxY);
            }
        }];
    }
    return _bodyView;
}

- (TZJobTitleCell *)titleView {
    if (_titleView == nil) {
        _titleView = [[TZJobTitleCell alloc] init];
        __weak TZJobDetailViewController *detailVc = self;
        _titleView.showInfoMessageBolck = ^(NSString *info){
            [detailVc showInfo:info];
        };
    }
    return _titleView;
}

- (TZCompanyTitleCell *)cmyTitleView {
    if (_cmyTitleView == nil) {
        _cmyTitleView = [[TZCompanyTitleCell alloc] init];
        _cmyTitleView.frame = CGRectMake(0, 0, __kScreenWidth, 320);
        
         __weak typeof(self) weakSelf = self;
        _cmyTitleView.openMapBlock = ^(){
            // 若点击了定位图片。则拿到经纬度信息，跳页面，打开加载地图
            double lat = (double)[weakSelf.companyModel.lat floatValue];
            double lng = (double)[weakSelf.companyModel.lng floatValue];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = lat;
            coordinate.longitude = lng;
            LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:coordinate];
            [weakSelf.navigationController pushViewController:locationController animated:YES];
        };
    }
    return _cmyTitleView;
}

- (TZCompanyIntroduceCell *)cmyIntroView {
    if (_cmyIntroView == nil) {
        _cmyIntroView = [[TZCompanyIntroduceCell alloc] initWithCompanyIntroduce:self.companyModel.desc];
    }
    return _cmyIntroView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightNavImageName = @"分享-8 copy";
    self.leftNavImageName = @"navi_back";
    [self loadNetJobDetailData];
    [self configJobDetailBar];
    [self configScrollView];
    self.view.backgroundColor = __kColorWithRGBA(246, 246, 246, 1.0);
}
#pragma mark - Getters And Setters
-(void)didClickRightNavAction {
    [self showSheet];
    [self showPhotoActionSheet];
    [self configGiftBtn];
    
}

- (void)didClickLeftNavAction {
    if (self.pushFromScanVc) {
        NSArray *vcArr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcArr[0] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configGiftBtn {
    [[self.getGiftView.btnQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQ];
    }];
    [[self.getGiftView.btnWeChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiSession];
    }];
    [[self.getGiftView.btnSina rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeSinaWeibo];
    }];
    [[self.getGiftView.btnQzone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQSpace];
    }];
    [[self.getGiftView.btnWeChatFriend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiTimeline];
    }];
    [[self.getGiftView.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}


- (void)shareButtonClickHandler:(ShareType)type
{
    UIImage *shareImage = [UIImage imageNamed:@"Icon-40"];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiJobShare,self.recruit_id]];
    NSString *share = [self.shareContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString * shareContent = [share substringToIndex:48];
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    
    NSString *shareTitle = [NSString stringWithFormat:@"%@-%@-%@-开心工作",self.companyModel.name,self.recruit_name,self.model.address];
    
    if (self.companyModel.logo.length > 0) {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyModel.logo]]];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupWeChatParamsByText:shareContent title:shareTitle url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    NSInteger typeInt = type;
    SSDKPlatformType shareType = typeInt;
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
        BOOL ret = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
        if (ret) {
            [[UIViewController currentViewController] showTextHUDWithStr:@"分享中..."];
        }
    }
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            [[UIViewController currentViewController] showSuccessHUDWithStr:@"分享成功"];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            [ICEImporter shareIntegralWithParams:params];
        } else if (state == SSDKResponseStateFail) {
            NSLog(@"分享失败! %@",error);
            [[UIViewController currentViewController] showErrorHUDWithError:@"分享失败"];
        } else if (state == SSDKResponseStateCancel) {
            NSLog(@"取消分享 %@",userData);
        }
        [[UIViewController currentViewController] hideTextHud];
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}
- (void)showSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [self.backView addSubview:self.sheetView];
    [self.sheetView addSubview:self.giftView];
}
/** 显示 */
- (void)showPhotoActionSheet {
    CGRect frame = self.sheetView.frame;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        DLog(@"完成");
    }];
}

/** 隐藏 */
- (void)cancelAnimation:(void (^)(void))comple {
    CGRect frame = self.sheetView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (comple) {
            comple();
        }
        [self.backView removeFromSuperview];
    }];
}

#pragma mark - Getters And Setters
- (ICEGiftView *)getGiftView {
    if (_giftView == nil) {
        _giftView = [[ICEGiftView alloc] init];
        _giftView.frame = CGRectMake(0, 0, __kScreenWidth, 300);
    }
    return _giftView;
}
/** 底板SheetView*/
- (UIView *)getSheetView{
    if (_sheetView == nil) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300);
        _sheetView = [[UIView alloc] initWithFrame:frame];
        _sheetView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sheetView;
}

- (UIView *)getBackView{
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.alpha = 0;
    }
    return _backView;
}

- (void)configBottomToolView {
    self.toolView = [[TZBottomToolView alloc] init];
    self.toolView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 50, __kScreenWidth, 50);
    self.toolView.delegate = self;
    self.toolView.views.text = [NSString stringWithFormat:@"已有%@人浏览",self.model.looks];
    [self.view addSubview:self.toolView];
}

- (void)configScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(__kScreenWidth * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

/** 加载职位详情网络数据 */
- (void)loadNetJobDetailData {
    NSDictionary *params = @{@"recruit_id":self.recruit_id};
    
    
    
    [TZHttpTool postWithURL:ApiRecruitInfo params:params success:^(id json) {
        self.jobComments = [XYJobCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"comment"]];
        NSInteger count = self.jobComments.count > 5 ? 5 : self.jobComments.count;
        CGFloat tableViewHeight = 0;
        for (int i = 0; i < count; i++) {
            XYJobCommentModel *model = self.jobComments[i];
            tableViewHeight += model.cellHeight;
        }
        self.tableViewHeight = tableViewHeight;
        
        self.model = [TZJobModel objectWithKeyValues:json[@"data"][@"recruit"]];
        self.model.fan = self.fanXian;
        self.shareContent = self.model.job_desc;
        self.recruit_name = self.model.recruit_name;
        self.companyModel = [TZCompanyTitleModel objectWithKeyValues:json[@"data"][@"company"]];
        self.companyModel.verify = self.model.verify;
        self.companyModel.name = self.model.company_name;
        self.model.company_industry = self.companyModel.company_industry;
        self.model.company_scope = self.companyModel.company_scope;
        self.title = self.model.company_name;
        [_commentTableView reloadData];
        [_commentTableView endRefresh];
        [self loadCompanyOtherJobs];
        // 是否已经被收藏 0 未收藏 1已收藏
        NSNumber *collectionType = json[@"data"][@"type"];
        self.haveCollection = collectionType.integerValue == 0 ? NO : YES;
        
    } failure:^(NSString *error) {
        [_commentTableView endRefresh];
        DLog(@"职位详情获取失败 error,%@",error);
    }];
}

- (void)loadCompanyOtherJobs {
    [TZHttpTool postWithURL:ApiGetOthers params:@{@"uid":self.companyModel.uid} success:^(id json) {
        _jobs = [NSArray array];
        _jobs = [TZJobModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"others"]];
        [self configJobScrollView];
        [self configCompanyScrollView];
        [self configBottomToolView];
    } failure:^(NSString *msg) {
        
    }];
}


- (void)configJobDetailBar {
    TZToolBar *toolBar = [TZToolBar toolBar];
    toolBar.frame = CGRectMake(0, 0, __kScreenWidth, 50);
    toolBar.delegate = self;
    self.toolBar = toolBar;
    [toolBar.leftBtn setTitle:@"职位信息" forState:UIControlStateNormal];
    [toolBar.rightBtn setTitle:@"公司信息" forState:UIControlStateNormal];
    [self.view addSubview:toolBar];
}

/** 配置职位信息的ScrollView */
- (void)configJobScrollView {
    _leftScrollView = [[UIScrollView alloc] init];
    _leftScrollView.frame = CGRectMake(0, 0, __kScreenWidth,__kScreenHeight - 114 - 50);
    UIImageView *certifyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth-45-90, 10, 80, 75)];
    certifyImgView.image = [UIImage imageNamed:@"JobDetail_yrz"];
    [_leftScrollView addSubview:self.titleView];
    self.titleView.model = self.model;
    self.titleView.haveCollection = self.haveCollection;
    [_leftScrollView addSubview:self.bodyView];
    self.bodyView.model = self.model;

    [_leftScrollView addSubview:self.contactView];
    [_leftScrollView addSubview:certifyImgView];
    // self.contactView.model = self.model;
    self.contactView.contact_name.text = self.model.contact;
    self.contactView.contact_tel.text = self.model.phone;
    
    CGFloat headerY = CGRectGetMaxY(self.contactView.frame) + 16;
    _commentHeaderView = [[XYDetailListCell alloc] init];
    _commentHeaderView.frame = CGRectMake(0, headerY, mScreenWidth, 44);
    _commentHeaderView.backgroundColor = [UIColor whiteColor];
    _commentHeaderView.text = @"职位评论";
    _commentHeaderView.more.hidden = YES;
    [_leftScrollView addSubview:_commentHeaderView];
    
    CGFloat commentTableViewY = CGRectGetMaxY(_commentHeaderView.frame)+1;
    _commentTableView = [[UITableView alloc] init];
    _commentTableView.frame = CGRectMake(0, commentTableViewY, mScreenWidth, self.tableViewHeight);
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTableView.tableFooterView = [UIView new];
    _commentTableView.scrollEnabled = NO;
    [_commentTableView registerCellByNibName:@"XYJobCommentCell"];
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftScrollView addSubview:_commentTableView];
    
    if (self.jobComments.count) {
        CGFloat moreViewY = CGRectGetMaxY(_commentTableView.frame);
        _checkMoreView = [[XYCheckMoreCell alloc] init];
        _checkMoreView.backgroundColor = [UIColor whiteColor];
        _checkMoreView.frame = CGRectMake(0, moreViewY, mScreenWidth, 44);
        _checkMoreView.button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkMoreView configButtonWithImg:@"genduo" text:@"查看更多"];
        MJWeakSelf
        [_checkMoreView setDidClickBtnBlock:^{
            XYJobCommentViewController *jobCommentVc = [[XYJobCommentViewController alloc] init];
            jobCommentVc.recruit_id = weakSelf.recruit_id;
            [weakSelf.navigationController pushViewController:jobCommentVc animated:YES];
        }];
        [_leftScrollView addSubview:_checkMoreView];
        CGFloat maxY = CGRectGetMaxY(self.checkMoreView.frame) + 20;
        _leftScrollView.contentSize = CGSizeMake(0, maxY);
    } else {
        _leftScrollView.contentSize = CGSizeMake(0, commentTableViewY + self.tableViewHeight + 20);
    }
    [self.scrollView addSubview:_leftScrollView];
    
    // 一开始展开福利和工作详情列表
    [self.bodyView clickMoreComWelfare:self.bodyView.welfareMoreBtn];
    [self.bodyView clickMoreWorkDec:self.bodyView.descMoreBtn];
}

/** 配置公司信息的ScrollView */
- (void)configCompanyScrollView {
    UIScrollView *rightScrollView = [[UIScrollView alloc] init];
    rightScrollView.frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth, __kScreenHeight - 114 - 50);
    [rightScrollView addSubview:self.cmyTitleView];
    self.cmyTitleView.model = self.companyModel;
    [rightScrollView addSubview:self.cmyIntroView];
    self.cmyIntroView.introduce.text = self.companyModel.desc;
    if (self.jobs.count <= 0) {
        self.cmyIntroView.otherJobTipLbl.text = @"公司暂无其他职位";
    }
    // 该公司的其他职位
    UITableView *otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cmyIntroView.frame), mScreenWidth, 185 * self.jobs.count)];
    otherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    otherTableView.delegate = self;
    otherTableView.dataSource = self;
    [rightScrollView addSubview:otherTableView];
    rightScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(otherTableView.frame) + 10);
    rightScrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:rightScrollView];
}

#pragma mark - tableView的数据源/代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _commentTableView) {
        XYJobCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"XYJobCommentCell"];
        XYJobCommentModel *model = self.jobComments[indexPath.row];
        commentCell.model = model;
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [commentCell addBottomSeperatorViewWithHeight:1];
        return commentCell;
    } else {
        static NSString *ID = @"jobList_cell";
        TZJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TZJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.model = self.jobs[indexPath.row];
        cell.type = TZJobListCellTypeHighSalary;
        [cell addSubview:[UIView divideViewWithHeight:cell.height]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _commentTableView) {
        return self.jobComments.count > 5 ? 5 : self.jobComments.count;
    } else {
       return self.jobs.count;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _commentTableView) {
        //
    } else {
        // 跳转到详情控制器
        TZJobDetailViewController *detailVc = [[TZJobDetailViewController alloc] initWithNibName:@"TZJobDetailViewController" bundle:nil];
        TZJobModel *model = self.jobs[indexPath.row];
        detailVc.recruit_id = model.recruit_id;
        detailVc.uid = model.uid;
        [self.navigationController pushViewController:detailVc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _commentTableView) {
        XYJobCommentModel *model = self.jobComments[indexPath.row];
        return model.cellHeight;
    } else {
        TZJobModel *model = self.jobs[indexPath.row];
        if ([model.fan isEqualToString:@"1"]) {
            return 181;
        } else {
            return 133;
        }
    }
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

#pragma mark TZBottomToolViewDelegate 底部工具条的按钮点击

- (void)bottomToolViewClickButtonType:(TZBottomToolViewButtonType)type {
    
    
     // 1. 先判断登录，未登录则先登录
    if (![TZUserManager isLogin]) return;
    switch (type) {
        case TZBottomToolViewButtonTypeApply: { // 申请
            
            // 2. 申请职位
            
//            NSInteger haveResume = [[mUserDefaults objectForKey:@"NoResume"] integerValue];
            if ([TZUserManager getUserModel].resume_phone.length <= 0) {
                [self showAlertViewWithTitle:@"提示" message:@"未创建简历，是否前往创建简历简历" cancelBtnHandle:^{
                    
                } okBtnHandle:^{
                    
                    XYCreateResumeViewController *createVc = [[XYCreateResumeViewController alloc] init];
                    createVc.type = XYCreateResumeViewControllerTypeNormal;
                    [self.navigationController pushViewController:createVc animated:YES];
                    
                }];
                return;
            }
//            TZResumeModel *model = [TZUserManager getUserDefaultResume];
            NSString *haveDefaultResume = [mUserDefaults objectForKey:@"defaultResume"];
//            if (haveDefaultResume.integerValue != 1) {
//                [self showAlertViewWithTitle:@"提示" message:@"未设置简历，是否前往设置默认简历" cancelBtnHandle:^{
//        
//                } okBtnHandle:^{
//                    XYResumeListViewController *resumeList = [[XYResumeListViewController alloc] init];
//                    [self.navigationController pushViewController:resumeList animated:YES];
//                }];
//                return;
//            }
            NSDictionary *params = @{@"recruit_id":self.model.recruit_id,@"sessionid":[mUserDefaults objectForKey:@"sessionid"]};
            [TZHttpTool postWithURL:ApiSnsDeliver params:params success:^(id json) {
                [self showInfo:@"投递成功"];
            } failure:^(NSString *error) {
                DLog(@"简历投递失败 %@",error);
                [self showInfo:error];
            }];
        }   break;
//        case TZBottomToolViewButtonTypeCall:  // 电话
//            DLog(@"电话");
//            [self callToHr:self.model.company_tel];
//            break;
        case TZBottomToolViewButtonTypeService:// 在线客服
            DLog(@"在线客服");
            [self skipChatView];
            break;
        case TZBottomToolViewButtonTypeComment: {
            UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"请输入评论内容" message:nil delegate:self];
            self.commentField = [alertView textFieldAtIndex:0];
            self.commentField.keyboardType = UIKeyboardTypeDefault;
            [alertView show];
        } break;
        default:
            break;
    }
}

-(void) skipChatView {
    ChatViewController *serviceVc = [[ChatViewController alloc] initWithChatter:@"ttouch" conversationType:eConversationTypeChat];
    serviceVc.titleText = @"开心客服";
    [self.navigationController pushViewController:serviceVc animated:YES];
}
#pragma mark TZJobContactCellDelegate 联系人Cell的按钮点击

- (void)contactCellDidClickButton:(TZJobContactCellButtonType)type {
    switch (type) {
        case TZJobContactCellButtonCall: { // 电话
            
            [self callToHr:self.model.phone];
        }   break;
        case TZJobContactCellButtonMail: { // 邮件
            DLog(@"邮件");
            [self mailToHr];
        }   break;
        default:
            break;
    }
}
// 职位信息界面的视图代理方法
-(void)TZJobBodyCellButtonClicked:(TZJobBodyCellType)type {
    switch (type) {
        case TZJobBodyButtonLocation: // 定位视图
            [self skipLocationView];
            break;
        case TZJobBodyButtonSyndicate: // 公司详情页视图
            [self toolBar:self.toolBar didClickButtonWithType:ToolBarButtonTypeRight];
            break;
        default:
            break;
    }
}


#pragma mark 私有方法

/** 打电话 */
- (void)callToHr:(NSString *)phone {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

/** 发邮件 */
- (void)mailToHr {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            [mailPicker setToRecipients:[NSArray arrayWithObject:self.model.rece_mail]];
            [mailPicker setSubject:[NSString stringWithFormat:@"我对该职位感兴趣"]];
            
            NSString *emailBody = @"您好，我是XXX，我对贵公司的XXX职位感兴趣。";
            [mailPicker setMessageBody:emailBody isHTML:NO];
            [self presentViewController:mailPicker animated:YES completion:nil];
        }
        else  {
            [self showInfo:@"您的设备尚未配置邮件账号"];
        }
    } else {
        [self showInfo:@"您的设备不支持邮件功能"];
    }
}

//跳转到定位视图
-(void)skipLocationView {
    __weak typeof(self) weakSelf = self;
    double lat = (double)[weakSelf.companyModel.lat floatValue];
    double lng = (double)[weakSelf.companyModel.lng floatValue];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:coordinate];
    [weakSelf.navigationController pushViewController:locationController animated:YES];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"已将邮件加入到队列中，正在发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self showInfo:msg];
}

/// 被present出来的，显示返回按钮
- (void)showBack {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(actionBackLeft) image:@"navi_back" highImage:@"navi_back"];
}
- (void)actionBackLeft {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self sendCommentData];
    }
}

// 评论职位
- (void)sendCommentData {
//    sessionid	是	string
//    recruit_id	是	int	职位id
//    company_id
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    params[@"recruit_id"] = self.recruit_id;
    params[@"company_id"] = self.companyModel.uid;
    params[@"content"] = self.commentField.text;
    [TZHttpTool postWithURL:ApiCommentJob params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"评论成功"];
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:@"评论失败"];
    }];
}

@end
