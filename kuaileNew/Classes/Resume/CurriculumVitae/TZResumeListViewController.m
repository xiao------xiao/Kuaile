//
//  ICECurriculumVitaeViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZResumeListViewController.h"
#import "TZToolBar.h"
#import "TZButton.h"
#import "TZJobApplyView.h"
#import <AddressBookUI/AddressBookUI.h>
#import "TZButtonsHeaderView.h"

// 我的简历cell相关
#import "TZResumeCell.h"
#import "TZResumeModel.h"
#import "TZBottomToolBar.h"
#import "TZPopView.h"

// 我的求职
#import "TZJobListViewController.h"
#import "TZVisitorViewController.h"

#import "TZCraeteResumeControllerNew.h"
#import "TZPreviewResumeController.h"

#import "XYCollectedJobViewController.h"
#import "XYCreateResumeViewController.h"

@interface TZResumeListViewController ()<TZToolBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,TZPopViewDelegate>
@property (nonatomic, strong) TZToolBar *toolBar;
/** tableView相关 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView; // 大scrollView
@property (nonatomic, strong) NSArray *myJobWanted;              // 我的求职tableView相关数据
@property (nonatomic, strong) NSArray *myJobWantedImage;         // 我的求职tableView相关数据
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *models;            // 简历数组
@property (nonatomic, assign) NSInteger row;
/** 没有简历时展示的View */
@property (nonatomic, strong) UIView *noResumeShowingView;
/** 创建简历按钮 */
@property (nonatomic, strong) TZJobApplyView *createResume;
/** 点击设置简历时弹出的View */
@property (nonatomic, strong) TZPopView *settingView;

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) BOOL isShowingAlertView;

@property (nonatomic, strong) TZButtonsBottomView *createView;

@property (assign,nonatomic) ABAddressBookRef addressBook; // 通讯录
@property (strong,nonatomic) NSMutableArray *allPerson;    // 通讯录所有人员
@end

@implementation TZResumeListViewController

/** 这里用懒加载，删除简历时只弹出一个警告框 */
- (UIAlertView *)alertView {
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"确定删除此简历吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}

- (TZPopView *)settingView {
    if (_settingView == nil) {
        _settingView = [[TZPopView alloc] init];
        _settingView.x = 10;
        _settingView.width = __kScreenWidth / 3;
        _settingView.height = 0;
        _settingView.delegate = self;
        [self.view addSubview:self.settingView];
    }
    return _settingView;
}

// 我的求职tableView相关数据
- (NSArray *)myJobWantedImage {
    if (_myJobWantedImage == nil) {
//        _myJobWantedImage = @[@"resume_tdjl",@"resume_visitor",@"resume_collection",@"rusume_recommend"];
        _myJobWantedImage = @[@"toudi",@"shoucang"];
    }
    return _myJobWantedImage;
}

- (NSArray *)myJobWanted {
    if (_myJobWanted == nil) {
        _myJobWanted = @[@"投递记录",@"收藏职位"]; // ,@"推荐职位" 隐藏
    }
    return _myJobWanted;
}

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的简历";
    self.view.backgroundColor = TZControllerBgColor;
    [self configToolBar];
    // 三个scrollView
    [self configBigScrollView];
    [self configLeftScrollView]; // 我的简历
    [self configRightTableView]; // 我的求职
    
    // 请求简历数据
    [self loadNetResumeData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBarButtonClick:) name:@"TZBottomToolBarButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveCreateResumeSuccessful) name:@"haveCreateResumeSuccessful" object:nil];
    self.settingView.hidden = YES;
}

- (void)loadNetResumeData {
    // 请求简历列表数据
    DLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]);
    [TZHttpTool postWithURL:ApiResumeList params:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]} success:^(id json) {
        DLog(@"简历列表获取成功 responseObject %@",json);
        DLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]);
        self.models = [TZResumeModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self configLeftScrollView];
    } failure:^(NSString *error) {
        DLog(@"简历列表获取失败 error %@",error);
        self.models = [NSMutableArray array];
        [self configLeftScrollView];
        [self.leftTableView endRefreshAndReloadData];
    }];
}

- (void)configToolBar {
    TZToolBar *toolBar = [TZToolBar toolBar];
    toolBar.frame = CGRectMake(0, 0, __kScreenWidth, 50);
    toolBar.delegate = self;
    self.toolBar = toolBar;
    [toolBar.leftBtn setTitle:@"我的简历" forState:UIControlStateNormal];
    [toolBar.rightBtn setTitle:@"我的求职" forState:UIControlStateNormal];
    [self.view addSubview:toolBar];
}

