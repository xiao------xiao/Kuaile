//
//  XYMapViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYMapViewController.h"
#import "XYShowMapResultCell.h"
#import "XYMapResultModel.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

@interface XYMapViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapSearchDelegate,MAMapViewDelegate>{
    BOOL _isSearch;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger selRow;

@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAUserLocationRepresentation *locationRepresentation;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *request;
//@property (nonatomic, strong) AMapPOIAroundSearchRequest *request;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong) UIView *line;
@end

@implementation XYMapViewController


- (MAPointAnnotation *)annotation {
    if (_annotation == nil) {
        _annotation = [[MAPointAnnotation alloc] init];
        [self.mapView addAnnotation:_annotation];
    }
    return _annotation;
}

- (AMapPOIKeywordsSearchRequest *)request {
    if (_request == nil) {
        _request = [[AMapPOIKeywordsSearchRequest alloc] init];
        _request.city = [mUserDefaults objectForKey:@"userCity"];
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        _request.cityLimit = YES;
        _request.requireSubPOIs = YES;
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    [AMapServices sharedServices].apiKey = @"ec6c542ecc7faeaac443d9c2a0b74d67";
    if (!self.lat || !self.lng) {
        self.lat = [[mUserDefaults objectForKey:@"latitude"] doubleValue];
        self.lng = [[mUserDefaults objectForKey:@"longitude"] doubleValue];
    }
    if (self.type == XYMapViewControllerTypeCanHandle) {
        self.rightNavTitle = @"确定";
        _dataSource = [NSMutableArray array];
        self.curPage = 1;
        [self configSearchBar];
    }
    
    [self configMapView];
    if (self.type == XYMapViewControllerTypeCanHandle) {
        [self configLine];
        [self configTableView];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == XYMapViewControllerTypeCanHandle) {
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self zzzz];
    } else {
        [self addPointAnnition];
        [self updateMapViewWithMapModel:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchAPI.delegate = nil;
}

// 刷新地图
- (void)updateMapViewWithMapModel:(XYMapResultModel *)model {
    CLLocationCoordinate2D coor;
    if (model) {
        coor = CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude);
    } else {
        coor = CLLocationCoordinate2DMake(self.lat, self.lng);
    }
    [_mapView setCenterCoordinate:coor animated:YES];
}

- (void)search {
    self.request.keywords = self.searchWord;
    self.request.page = self.curPage;
    self.request.requireExtension = YES;
    [self.searchAPI AMapPOIKeywordsSearch:self.request];
}

- (void)zzzz {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];

    
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.lat longitude:self.lng];
//    request.location            = [AMapGeoPoint locationWithLatitude:29.575035 longitude:106.533865];

//    request.keywords            = @"电影院";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
//    self.request = request;
    [self.searchAPI AMapPOIKeywordsSearch:request];

}

- (void)configSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, mScreenWidth, 44);
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    [self.view addSubview:_searchBar];
}

- (void)configMapView {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    [AMapServices sharedServices].enableHTTPS = YES;
    CGFloat mapViewY = CGRectGetMaxY(_searchBar.frame);
    _mapView = [[MAMapView alloc] init];
    if (self.type == XYMapViewControllerTypeCanHandle) {
        _mapView.frame = CGRectMake(0, mapViewY, mScreenWidth, 280);
    } else {
        _mapView.frame = self.view.bounds;
    }
    _mapView.delegate = self;
    _mapView.zoomLevel = 13.04;
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    _mapView.distanceFilter = 5.0f;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
}

- (void)configLine {
    CGFloat lineY = CGRectGetMaxY(_mapView.frame) - 64;
    _line = [[UIView alloc] init];
    _line.frame = CGRectMake(0, lineY, mScreenWidth, 3);
    _line.backgroundColor = TZColorRGB(220);
    [self.view addSubview:_line];
}

- (void)configTableView {
    CGFloat tableViewY = CGRectGetMaxY(_line.frame);
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, tableViewY, mScreenWidth, mScreenHeight - 64 - tableViewY);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerCellByClassName:@"XYShowMapResultCell"];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
    _tableView.mj_footer = footer;
    [self.view addSubview:_tableView];
}

- (void)refreshDataWithFooter {
    self.curPage ++;
    if (self.curPage > self.totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
       [self search];
    }
}

#pragma mark -- UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYShowMapResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYShowMapResultCell"];
    cell.showSelecteImgView = YES;
    XYMapResultModel *model = self.dataSource[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTileLabel.text = model.address;
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selRow = indexPath.row;
    XYMapResultModel *model = self.dataSource[indexPath.row];
    [self updateMapViewWithMapModel:model];
    self.lat = model.location.latitude;
    self.lng = model.location.longitude;
    [self addPointAnnition];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark --- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    if (searchBar.text.length < 1 || [self.searchWord isEqualToString:searchBar.text]) return;
    _isSearch = YES;
    [self.dataSource removeAllObjects];
    self.searchWord = searchBar.text;
    [self search];
}

#pragma mark -- AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0){
        return;
    } else {
        if (self.curPage == 1) {
            [self.dataSource removeAllObjects];
        }
        self.totalPage = response.count/20;
        [self.dataSource addObjectsFromArray:[XYMapResultModel mj_objectArrayWithKeyValuesArray:response.pois]];
        [self.tableView reloadData];
        [self.tableView endRefresh];
        //如果用户开始搜索，地图默认定位到第一个搜索结果
        if (self.searchWord.length && _isSearch) {
            XYMapResultModel *model = [self.dataSource firstObject];
            [self updateMapViewWithMapModel:model];
            self.lat = model.location.latitude;
            self.lng = model.location.longitude;
            [self addPointAnnition];
        }
    }
}

- (void)addPointAnnition {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.lat, self.lng);
    self.annotation.coordinate = coor;
}

#pragma mark -- MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *poiIdentifier = @"nearbyPointIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil) {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        UIImage *img;
        if (self.type == XYMapViewControllerTypeShow) {
            img = [UIImage imageNamed:@"定位-8 copy"];
        } else {
            img = [UIImage imageNamed:@"定位-8 copy 2"];
        }
        poiAnnotationView.image = img;
        poiAnnotationView.pinColor = MAPinAnnotationColorRed;
        return poiAnnotationView;
    }
    return nil;
}

#pragma mark --- pravite 

- (void)didClickRightNavAction {
    [self.view endEditing:YES];
    XYMapResultModel *model = self.dataSource[self.selRow];
    if (self.didSelecteAddressBlock) {
        self.didSelecteAddressBlock(model.name);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}






@end
