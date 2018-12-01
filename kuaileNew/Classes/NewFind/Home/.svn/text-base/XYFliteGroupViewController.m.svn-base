//
//  XYFliteGroupViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYFliteGroupViewController.h"
#import "XYLastSearchCell.h"
#import "XYCommontView.h"
#import "XYConfigTool.h"

@interface XYFliteGroupViewController ()

@property (nonatomic, strong) XYConfigTool *tagTool;
@property (nonatomic, strong) XYConfigTool *peopleTool;
@property (nonatomic, strong) NSMutableArray *clickArray;
@property (nonatomic, copy) NSString *tagText;
@property (nonatomic, copy) NSString *peopleText;
///是否显示边框
@property (nonatomic, assign) BOOL showBorder;
/// 默认为YES
@property (nonatomic, assign) BOOL hideBorderWhenSelected;

@property (nonatomic, assign) BOOL isSingleRow;

@end

@implementation XYFliteGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选群组";
    self.rightNavTitle = @"确定";
    self.navigationItem.rightBarButtonItem.enabled = self.selectedIndexes.count;
    self.showBorder = YES;
    self.isSingleRow = NO;
    self.hideBorderWhenSelected = YES;
}
-(NSMutableArray *)clickArray {
    if (!_clickArray) {
        _clickArray = [NSMutableArray array];
    }
    return _clickArray;
}
- (void)prepareData {
    _tagTool = [[XYConfigTool alloc] init];
    _tagTool.configArr = @[@"求职",@"偶遇",@"电影",@"企业",@"工作",@"约聊",@"LOL",@"DOTA2",@"唱歌",@"桌球",@"健身"];
//    _peopleTool = [[XYConfigTool alloc] init];
//    _peopleTool.configArr = @[@"由低到高",@"由高到低"];
    [self.tableView reloadData];
}

- (void)configTableView {
    self.needRefresh = NO;
    [super configTableView];
    [self.tableView registerCellByClassName:@"XYLastSearchCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XYCommontView *view = [[XYCommontView alloc] init];
    view.frontText = @[@"标签"][section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tagTool.configArrH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYLastSearchCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"XYLastSearchCell"];
    tagCell.scrollViewBgColor = [UIColor whiteColor];
    tagCell.showBorder = YES;
    tagCell.scrollView.scrollEnabled = NO;
    if (indexPath.section == 0) {
        tagCell.searches = _tagTool.configArr;
        tagCell.selectedIndexes = self.selectedIndexes;
        [tagCell setSelecteBtnBlock:^(NSArray *indexes){
            self.navigationItem.rightBarButtonItem.enabled = indexes.count;
            self.clickArray = indexes;
        }];
    }

    return tagCell;
}


#pragma mark -- 右边按钮点击筛选事件
- (void)didClickRightNavAction {
    NSMutableString *str = [NSMutableString string];
    if (self.clickArray.count) {
        for (int i = 0; i < self.clickArray.count; i++) {
            NSInteger tag = [self.clickArray[i] integerValue];
            [str appendFormat:@"%@,",_tagTool.configArr[tag]];
        }
        self.tagText = [str substringToIndex:str.length - 1];
        MJWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didClickConformItemBlock) {
                self.didClickConformItemBlock(self.tagText,self.clickArray);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
