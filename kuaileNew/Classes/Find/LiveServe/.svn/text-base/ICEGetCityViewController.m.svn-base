//
//  ICEGetCityViewController.m
//  kuaile
//
//  Created by ttouch on 15/11/20.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEGetCityViewController.h"
#import "XYCityModel.h"

#define RowFilePath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"row.file"]])

@interface ICEGetCityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *ary;
@property (nonatomic, strong) NSMutableArray *rows;
@end

@implementation ICEGetCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市";
    [self loadNetData];
    [self configUITableView];
}

- (NSMutableArray *)rows {
    if (!_rows) {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

- (void)loadNetData {
    _ary = [TZUserManager getCityModels];
    if (!_ary) {
         [TZUserManager syncCityModelArrayComplete:^(NSArray *models) {
             _ary = models;
         }];
    }
}

- (void)configUITableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSMutableArray *rows = [NSKeyedUnarchiver unarchiveObjectWithFile:RowFilePath];
    if ([rows containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    XYCityModel *model = _ary[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellAry = [tableView visibleCells];
    for (UITableViewCell *cell in cellAry) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    XYCityModel *model = _ary[indexPath.row];
    if (self.rows.count > 0) {
        [self.rows removeAllObjects];
    }
    [self.rows addObject:@(indexPath.row)];
    [NSKeyedArchiver archiveRootObject:self.rows toFile:RowFilePath];
    if (self.back) {
        _back(model.title);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


@end
