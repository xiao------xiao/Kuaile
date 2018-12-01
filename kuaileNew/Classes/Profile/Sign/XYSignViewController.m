//
//  XYSignViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/17.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSignViewController.h"
#import "XYSignCCell.h"
#import "ORSigningView.h"
#import "TZSnsCreateController.h"

#import "ORLocationManager.h"

@interface XYSignViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, ORSigningViewDelegate, CLLocationManagerDelegate>{
    NSString *_explanationText;
    CLLocationManager *locationManager;
    NSString * locationCityStr;
    CLLocationCoordinate2D location;

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *numArr;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) NSArray<ORSignModel *> *dataArray;

@property (nonatomic, strong) ORSigningView *signView;

@end

@implementation XYSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _explanationText = @"签到说明：\n1、每个用户每天可签到一次，签到积分获取规则：签到获得的积分依据用户每天签到的类型来判断，用户连续签到时，会得到额外的积分奖励。若中断签到，将从初始值开始重新计算。\n2、您可通过积分明细查看当前已获得的积分信息。\n3.您获得的积分可用于限时兑换、抽奖活动，奖品将由开心工作发放，请保持通讯畅通。\n4.若有连续签到送奖品活动，需在活动有效期内满足相应的连续签到天数，才可获得奖品。\n5、该活动最终解释权归开心工作所有。";
    
    [self configScrollView];
    [self configBackBtn];
    [self configCollectionView];
    [self configSignExplanation];
    _numArr = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        NSString *numStr = [NSString stringWithFormat:@"%zd",i+1];
        [_numArr addObject:numStr];
    }
    
    [self loadData];
    
    [self.view addSubview:self.signView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [locationManager startUpdatingLocation];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[ORLocationManager sharedLManager] startLocationWithBlock:^(AMapLocationReGeocode *regeocode, CLLocationCoordinate2D coordinte, NSString *errmsg) {
        locationCityStr = regeocode.formattedAddress;
        NSLog(@"%@ ",locationCityStr);
        location = coordinte;
    }];

}

- (void)loadData {
    [TZHttpTool postWithURL:ApiDeleteSignDate params:nil success:^(NSDictionary *result) {
//        NSLog(@"or......%@", result);
        
        _dataArray = [ORSignModel mj_objectArrayWithKeyValuesArray:result[@"data"] context:nil];
        [self.signView.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[        [ORSignModel currentDateNumber] - 1].icon] placeholderImage:TZPlaceholderImage];
        NSLog(@"12312313%@", self.tips);

        self.signView.tipsLabel.text = self.tips;
        [self.collectionView reloadData];
    } failure:^(NSString *msg) {
        
    }];
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
    _scrollView.backgroundColor = TZColor(255, 248, 236);
//    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIImageView *header = [[UIImageView alloc] init];
    header.frame = CGRectMake(0, 0, mScreenWidth, mScreenWidth * 9 / 15.0);
    header.image = [UIImage imageNamed:@"qiandao_bg"];
    [_scrollView addSubview:header];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((mScreenWidth - 200) / 2, header.height - 21 - 2, 200, 21);
    label.text = @"点击当日即可进行签到";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = TZColor(252, 176, 42);
    [header addSubview:label];
}

- (void)configBackBtn {
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(10, 22, 30, 30);
    [backbtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    CGFloat itemWH = (mScreenWidth - 8 * 2) / 7.0;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, mScreenWidth * 9 / 15.0 + 15, mScreenWidth, itemWH * 5 + 20) collectionViewLayout:layout];
    [_collectionView setContentInset:UIEdgeInsetsMake(0, 2, 0, 2)];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[XYSignCCell class] forCellWithReuseIdentifier:@"XYSignCCell"];
    _collectionView.scrollEnabled = NO;
    [_scrollView addSubview:_collectionView];
}

- (void)configSignExplanation {
    CGFloat extraH;
    if (mScreenWidth == 375) {
        extraH = 80;
    } else if (mScreenWidth == 320){
        extraH = 90;
    } else {
        extraH = 70;
    }
    CGFloat y = CGRectGetMaxY(_collectionView.frame) + 50;
    _explanationLabel = [[UILabel alloc] init];
    NSString *text = _explanationText;
    _explanationLabel.text = text;
    CGFloat textH = [CommonTools sizeOfText:text fontSize:13].height + extraH;
    _explanationLabel.frame = CGRectMake(10, y, mScreenWidth - 20, textH + 10);
    _explanationLabel.font = [UIFont systemFontOfSize:13];
    _explanationLabel.textColor = TZGreyText150Color;
    _explanationLabel.textAlignment = NSTextAlignmentLeft;
    _explanationLabel.numberOfLines = 0;
    [_scrollView addSubview:_explanationLabel];
    CGFloat contentH = CGRectGetMaxY(_explanationLabel.frame) + 20;
    [_scrollView setContentSize:CGSizeMake(mScreenWidth, contentH)];
}


#pragma mark -- UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYSignCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYSignCCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
//    [cell.layer setBorderColor:TZColorRGB(247).CGColor];
//    [cell.layer setBorderWidth:0.5];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ORSignModel *model = self.dataArray[indexPath.row];
    //签到
    if (indexPath.row == [ORSignModel currentDateNumber] - 1) {
        
        if (model.is_sign.integerValue == 1) {
            [self showHint:@"今天已经签到过了"];
        }else {
            [self signAnimationisShow:YES];
        }
    }else {
        [self showHint:@"不符合签到日期"];
    }
    
}

#pragma mark -- ORSignViewDelegate
- (void)normalSignBtnDidPressed {
    
    if (locationCityStr.length <= 0) {
        locationCityStr = @"";
    }
    
    [TZHttpTool postWithURL:ApiDeleteSign params:@{@"lng":@(location.longitude), @"lat":@(location.latitude),@"address": locationCityStr} success:^(NSDictionary *result) {
        self.dataArray[[ORSignModel currentDateNumber] - 1].is_sign = @"1";
        [TZUserManager postUpdateInfoNotification];
        [self.collectionView reloadData];
        [TZUserManager syncUserModel];
        [self showHint:@"签到成功！"];
        [self signAnimationisShow:NO];
    } failure:^(NSString *msg) {
        NSLog(@"aa %@", msg);
    }];

}

- (void)photoSelfBtnDidPressed {
    TZSnsCreateController *vc = [TZSnsCreateController new];
    vc.titleText = @"自拍美拍";
    vc.index = 2;
    
    vc.callBack = ^() {
        [self signAnimationisShow:NO];
        [TZUserManager postUpdateInfoNotification];
        [self loadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)signAnimationisShow:(BOOL)isShow {
    [UIView animateWithDuration:0.3 animations:^{
        self.signView.alpha = isShow ? 1 : 0;
    }];
}

#pragma mark --- private

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (ORSigningView *)signView {
    if (!_signView) {
        _signView = [[NSBundle mainBundle] loadNibNamed:@"ORSigningView" owner:nil options:nil].firstObject;
        _signView.frame = [UIScreen mainScreen].bounds;
        _signView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        _signView.alpha = 0;
        _signView.shadowLabel.hidden = !self.aModel.continue_sign_days.integerValue == 0;
        
        _signView.delegate = self;
    }
    return _signView;
}

@end
