//
//  ICELiveServeViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/16.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICELiveServeViewController.h"
#import "ICELiveServerCollectionViewCell.h"
#import "ICEModelLiveServer.h"
#import "ICEGetCityViewController.h"

@interface ICELiveServeViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *_cellDataAry;
}
@end

@implementation ICELiveServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活服务";
    [self loadNetData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"]];
    [self configCollectionView];
    [self configRightItem];
}

- (void)configRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"城市" style:UIBarButtonItemStyleDone target:self action:@selector(pustGetCity)];
}

- (void)pustGetCity {
    ICEGetCityViewController *getCity = [[ICEGetCityViewController alloc] initWithNibName:@"ICEGetCityViewController" bundle:[NSBundle mainBundle]];
    getCity.back = ^(NSString *city){
        self.navigationItem.rightBarButtonItem.title = city;
        [self loadNetData:city];
    };
    [self.navigationController pushViewController:getCity animated:YES];
}

- (void)loadNetData:(NSString *)city {
    RACSignal *sign = [ICEImporter netLifeServiceWithParams:@{ @"city": city }];
    [sign subscribeNext:^(id x) {
        DLog(@"%@", x);
        _cellDataAry = [ICEModelLiveServer mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [self.collectionView reloadData];
    }];
}

- (void)configCollectionView {
    [self.collectionView registerClass:[ICELiveServerCollectionViewCell class] forCellWithReuseIdentifier:@"iCELiveServerCollectionViewCell"];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDataAry.count;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"iCELiveServerCollectionViewCell";
    ICELiveServerCollectionViewCell * cell = (ICELiveServerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell loadDataModel:_cellDataAry[indexPath.row]];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = __kScreenWidth / 3 - 30;
    CGFloat height = 125 * ((__kScreenWidth / 3 - 30) / 100);
    return CGSizeMake(width, height);
}

// 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ICEModelLiveServer *model = _cellDataAry[indexPath.row];
    [self pushWebVcWithUrl:model.url title:model.title];
}

@end
