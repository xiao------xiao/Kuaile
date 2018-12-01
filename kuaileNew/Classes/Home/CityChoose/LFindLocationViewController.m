//
//  LFindLocationViewController.m
//  OMCN
//
//  Created by 邓杰豪 on 15/8/10.
//  Copyright (c) 2015年 doudou. All rights reserved.
//

#import "LFindLocationViewController.h"

#import "LCCollectionViewCell.h"
#import "PooSearchBar.h"
#import "LCityModels.h"
#import <MapKit/MapKit.h>

#define INTERFACE_IS_PAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IOS8after [[[UIDevice currentDevice] systemVersion] floatValue] >= 8

static NSString * const reuseIdentifiers = @"Cell";

@interface LFindLocationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
{
    NSDictionary *provinces;
    NSArray *cities;
    NSMutableArray *arr;
    UICollectionView *attachedCellCollection;
    PooSearchBar *searchBar;//顶部搜索
    NSMutableArray *tempArray;
    BOOL isSearch;
    UITableView *searchHistory_tb; //搜索后的搜索选项列表
    UIButton *whereBtn;
    CLLocationManager *locationManager;
    NSString *whereStr;
    
    NSMutableArray *storeCities;
    
}
@property (nonatomic,retain) UIButton *currentCityBtn;
@end

@implementation LFindLocationViewController

