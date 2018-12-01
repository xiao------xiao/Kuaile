//
//  XYCommentLikeController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCommentLikeController.h"
#import "XYCommentLikeCell.h"
#import "ZYYSnsDetailController.h"
#import "XYMessageModel.h"
#import "ORCommentLikeCell.h"

@interface XYCommentLikeController ()

@property (nonatomic, strong) NSMutableArray <XYMessageModel *>*dataArray;
@property(nonatomic,assign)BOOL isDelete;
@end

@implementation XYCommentLikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    self.view.backgroundColor = TZColorRGB(246);
}

- (void)configTableView {
    self.needRefresh = YES;
    self.isDelete = NO;
    [super configTableView];
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:@"ORCommentLikeCell" bundle:nil] forCellReuseIdentifier:@"ORCommentLikeCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self loadData];
    
}

//- (void)loadData {
//    NSString *type = [self.titleText isEqualToString:@"评论"] ? @"301" : @"302";
//    
//    [TZHttpTool postWithURL:ApiDeletefetMessageList params:@{@"data_type" : type} success:^(NSDictionary *result) {
//        _conversions = [XYMessageModel mj_objectArrayWithKeyValuesArray:result[@"data"] context:nil];
//        [self.tableView reloadData];
//        
//    } failure:^(NSString *msg) {
//        NSLog(@"%@", msg);
//    }];
//    
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORCommentLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORCommentLikeCell" forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.row];

    [cell addBottomSeperatorViewWithHeight:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYYSnsDetailController *detailVc = [[ZYYSnsDetailController alloc] init];
    detailVc.sid = _dataArray[indexPath.row].data_id;
    [self.navigationController pushViewController:detailVc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * mid = self.dataArray[indexPath.row].mid;

    // 从数据源中删除
    [self removeMsgWith:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiDelMessage params:@{@"mid":mid,@"sessionid":sessionid} success:^(NSDictionary *result) {
        [self showInfo:@"删除成功"];
        
    } failure:^(NSString *msg) {
        [self showInfo:@"删除失败"];
    }];
}

- (void)removeMsgWith:(NSInteger)index {
    [self.dataArray removeObjectAtIndex:index];
    ORParentModel *model = [ORParentModel readData];
    if ([self.titleText isEqualToString:@"评论"]) {
        model.comment_notice = _dataArray;
    }else {
        model.zan_notice = _dataArray;
    }
    
    [ORParentModel updateWithModel:model];
}

- (NSMutableArray<XYMessageModel *> *)dataArray {
    if (!_dataArray) {
        
        ORParentModel *model = [ORParentModel readData];
        if ([self.titleText isEqualToString:@"评论"]) {
            _dataArray = model.comment_notice;
        }else {
            _dataArray = model.zan_notice;
        }        
    }
    return _dataArray;
}


@end