- (void)configBigScrollView {
    self.view.backgroundColor = __kColorWithRGBA(248, 248, 248, 1.0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(__kScreenWidth * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

/** 配置我的简历的ScrollView */
- (void)configLeftScrollView {
    UIScrollView *leftScrollView = [[UIScrollView alloc] init];
    leftScrollView.backgroundColor = TZControllerBgColor;
    leftScrollView.frame = CGRectMake(0, 0, __kScreenWidth,__kScreenHeight - 114);

    if (self.models == nil || self.models.count < 1) { // 如果没有简历数据
        self.noResumeShowingView = [[UIView alloc] initWithFrame:CGRectMake((__kScreenWidth - 200)/2, 50, 200, 220)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((200 - 108)/2.0, 60, 108, 30);
        imageView.image = [UIImage imageNamed:@"nodate"];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(-20, 120, 240, 60)];
        lable.lineBreakMode = NSLineBreakByCharWrapping;
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"简历都木有，怎么找工作\n快来创建简历吧！";
        lable.textColor = TZColorRGB(180);
        lable.font = [UIFont systemFontOfSize:17];
        [self.noResumeShowingView addSubview:lable];
        [self.noResumeShowingView addSubview:imageView];
        [leftScrollView addSubview:self.noResumeShowingView];
    } else { // 如果有简历数据
        CGRect frame = CGRectMake(0, 0, __kScreenWidth, leftScrollView.height - 50);
        UITableView *leftTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        leftTableView.rowHeight = 143;
        leftTableView.bounces = NO;
        leftTableView.backgroundColor = TZControllerBgColor;
        leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        leftTableView.showsVerticalScrollIndicator = YES;
        leftTableView.contentSize = CGSizeMake(0, 144 * self.models.count);
        [leftScrollView addSubview:leftTableView];
        self.leftTableView = leftTableView;
    }
    
     //创建按钮
//    _createResume = [[TZJobApplyView alloc] init];
//    [_createResume.button setTitle:@"创建" forState:UIControlStateNormal];
//    [_createResume.button addTarget:self action:@selector(createNewResumu) forControlEvents:UIControlEventTouchUpInside];
//    _createResume.frame = CGRectMake(0, CGRectGetMaxY(leftScrollView.frame) - 50, __kScreenWidth, 50);
//    [leftScrollView addSubview:_createResume];
    
    _createView = [[TZButtonsBottomView alloc] init];
    _createView.btnY = 8;
    _createView.frame = CGRectMake(0, mScreenHeight - 60 - 64 - 50, mScreenWidth, 60);
    _createView.backgroundColor = [UIColor whiteColor];
    _createView.titles = @[@"创建"];
    _createView.bgColors = @[TZColor(49, 196, 249)];
    MJWeakSelf
    [_createView setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        [weakSelf createNewResumu];
    }];
    [leftScrollView addSubview:_createView];
    
    [self.scrollView addSubview:leftScrollView];

}

/** 配置我的求职的tableView */
- (void)configRightTableView {
    CGRect frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth, __kScreenHeight - 114);
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.rowHeight = 50;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = TZControllerBgColor;
    self.rightTableView = rightTableView;
    [self.scrollView addSubview:rightTableView];
}

#pragma mark ToolBar被点击时的代理方法

- (void)toolBar:(TZToolBar *)toolBar didClickButtonWithType:(ToolBarButtonType)buttonType {
    switch (buttonType) {
        case ToolBarButtonTypeLeft: { // 左边按钮  职位信息
            _createView.hidden = NO;
            [UIView animateWithDuration:0.15 animations:^{
                CGPoint point = self.scrollView.contentOffset;
                point.x = 0;
                self.scrollView.contentOffset = point;
            }]; }
            break;
        case ToolBarButtonTypeRight: { // 右边按钮  公司信息
            _createView.hidden = YES;
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
    self.settingView.hidden = YES;
}

#pragma mark tableView的数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.rightTableView) {
        return self.myJobWanted.count;
    } else {
        return self.models.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rightTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = self.myJobWanted[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:self.myJobWantedImage[indexPath.section]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    } else {
        TZResumeCell *cell = [[TZResumeCell alloc] init];
        // cell.backgroundColor =  __kColorWithRGBA(248, 248, 248, 1.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.models[indexPath.section];
        // 配置简历预览的block
        __block NSString *resume_id = cell.model.resume_id;
        cell.previewBlock = ^(){
            TZPreviewResumeController *previewResumeVc = [[TZPreviewResumeController alloc] initWithNibName:@"TZPreviewResumeController" bundle:nil];
            previewResumeVc.resume_id = resume_id;
            [self.navigationController pushViewController:previewResumeVc animated:YES];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rightTableView) {
        switch (indexPath.section) {
            case 0: { // 投递记录
//                TZJobListViewController *jobListHistoryVc = [[TZJobListViewController alloc] init];
//                jobListHistoryVc.jobTitle = @"投递记录";
//                jobListHistoryVc.type = TZJobListViewControllerTypeHistory;
//                [self.navigationController pushViewController:jobListHistoryVc animated:YES];
        
                XYCollectedJobViewController *applyVc = [[XYCollectedJobViewController alloc] init];
                applyVc.titleText = @"投递记录";
                applyVc.type = XYCollectedJobViewControllerTypeApply;
                [self.navigationController pushViewController:applyVc animated:YES];
                
            }    break;
            case 1: { //职位收藏
                XYCollectedJobViewController *collectVc = [[XYCollectedJobViewController alloc] init];
                collectVc.titleText = @"职位收藏";
                collectVc.type = XYCollectedJobViewControllerTypeCollect;
                [self.navigationController pushViewController:collectVc animated:YES];
            }    break;
                
//            case 2:{
//                TZJobListViewController *jobListCollectionVc = [[TZJobListViewController alloc] init];
//                jobListCollectionVc.jobTitle = @"收藏职位";
//                jobListCollectionVc.type = TZJobListViewControllerTypeCollction;
//                [self.navigationController pushViewController:jobListCollectionVc animated:YES];
//            }   break;
            /* 隐藏
            case 3:{ // 推荐职位
                TZJobListViewController *jobListCollectionVc = [[TZJobListViewController alloc] init];
                jobListCollectionVc.jobTitle = @"推荐职位";
                jobListCollectionVc.type = TZJobListViewControllerTypeCollction;
                [self.navigationController pushViewController:jobListCollectionVc animated:YES];
            }   break;
             */
            default:
                break;
        }
    }
    self.row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark 通知方法 (toolBar && 成功创建简历)

- (void)toolBarButtonClick:(NSNotification *)noti {
    NSNumber *buttonType = noti.userInfo[@"type"];
    UIView *view = noti.userInfo[@"view"];
    // 根据每一个cell的Y值，才判断当前是对哪个cell进行操作
    self.row = view.superview.y / 143;
    DLog(@"button frame %@",NSStringFromCGRect(view.superview.frame));
    switch (buttonType.integerValue) {
        case TZBottomToolBarButtonTypeLeft: { // 左边按钮，设置
            if (self.settingView.hidden == NO) {
                [UIView animateWithDuration:0.15 animations:^{ self.settingView.height = 0; self.settingView.hidden = YES; }];
            } else {
                self.settingView.hidden = NO;
                self.settingView.y = 155 * (self.row + 1) + 34 - self.leftTableView.contentOffset.y;
                [UIView animateWithDuration:0.15 animations:^{ self.settingView.height = 86; }];
            }
        }  break;
        case TZBottomToolBarButtonTypeMiddle: { // 中间按钮，编辑
            TZCraeteResumeControllerNew *createResumeVc = [[TZCraeteResumeControllerNew alloc] initWithNibName:@"TZCraeteResumeControllerNew" bundle:nil];
            createResumeVc.returnResumeModel = ^(TZResumeModel *model) {
                [self.models replaceObjectAtIndex:self.row withObject:model];
                [self.leftTableView reloadData];
            };
            TZResumeModel *model = self.models[self.row];
            createResumeVc.model = model;
            createResumeVc.type = TZCreateResumeControllerEdit;
            createResumeVc.resume_id = model.resume_id;
            [self.navigationController pushViewController:createResumeVc animated:YES];
        }   break;
        case TZBottomToolBarButtonTypeRight: { // 右边按钮，删除
            if (!self.isShowingAlertView) {
                [self.alertView show];
                self.isShowingAlertView = YES;
            }
        }  break;
        default:
            break;
    }
}

- (void)haveCreateResumeSuccessful {
    // 重新请求简历数据
    [self loadNetResumeData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark alertView的代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        TZResumeModel *model = self.models[self.row];
        [TZHttpTool postWithURL:ApiDelResume params:@{@"resume_id":model.resume_id,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]} success:^(id json) {
            DLog(@"删除简历成功 %@",json);
            [self showInfo:@"删除简历成功"];
            // 重新请求简历数据
            [self loadNetResumeData];
        } failure:^(NSString *error) {
            DLog(@"删除简历失败 error %@",error);
            [self showInfo:@"删除简历失败"];
        }];
        self.isShowingAlertView = NO;
    }
}

#pragma mark popView的代理方法

- (void)popViewDidClickButton:(TZPopViewButtonType)buttonType {
    switch (buttonType) {
        case TZPopViewButtonTypeLeft: {
            DLog(@"刷新简历"); // 后台也没做。根本不需要这个功能。
            [self showInfo:@"刷新简历成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.15 animations:^{ self.settingView.height = 0; self.settingView.hidden = YES; }];
            });
        }   break;
        case TZPopViewButtonTypeRight: {
            DLog(@"设为默认");
            TZResumeModel *model = self.models[self.row];
            [TZHttpTool postWithURL:ApiSetDefaultResu params:@{ @"resume_id":model.resume_id } success:^(id json) {
                DLog(@"设为默认简历成功 %@",json);
                [self showInfo:@"设为默认简历成功"];
                [self loadNetResumeData];
                [UIView animateWithDuration:0.15 animations:^{ self.settingView.height = 0; self.settingView.hidden = YES; }];
            } failure:^(NSString *error) {
                DLog(@"设为默认简历失败 error %@",error);
                [self showInfo:@"设为默认简历失败"];
                [UIView animateWithDuration:0.15 animations:^{ self.settingView.height = 0; self.settingView.hidden = YES; }];
            }];
        }   break;
        default:
            break;
    }
}

#pragma mark 功能方法（创建简历等）

- (void)createNewResumu {
    
    
    TZCraeteResumeControllerNew *createResumeVc = [[TZCraeteResumeControllerNew alloc] initWithNibName:@"TZCraeteResumeControllerNew" bundle:nil];
    createResumeVc.type = TZCreateResumeControllerNormal;
    createResumeVc.returnResumeModel = ^(TZResumeModel *model){
        [self.models addObject:model];
        [self.noResumeShowingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.noResumeShowingView removeFromSuperview];
        if (self.models.count <= 1) {
            [self configLeftScrollView];
        }
        [self.leftTableView reloadData];
        
        // 检查是否已经把开心工作手机号存到通讯录了，否则提示存储
        [self checkABAuthorizationStatus];
    };
    [self.navigationController pushViewController:createResumeVc animated:YES];
}

#pragma mark - 通讯录

// 检查是否已经把开心工作手机号存到通讯录了，否则提示存储
- (void)checkABAuthorizationStatus {
    ABAuthorizationStatus authorization= ABAddressBookGetAuthorizationStatus();
    // 如果未获得授权
    if (authorization != kABAuthorizationStatusAuthorized) {
        NSLog(@"尚未获得通讯录访问授权！");
        NSString *message = [NSString stringWithFormat:@"您已成功创建简历，为了让开心工作更方便地通知您面试，请允许应用访问手机通讯录，把我们的电话存到您通讯录中"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
            if (x.integerValue == 1) {
                if (authorization == kABAuthorizationStatusDenied) { // 已被拒绝，去开启授权
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else { // 尚未申请权限，去申请权限
                    [self requestAddressBook];
                }
            }
        }];
        [alert show];
    } else {
        [self requestAddressBook];
    }
}

/**
 *  请求访问通讯录
 */
- (void)requestAddressBook{
    // 创建通讯录对象
    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 请求访问用户通讯录,注意无论成功与否block都会调用
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        // 取得通讯录中所有人员记录,如果已有开心工作号码，就不再存储
        CFArrayRef allPeople= ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        self.allPerson=(__bridge NSMutableArray *)allPeople;
        CFRelease(allPeople);
        for (NSInteger i = 0; i < self.allPerson.count; i++) {
            // 取得一条人员记录
            ABRecordRef recordRef=(__bridge ABRecordRef)self.allPerson[i];
           
            NSString *firstName=(__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);//注意这里进行了强转，不用自己释放资源
            
            if ([firstName isEqualToString:@"开心工作"]) {
                return;
            }
        }
        [self addPersonWithFirstName:@"开心工作" workNumber:@"400-692-0099"];
    });
}

/**
 *  添加一条记录
 *
 *  @param firstName  名
 *  @param lastName   姓
 *  @param iPhoneName iPhone手机号
 */
- (void)addPersonWithFirstName:(NSString *)firstName workNumber:(NSString *)workNumber{
    // 创建一条记录
    ABRecordRef recordRef= ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL); // 添加名
    ABMutableMultiValueRef multiValueRef = ABMultiValueCreateMutable(kABStringPropertyType);        // 添加设置多值属性
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(workNumber), kABWorkLabel, NULL); // 添加工作电话
    UIImage *icon = [UIImage imageNamed:@"Icon-76"];
    ABPersonSetImageData(recordRef,(__bridge CFDataRef)UIImageJPEGRepresentation(icon, 0.8),nil);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    // 添加记录
    ABAddressBookAddRecord(self.addressBook, recordRef, NULL);
    // 保存通讯录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    // 释放资源
    CFRelease(recordRef);
    CFRelease(multiValueRef);
}

@end
