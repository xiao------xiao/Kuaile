//
//  XYApplyRecordViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/22.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYApplyRecordViewController.h"
#import "XYJobCell.h"

@interface XYApplyRecordViewController ()

@end

@implementation XYApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投递记录";
    self.rightNavTitle = @"编辑";
}



- (void)configTableView {
    self.needRefresh = YES;
    [super configTableView];
    [self.tableView registerCellByNibName:@"XYJobCell"];
    self.tableView.rowHeight = 130;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYJobCell"];
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //
        
    }];
    return @[deleteAction];
}

#pragma mark -- private

- (void)didClickRightNavAction {
    if ([self.rightNavTitle isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES];
        self.rightNavTitle = @"完成";
    } else if ([self.rightNavTitle isEqualToString:@"完成"]) {
        self.rightNavTitle = @"编辑";
        [self.tableView setEditing:NO];
    }
    
}

@end
