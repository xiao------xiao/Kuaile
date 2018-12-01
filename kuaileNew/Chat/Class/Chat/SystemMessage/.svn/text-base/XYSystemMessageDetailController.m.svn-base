//
//  XYSystemDetailController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYSystemMessageDetailController.h"
#import "TZOrderMessageCell.h"
#import "XYMessageModel.h"
#import "TZWebViewController.h"
#import "ZYYSnsDetailController.h"
#import "ORSystemMegCell.h"
#import "ICETimeLimitBuyViewController.h"
#import "TZJobDetailViewController.h"
#import "TZJobListViewController.h"

@interface XYSystemMessageDetailController ()

@property (nonatomic, strong) NSMutableArray <XYMessageModel *>*dataArray;

@end

@implementation XYSystemMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    
    
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerCellByNibName:@"TZOrderMessageCell"];
    [self.tableView registerCellByNibName:@"ORSystemMegCell"];

    self.tableView.rowHeight = 160;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        ORSystemMegCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORSystemMegCell" forIndexPath:indexPath];
        [cell loadModelData:self.dataArray[indexPath.row]];
        return cell;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XYMessageModel *model = _dataArray[indexPath.row];
    
    switch (model.data_type.integerValue) {
        case 101: //101抽奖活动
        {
//            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
//            NSString *strURL = [NSString stringWithFormat:@"%@%@", ApiAward, userModel.uid];
//            [self pushWebVcWithUrl:strURL title:@"抽奖活动"];
            
            TZWebViewController *webc = [[TZWebViewController alloc] init];
//            webc.needShare = YES;
            if (model.link_url.length > 0) {
                webc.url = model.link_url;
            }else if(model.html.length > 0) {
                webc.shareModel = model;

                webc.htmlString = model.html;
                webc.isMsgHtml = YES;
            }else {
                webc.htmlString = model.content;
                
                //                 UIFont *font = [UIFont systemFontOfSize:12];
                //                NSString* htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@!important; font-size: %i\">%@</span>",
                //                                        font.fontName,
                //                                        (int) font.pointSize,
                //                                        self.html];
                webc.shareModel = model;

                webc.isMsgHtml = YES;
            }
            webc.title = @"获奖提醒";
            [self.navigationController pushViewController:webc animated:YES];
            
        }
            break;
        case 102: //帖子推荐
        {
            ZYYSnsDetailController *detailVc = [[ZYYSnsDetailController alloc] init];
            detailVc.sid = model.data_id;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 000: //限时抢兑
        {
            ICETimeLimitBuyViewController *iCETimeLimit = [[ICETimeLimitBuyViewController alloc] initWithNibName:@"ICETimeLimitBuyViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:iCETimeLimit animated:YES];
        }
            break;
        case 104: //职位推荐
        {
            TZJobDetailViewController *jobVC = [[TZJobDetailViewController alloc] init];
            jobVC.recruit_id = model.data_id;
            [self.navigationController pushViewController:jobVC animated:YES];
        }
            break;
        case 202: //工作推健
        {
            TZJobListViewController *jobVC = [[TZJobListViewController alloc] init];
            jobVC.type = TZJobListViewControllerTypeSearch;
            jobVC.dic = model.data_content;
            //data_content
//            jobVC.recruit_id = model.data_id;
            [self.navigationController pushViewController:jobVC animated:YES];
        }
            break;
            
        default:
        {
            TZWebViewController *webc = [[TZWebViewController alloc] init];

            if (model.link_url.length > 0) {
                webc.url = model.link_url;
            }else if(model.html.length > 0) {
                webc.htmlString = model.html;
                webc.isMsgHtml = YES;
                
                if (model.data_type.integerValue != 401) {
                    webc.shareModel = model;

                }
                

            }else {
                webc.htmlString = model.content;
                
//                 UIFont *font = [UIFont systemFontOfSize:12];
//                NSString* htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@!important; font-size: %i\">%@</span>",
//                                        font.fontName,
//                                        (int) font.pointSize,
//                                        self.html];
                if (model.data_type.integerValue != 401) {
                    webc.shareModel = model;
                }
                webc.isMsgHtml = YES;
            }
            webc.title = @"系统消息";
            [self.navigationController pushViewController:webc animated:YES];

        }
            break;
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从数据源中删除
    [self removeMsgWith:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
    NSString * mid = self.dataArray[indexPath.row].mid;
    [TZHttpTool postWithURL:ApiDelMessage params:@{@"mid":mid,@"sessionid":sessionid} success:^(NSDictionary *result) {
        [self showInfo:@"删除成功"];
        
    } failure:^(NSString *msg) {
        [self showInfo:@"删除失败"];
    }];
}

- (void)removeMsgWith:(NSInteger)index {
    [self.dataArray removeObjectAtIndex:index];
    ORParentModel *model = [ORParentModel readData];
    if ([self.titleText isEqualToString:@"系统消息"]) {
        model.system_notice = _dataArray;
    }else if ([self.titleText isEqualToString:@"工作通知"]) {
        model.work_notice = _dataArray;
    }else {
        model.account_notice = _dataArray;
    }
    [ORParentModel updateWithModel:model];
}

- (NSMutableArray<XYMessageModel *> *)dataArray {
    if (!_dataArray) {
        
        ORParentModel *model = [ORParentModel readData];
        if ([self.titleText isEqualToString:@"系统消息"]) {
            _dataArray = model.system_notice;
        }else if ([self.titleText isEqualToString:@"工作通知"]) {
            _dataArray = model.work_notice;
        }else {
            _dataArray = model.account_notice;
        }
    }
    return _dataArray;
}

@end
