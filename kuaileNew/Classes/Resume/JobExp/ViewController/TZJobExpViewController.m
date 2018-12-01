//
//  ICEJobExpViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZJobExpViewController.h"
#import "TZJobApplyView.h"
#import "TZAddJobExpViewController.h"
#import "TZJobExpCell.h"
#import "TZJobExpModel.h"
#import "TZResumeModel.h"

@interface TZJobExpViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) TZJobApplyView *createResume;
/** 没有工作经验时展示的View */
@property (nonatomic, strong) UIView *noJobExpShowingView;
@property (nonatomic, strong) UIAlertView *alertView;
@end

@implementation TZJobExpViewController

#pragma mark 配置界面和数据

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作经验";
    
    if (self.isEditingJobExp) {
        [self loadNetData];
    } else {
        [self setUpBottomCreateButton];
    }
    [self setUpJobExpList];
    [super configTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)loadNetData {
    [TZHttpTool postWithURL:ApiJobExpList params:@{@"resume_id":self.resume_id,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]} success:^(id json) {
        DLog(@"拿到工作经验数据成功 responseObject %@",json);
        NSArray *array = [TZJobExpModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"exp"]];
        for (TZJobExpModel *model in array) {
            CGFloat height = [model.description boundingRectWithSize:CGSizeMake(__kScreenWidth - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            model.describeHeight = 127 + height - 16;
            // 有新的model，才添加进来
            BOOL isExist = NO;
            for (TZJobExpModel *old_model in self.jobExps) {
                if ([old_model.company_name isEqualToString:model.company_name]) {
                    old_model.describeHeight = model.describeHeight;
                    isExist = YES;
                }
            }
            if (isExist == NO) {
                [self.jobExps addObject:model];
            }
        }
        [self setUpJobExpList];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"拿到工作经验数据失败 responseObject %@",error);
    }];
}

- (void)setUpBottomCreateButton {
    // 创建按钮
    _createResume = [[TZJobApplyView alloc] init];
    [_createResume.button setTitle:@"添加工作经验" forState:UIControlStateNormal];
    [_createResume.button addTarget:self action:@selector(createNewJobExp) forControlEvents:UIControlEventTouchUpInside];
    _createResume.frame = CGRectMake(0, __kScreenHeight - 50 - 64, __kScreenWidth, 50);
    [self.view addSubview:_createResume];
}

- (void)setUpJobExpList {
    if (self.jobExps == nil || self.jobExps.count == 0) { // 如果没有工作经验数据
        self.noJobExpShowingView = [[UIView alloc] initWithFrame:CGRectMake((__kScreenWidth - 200)/2, 50, 200, 220)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resume_noexp"]];
        imageView.frame = CGRectMake(20, 0, 160, 160);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(-20, 160, 240, 60)];
        lable.lineBreakMode = NSLineBreakByCharWrapping;
        lable.numberOfLines = 0;
        
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"增加工作经验,让工作找上你";
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:17];
        [self.noJobExpShowingView addSubview:lable];
        [self.noJobExpShowingView addSubview:imageView];
        [self.view addSubview:self.noJobExpShowingView];
        [self setUpBottomCreateButton];
    } else { // 如果有工作经验数据
        [self.noJobExpShowingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.noJobExpShowingView removeFromSuperview];
        // 编辑简历时,会把 添加工作经验按钮 隐藏 tableView高度会加高50
        CGFloat height = __kScreenHeight - 50 - 64 + 20;
        if (self.isEditingJobExp) {
            height += 50;
        }
        CGRect frame = CGRectMake(0, -20, __kScreenWidth, height);
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        [self setUpBottomCreateButton];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark tableView的数据源和代理

- (void)setJobExps:(NSMutableArray *)jobExps {
    _jobExps = jobExps;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.jobExps.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZJobExpCell *cell = [[TZJobExpCell alloc] init];
    cell.model = self.jobExps[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAddJobExpViewController *addJobExpVc = [[TZAddJobExpViewController alloc] init];
    
    // 如果是简历编辑模式 就 addJobExpVc.isEdit = YES;
    if (self.type == TZJobExpViewControllerTypeEdit) {
        addJobExpVc.isEdit = YES;
    } else {
        addJobExpVc.isEdit = NO;
    }
    // 编辑简历模式，返回和传递整个大数组
    addJobExpVc.jobExps = self.jobExps;
    addJobExpVc.index = indexPath.section;
    addJobExpVc.returnJobExpModels = ^(NSMutableArray *jobExps) {
        self.jobExps = jobExps;
        [self.tableView reloadData];
    };

    [self.navigationController pushViewController:addJobExpVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZJobExpModel *model = self.jobExps[indexPath.section];
    return model.describeHeight;
}

#pragma mark 点击事件

- (void)createNewJobExp {
    TZAddJobExpViewController *addJobExpVc = [[TZAddJobExpViewController alloc] init];
    addJobExpVc.isEdit = NO;
    // 创建简历模式，返回和传递单一条工作经验
    addJobExpVc.returnJobExpModel = ^(TZJobExpModel *model){
        CGFloat height2 = [model.job_desc boundingRectWithSize:CGSizeMake(__kScreenWidth - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        model.describeHeight = 127 + height2 - 16;
        [self.jobExps addObject:model];
        [self setUpJobExpList];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addJobExpVc animated:YES];
}

- (void)done {
    // 返回数据
    if (self.jobExps.count > 0) {
        self.returnJobExps(self.jobExps);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showAlertView]; return;
    }
}

- (void)showAlertView {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"信息未填完将不会保存，确定离开界面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
