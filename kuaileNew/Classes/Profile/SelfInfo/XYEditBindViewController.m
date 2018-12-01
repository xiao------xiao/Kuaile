//
//  XYEditBindViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/30.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYEditBindViewController.h"

@interface XYEditBindViewController ()
@property (nonatomic, assign) CGFloat labelH;
@end

@implementation XYEditBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机";
    [self configPhoneLabel];
    [self configTableView];
}

- (void)configPhoneLabel {
    self.labelH = 70;
    if (mScreenWidth < 375) self.labelH = 60;
    UILabel *phone = [[UILabel alloc] init];
    phone.frame = CGRectMake(0, 0, mScreenWidth, self.labelH);
    phone.backgroundColor = TZControllerBgColor;
    phone.text = [NSString stringWithFormat:@"您当前绑定的手机号是：%@",self.phoneNum];
    phone.textAlignment = NSTextAlignmentCenter;
    phone.font = [UIFont systemFontOfSize:16];
    if (mScreenWidth < 375) {
        phone.font = [UIFont systemFontOfSize:14];
    }
    phone.textColor = TZColorRGB(92);
    [self.view addSubview:phone];
}

- (void)showPopView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消关注" message:@"取消对改用户的关注，确定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)configTableView {
    self.needRefresh = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.labelH, __kScreenWidth, __kScreenHeight - 64 - self.labelH) style:UITableViewStylePlain];
    [self.tableView registerCellByClassName:@"UITableViewCell"];
    self.tableView.backgroundColor = TZControllerBgColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = @[@"原手机号无法使用联系客服",@"原手机号可以接受验证码"][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = TZColorRGB(92);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addBottomSeperatorViewWithHeight:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        [self showPopView];
//    }
    
    [CommonTools callPhoneWithPhoneNumber:@"4006920099"];
}


@end
