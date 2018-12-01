//
//  ICEPointsViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEPointsViewController.h"
#import "TZToolBar.h"
#import "ICEStandingsView.h"
#import "ICESignInView.h"
#import "ICEModelSign.h"
#import "ICESignTableViewCell.h"
#import "ICEPointDescViewController.h"
#import "ICEStandTableViewCell.h"
#import "ICETimeLimitBuyViewController.h"

#import "JZLocationConverter.h"
#import "ICELocationManagerNEW.h"

#import "AppDelegate.h"
#import "LocationViewController.h"
#import "LocationDemoViewController.h"
#import "ICEForgetViewController.h"

@interface ICEPointsViewController () <TZToolBarDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, ICELocationManagerDelegate, LocationViewDelegate>
{
    ICESignInView *_iCESignInView;
    NSArray *_signCellData;
    
    ICEStandingsView *_iCEStandingsView;
    NSArray *_standCellData;
}
@property (nonatomic, strong) TZToolBar *toolBar; ///< 2个选项卡
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; ///< 大scrollView
@end

@implementation ICEPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分";
    _signCellData = [[NSArray alloc] init];
    _standCellData = [[NSArray alloc] init];
    
    [self configToolBar];
    [self configBigScrollView];
    [self configLeftView];
    [self configRightView];
    [self configSignTableView];
    
    [self loadDataWithGetSignInfo];
    [self configSignInViewBtnSign];
    [self loadDataWithSingList];
    
    [self configStandViewTableView];
    [self loadDataWithStandList];
}

- (void)configToolBar {
    _toolBar = [TZToolBar toolBar];
    _toolBar.frame = CGRectMake(0, 0, __kScreenWidth, 50);
    _toolBar.delegate = self;
    [_toolBar.leftBtn setTitle:@"积分" forState:UIControlStateNormal];
    [_toolBar.rightBtn setTitle:@"签到" forState:UIControlStateNormal];
    [self.view addSubview:_toolBar];
}

- (void)configBigScrollView {
    self.view.backgroundColor = __kColorWithRGBA(248, 248, 248, 1.0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(__kScreenWidth * 2, __kScreenHeight- 64 - 50);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}
/** 积分 */
- (void)configLeftView {
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, __kScreenWidth,__kScreenHeight - 64- 50);
    _iCEStandingsView = [[[NSBundle mainBundle] loadNibNamed:@"ICEStandingsView" owner:nil options:nil] lastObject];
    _iCEStandingsView.frame = leftView.bounds;
    [leftView addSubview:_iCEStandingsView];
    [self.scrollView addSubview:leftView];
    
    [[_iCEStandingsView.btnStandDesc rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICEPointDescViewController *iCEPointDesc = [[ICEPointDescViewController alloc] initWithNibName:@"ICEPointDescViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:iCEPointDesc animated:YES];
    }];
    [[_iCEStandingsView.btnStandConvert rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICETimeLimitBuyViewController *iCETimeLimit = [[ICETimeLimitBuyViewController alloc] initWithNibName:@"ICETimeLimitBuyViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:iCETimeLimit animated:YES];
    }];
}

- (void)configStandViewTableView {
    _iCEStandingsView.tableView.dataSource = self;
    _iCEStandingsView.tableView.delegate = self;
}
/** 积分数据 */
- (void)loadDataWithStandList{
    RACSignal *sign = [ICEImporter pointRecordWithPage:@"1"];
    [sign subscribeNext:^(id x) {
        _standCellData = [ICEModelSign mj_objectArrayWithKeyValuesArray:x[@"data"][@"content"]];
        _iCEStandingsView.latStandPoint.text = [NSString stringWithFormat:@"%@分",x[@"data"][@"user_point"]];
        [_iCEStandingsView.tableView reloadData];
    }];
}

/** 签到View*/
- (void)configRightView {
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(__kScreenWidth, 0, __kScreenWidth,__kScreenHeight - 64- 50);
    _iCESignInView = [[[NSBundle mainBundle] loadNibNamed:@"ICESignInView" owner:nil options:nil] lastObject];
    _iCESignInView.frame = rightView.bounds;
    [rightView addSubview:_iCESignInView];
    [self.scrollView addSubview:rightView];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    if ([userModel.rid isEqualToString:@"7"]) {
        [_iCESignInView.btnSign setTitle:@"业务员签到" forState:UIControlStateNormal];
    }
}
/** 配置签到列表*/
- (void)configSignTableView {
    _iCESignInView.tableView.dataSource = self;
    _iCESignInView.tableView.delegate = self;
}
/** 获取签到信息 */
- (void)loadDataWithGetSignInfo {
    RACSignal *sign = [ICEImporter isSign];
    [sign subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        _iCESignInView.btnSign.enabled = NO;
        [_iCESignInView.btnSign setTitle:@"今日已经签到!" forState:UIControlStateNormal];
        _iCESignInView.btnSign.backgroundColor = kCOLOR_BIANKUANG;
    }];
}
/** 配置签到按钮 */
- (void)configSignInViewBtnSign {
    [[_iCESignInView.btnSign rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ICELoginUserModel *user = [ICELoginUserModel sharedInstance];
        if ([user.rid isEqualToString:@"8"]) {
            [self mySignInGiftsWithParams:@"" lat:@"" lng:@""];
        } else {
            [self baiduLocation];
        }
    }];
}

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
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        if (![userModel.rid isEqualToString:@"7"]) {
            _iCESignInView.btnSign.enabled = NO;
            [_iCESignInView.btnSign setTitle:@"今日已经签到!" forState:UIControlStateNormal];
            _iCESignInView.btnSign.backgroundColor = kCOLOR_BIANKUANG;
        }
        [self loadDataWithSingList];
        _iCESignInView.btnSign.enabled = YES;
    } error:^(NSError *error) {
        [self showInfo:error.domain];
        _iCESignInView.btnSign.enabled = YES;
    }];
}