#pragma mark 配置界面

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    whereStr = @""; //当前选择的城市或者定位的城市字符串

    searchBar = [[PooSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 44)];
    searchBar.barStyle     = UIBarStyleDefault;
    searchBar.translucent  = YES;
    searchBar.delegate     = self;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.searchPlaceholder = @"输入城市名快速查找";
    searchBar.searchPlaceholderColor = __kColorWithRGBA1(122, 122, 122);
    searchBar.searchPlaceholderFont = [UIFont systemFontOfSize:13];
    searchBar.searchTextColor = __kColorWithRGBA1(22, 22, 22);
    searchBar.searchBarImage = [UIImage imageNamed:@"searchbar_textfield_background"];
    searchBar.searchTextFieldBackgroundColor = __kColorWithRGBA1(253, 253, 253);
    searchBar.searchBarOutViewColor = [UIColor clearColor];
    searchBar.searchBarTextFieldCornerRadius = 0;
    
    self.navigationItem.titleView = searchBar;

    searchHistory_tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    searchHistory_tb.dataSource = self;
    searchHistory_tb.delegate = self;
    searchHistory_tb.showsHorizontalScrollIndicator = NO;
    searchHistory_tb.showsVerticalScrollIndicator = NO;
    searchHistory_tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchHistory_tb.sectionIndexBackgroundColor = [UIColor clearColor];
    searchHistory_tb.sectionIndexMinimumDisplayRowCount = 33;
    searchHistory_tb.sectionIndexColor = __kColorWithRGBA1(124, 124, 124);
    [self.view addSubview:searchHistory_tb];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    storeCities = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i<23; i++) {
            for (NSString *str in  provinces[arr[i]]) {
                LCityModels * newCity = [[LCityModels alloc] init];
                NSMutableDictionary *lllll = [[NSMutableDictionary alloc] init];
                [lllll setObject:str forKey:@"cities"];
                newCity.cityNAme = lllll[@"cities"];
                NSMutableString *ms = [[NSMutableString alloc] initWithString:newCity.cityNAme];
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    
                }
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                    newCity.letter = ms;
                }
                [storeCities addObject:newCity];
            }
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    provinces = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citydict.plist" ofType:nil]];
//    provinces = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.db" ofType:nil]];

    tempArray = [[NSMutableArray alloc] init];
    arr = [[NSMutableArray alloc] initWithArray:@[@"热门",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"]];
    cities = provinces[arr[0]]; //热门城市
    
    
    [self reLoadLoction];
}

#pragma mark UITableView相关

 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (isSearch) {
       return nil;
    }
    return arr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isSearch) {
        return 1;
    }
    return provinces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return tempArray.count;
    }
    cities = provinces[arr[section]];
    if (section == 0) {
        return 2;
    }
    return cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (isSearch) {
        return 1;
    }
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearch) {
        return 40;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 150;
        }else{
            return 40;
        }
    }else{
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (isSearch) {
        return 0.0000001;
    }
    
    return section == 0 ? 88 : 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (isSearch) {
            return nil;
        } else {
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88)];
            titleView.backgroundColor = [UIColor whiteColor];
            
            whereBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            whereBtn.frame = CGRectMake(10, 0, self.view.frame.size.width-120, 40);
            [whereBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            whereBtn.titleLabel.font = fontBig;
            [whereBtn addTarget:self action:@selector(userTap:) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:whereBtn];
            self.currentCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            self.currentCityBtn.frame = CGRectMake(10, 44+(44-30)/2, 74, 30);
//            self.currentCityBtn.layer.masksToBounds = YES;
//            self.currentCityBtn.layer.cornerRadius = 10;
            [self.currentCityBtn setBackgroundImage:[UIImage imageNamed:@"square_city_sel"] forState:UIControlStateNormal];
            [self.currentCityBtn.titleLabel setFont:fontMid];
            [self.currentCityBtn setTitleColor:kCOLOR_WHITE forState:UIControlStateNormal];
            [self.currentCityBtn setTitle:self.loctionCity forState:UIControlStateNormal];
            
            [titleView addSubview:self.currentCityBtn];
            if (self.loctionCity) {
                [whereBtn setTitleColor:color_darkgray forState:UIControlStateNormal];
//                [whereBtn setTitle:[NSString stringWithFormat:@"定位城市:%@",self.loctionCity] forState:UIControlStateNormal];
                [whereBtn setTitle:@"定位城市" forState:UIControlStateNormal];
                whereBtn.userInteractionEnabled = YES;
                self.currentCityBtn.hidden = NO;
            } else {
                [whereBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [whereBtn setTitle:@"正在定位中..." forState:UIControlStateNormal];
                whereBtn.userInteractionEnabled = NO;
                self.currentCityBtn.hidden = YES;
            }
            
            UIButton * tapBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [tapBtn.titleLabel setFont:fontMid];
            tapBtn.frame = CGRectMake(self.view.frame.size.width-110, 44+(44-30)/2, 90, 35);
            [tapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [titleView addSubview:tapBtn];
            tapBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [tapBtn setTitle:@"重新定位" forState:UIControlStateNormal];
            [tapBtn setTitleColor:TZMainColor forState:UIControlStateNormal];
            [tapBtn setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
//            [tapBtn setBackgroundColor:TZMainColor];
            [tapBtn addTarget:self action:@selector(reLoadLoction) forControlEvents:UIControlEventTouchUpInside];
            
            tapBtn.layer.cornerRadius = 3;
            tapBtn.clipsToBounds = YES;
            
         
            
            
            return titleView;
        }
    } else {
        NSString *HeaderString = arr[section];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        titleView.backgroundColor = TZColorRGB(246);

        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
        HeaderLabel.font = fontBig;
        HeaderLabel.textColor = color_darkgray;
        HeaderLabel.text = HeaderString;
        
        [titleView addSubview:HeaderLabel];
//        titleView.backgroundColor = [UIColor purpleColor];
        return titleView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cities = provinces[arr[indexPath.section]];
    NSInteger height = 40;

    UITableViewCell *cell = nil;
    static NSString *searchIdentifier = @"cell_id";
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
    } else  {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    LCityModels * city;
    if (isSearch) {
        city = [tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [city.cityNAme stringByReplacingOccurrencesOfString:@"市" withString:@""];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkGrayColor];
         [cell addSubview:[UIView divideViewWithHeight:height]];
    }  else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.backgroundColor = __kColorWithRGBA1(246, 246, 246);

                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 40)];
                titleLabel.textColor = color_darkgray;
                titleLabel.font = fontBig;
                titleLabel.text = @"热门城市";
                [cell.contentView addSubview:titleLabel];
                
                
            }
            
            else if (indexPath.row == 1) {
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                if (INTERFACE_IS_PAD) {
                    layout.itemSize = CGSizeMake(126, 45);
                } else {
                    layout.itemSize = CGSizeMake((self.view.frame.size.width-30-30)/3, 31);
                }
                CGFloat paddingY                   = 5;
                CGFloat paddingX                   = 5;
                layout.sectionInset                = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
                layout.minimumLineSpacing          = paddingY;
                
                height = 150;

                attachedCellCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 150) collectionViewLayout:layout];
                
                attachedCellCollection.backgroundColor                = [UIColor whiteColor];
                attachedCellCollection.dataSource                     = self;
                attachedCellCollection.delegate                       = self;
                attachedCellCollection.showsHorizontalScrollIndicator = NO;
                attachedCellCollection.showsVerticalScrollIndicator   = NO;
                attachedCellCollection.pagingEnabled                  = NO;
                [attachedCellCollection registerClass:[LCCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifiers];
                attachedCellCollection.tag                            = 0;
                attachedCellCollection.scrollEnabled                  = NO;
                [cell.contentView addSubview:attachedCellCollection];
            }
        } else {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [[cities objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"市" withString:@""];
            [cell addSubview:[UIView divideViewWithHeight:height]];
        }
    }
   
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [_delegete cityViewdidSelectCity:cell.textLabel.text anamation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    cities = provinces[arr[0]];
    
    switch (collectionView.tag) {
        case 0: {
            return cities.count;
        }   break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifiers forIndexPath:indexPath];
    
   
    cities = provinces[arr[0]];
    
    switch (collectionView.tag) {
        case 0: {
            cell.cellTitle.text = [cities objectAtIndex:indexPath.row];
        }   break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    cities = provinces[arr[0]];
    [_delegete cityViewdidSelectCity:[cities objectAtIndex:indexPath.row] anamation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark searchBarDelegete

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [tempArray removeAllObjects];
    if (searchText.length == 0) {
        isSearch = NO;
    } else {
        isSearch = YES;
        for (LCityModels * city in storeCities) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [tempArray addObject:city];
            }
            else if (letters.location != NSNotFound) {
                [tempArray addObject:city];
            }
        }
    }
    [searchHistory_tb reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    isSearch = NO;
}

- (void)userTap:(id)sender {
    [searchBar resignFirstResponder];
    if (whereStr == nil || whereStr.length < 1) return;
    [_delegete cityViewdidSelectCity:whereStr anamation:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reLoadLoction {
    [whereBtn setTitle:@"正在定位中..." forState:UIControlStateNormal];
    self.currentCityBtn.hidden = YES;
    [whereBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter  = 5.0f;
    [locationManager startUpdatingLocation];
    
    if (IOS8after) {
        [locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    // 保存经纬度信息
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.latitude) forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(newLocation.coordinate.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            whereStr = placemark.locality;
            whereStr = [whereStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
//            [whereBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [whereBtn setTitle:[NSString stringWithFormat:@"定位城市:%@",whereStr] forState:UIControlStateNormal];
            
//            whereBtn.userInteractionEnabled = YES;
            self.currentCityBtn.hidden = NO;
            [self.currentCityBtn setTitle:whereStr forState:UIControlStateNormal];
            // 如果whereStr为空 做一些操作
            if (whereStr == nil || [whereStr isEqualToString:@""] || whereStr.length < 1) {
                whereStr = @"无锡";
            }
            
            // 保存定位获得的用户城市信息
            [[NSUserDefaults standardUserDefaults] setObject:whereStr forKey:@"userCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateToLocation" object:self];
        }
    }];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
    [whereBtn setTitle:@"定位失败，请重试" forState:UIControlStateNormal];
    self.currentCityBtn.hidden = YES;
    NSString *locationAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationAuthority"];
    if ([locationAuthority isEqualToString:@"NO"]) {
        [self showInfo:@"定位失败,请打开定位权限"];
    } else {
        [self showInfo:@"定位失败"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"locationAuthority"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"locationAuthority"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (!isSearch) {
        [searchBar resignFirstResponder];
    }
}

#pragma mark 新增方法 by谭真

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [searchBar endEditing:YES];
}

@end

