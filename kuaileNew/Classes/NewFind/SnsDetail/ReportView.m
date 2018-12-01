//
//  ReportView.m
//  kuaile
//
//  Created by 胡光健 on 2017/3/15.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "ReportView.h"


@interface ReportView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@end
@implementation ReportView
-(instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        self.backgroundColor = __kColorWithRGBA(83, 83, 83, 0.5);
        [self createUIView];
    }
    
    return self;
}
-(void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    if (!titleArray) {
        titleArray = [NSArray array];
    }
    [self.tableView reloadData];
}
-(void)setSid:(NSString *)sid {
    _sid = sid;
    
}
-(void)createUIView {
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(20, mScreenHeight /4, mScreenWidth - 50, 40)];
    headView.backgroundColor = __kColorWithRGBA(39, 180, 244, 1);
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 3, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:__kColorWithRGBA(39, 180, 244, 1)];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cancelBtn];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth  /2 - 40, 5, 40, 21)];
    label.text = @"举报";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:label];
 
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, mScreenHeight /4, mScreenWidth - 50, 305) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = headView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.tableView];
}


#pragma mark --UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (self.titleArray[indexPath.row] > 0) {
        cell.textLabel.text = self.titleArray[indexPath.row];
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView removeFromSuperview];
    [self removeFromSuperview];

    NSString * reason = self.titleArray[indexPath.row];
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    NSDictionary * params = @{@"sid":_sid,@"reason":reason,@"sessionid":str};

    [TZHttpTool postWithURL:ApiSnsReportSns params:params success:^(NSDictionary *result) {

        NSLog(@"%@",result);
    } failure:^(NSString *msg) {
        NSLog(@"%@",msg);
    }];

}

-(void)cancleButtonClicked {
    [self.tableView removeFromSuperview];
    [self removeFromSuperview];
}
@end