/** 签到数据 */
- (void)loadDataWithSingList {
    RACSignal *sign = [ICEImporter signRecordWithPage:@"1"];
    [sign subscribeNext:^(id x) {
        _signCellData = [ICEModelSign mj_objectArrayWithKeyValuesArray:x[@"data"][@"content"]];
        [_iCESignInView.tableView reloadData];
    }];
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
    if ([scrollView isEqual:_scrollView]) {
        CGPoint offSet = scrollView.contentOffset;
        if (offSet.x <= (__kScreenWidth * 0.5)) { // 此时自动回左边，让职位信息成被选中状态
            self.toolBar.showLeftBtn = YES;
        } else if (offSet.x > (__kScreenWidth * 0.5)) { // 此时自动回左边，让公司信息成被选中状态
            self.toolBar.showRightBtn = YES;
        }
    }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_iCESignInView.tableView isEqual:tableView]) {
        return _signCellData.count;
    } else {
        return _standCellData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_iCESignInView.tableView isEqual:tableView]) {
        static NSString *iden = @"iCESignTableViewCell";
        ICESignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICESignTableViewCell" owner:self options:nil] lastObject];
        }
        ICEModelSign *model = _signCellData[indexPath.row];
        cell.labDesc.text = [ICETools standardTime:model.time];
        if (![model.point isEqualToString:@"0"]) {
            cell.labPoint.text = [NSString stringWithFormat:@"%@", model.point];
        } else {
            cell.labPoint.text = model.content;
        }
        return cell;
    } else {
        static NSString *idensss = @"iCEStandTableViewCell";
        ICEStandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idensss];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEStandTableViewCell" owner:self options:nil] lastObject];
        }
        ICEModelSign *model = _standCellData[indexPath.row];
        cell.labTime.text = [ICETools standardTime:model.time];
        if (![model.point isEqualToString:@"0"]) {
            cell.latPoint.text = [NSString stringWithFormat:@"%@", model.point];
        } else {
            cell.latPoint.hidden = YES;
        }
        cell.labContent.text = model.content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_iCESignInView.tableView isEqual:tableView]) {
        return 64;
    } else {
        return 60;
    }
    
}

#pragma mark - 用户签到

- (void)baiduLocation {
    LocationDemoViewController *locationController = [[LocationDemoViewController alloc] init];
    [locationController setDidGetLocationInfoBlock:^(double lat, double lng, NSString *address) {
        [self mySignInGiftsWithParams:address lat:[@(lat) stringValue] lng:[@(lng) stringValue]];
    }];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address {
    [self hideHud];
    DLog(@"%lf, %lf, %@", latitude, longitude, address);
    CLLocationCoordinate2D location = (CLLocationCoordinate2D){
        .latitude  = latitude,
        .longitude = longitude
    };
    //将WGS-84转为GCJ-02(火星坐标)
    CLLocationCoordinate2D gcjLocation = [JZLocationConverter wgs84ToGcj02:location];
    // 将WGS-84转转为百度坐标:
    CLLocationCoordinate2D bdLocation = [JZLocationConverter wgs84ToBd09:location];
    
    //    NSNumber *numLat = @(bdLocation.latitude);
    //    NSString *strLat = [numLat stringValue];
    //    NSNumber *numLng = @(bdLocation.longitude);
    //    NSString *strLng = [numLng stringValue];
    // 地址
    //    NSString *newAddress = [ICETools AddressMessage:strLat withlon:strLng];
    // 高德坐标
    NSNumber *numLatGD = @(gcjLocation.latitude);
    NSString *strLatGD = [numLatGD stringValue];
    NSNumber *numLngGD = @(gcjLocation.longitude);
    NSString *strLngGD = [numLngGD stringValue];
    [self mySignInGiftsWithParams:address lat:[@(latitude) stringValue] lng:[@(longitude) stringValue]];
}

@end
