//
//  GroupPeopleViewController.m
//  kuaile
//
//  Created by 胡光健 on 2017/4/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "GroupPeopleViewController.h"
#import "HJZanListModel.h"
#import "GroupPeopleCell.h"
@interface GroupPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation GroupPeopleViewController
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群成员";
    
    [self createConfigUI];
    [self refreshHeaderLoadeDateWork];
    
}

-(void)refreshHeaderLoadeDateWork {
    NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
    [TZHttpTool postWithURL:ApiSnsGetGroupAllMembers params:@{@"sessionid":sessionid,@"gid":self.gid} success:^(NSDictionary *result) {
        NSArray * array = [HJGroupPeopleModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSString *msg) {
        [self showHint:@"获取失败"];
    }];
}

-(void)createConfigUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupPeopleCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    HJGroupPeopleModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

@end
