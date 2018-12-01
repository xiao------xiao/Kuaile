//
//  TZSegmentTableViewController.h
//  yishipi
//
//  Created by ttouch on 16/9/26.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "TZTableViewController.h"

@interface TZSegmentTableViewController : TZTableViewController

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)configTableView2;

/// 右边tableView
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, assign) NSInteger cellMargin2;
@property (nonatomic, strong) NSMutableArray *models2;
@property (nonatomic, assign) NSInteger page2;
@property (nonatomic, assign) NSInteger totalPage2;
@property (nonatomic, assign) BOOL needRefresh2;
@property (nonatomic, assign) BOOL needHeaderRefresh2;

- (void)refreshDataWithFooter2;
- (void)refreshDataWithHeader2;
- (void)loadNetworkData2;


@end
