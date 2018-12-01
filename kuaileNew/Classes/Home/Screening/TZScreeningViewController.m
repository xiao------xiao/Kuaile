//
//  TZScreeningViewController.m
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "TZScreeningViewController.h"
#import "TZPopSelectView.h"
#import "TZFullTimeJobViewController.h"
#import "SourceCell.h"
#import "FilterNormalCell.h"
static const NSString *sourceCellIdentify = @"SourceCell";
static const NSString *filterCellIdentify = @"FilterNormalCell";
@interface TZScreeningViewController ()<UITableViewDataSource,UITableViewDelegate,TZPopSelectViewDelegate>
/** tableView相关 */
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *ok;
@property (nonatomic, strong) NSArray *cellTitles1;
@property (nonatomic, strong) NSArray *cellTitles2;
@property (nonatomic, strong) NSMutableArray *cellDetails2;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
/** selectView相关 */
@property (nonatomic, weak) TZPopSelectView *selectView;
@property (nonatomic, weak) UIButton *cover;
/** 输入框相关 */
@property (nonatomic, strong) UIAlertView *keywordAlertView;
@property (nonatomic, strong) UITextField *keywordField;
@property (nonatomic,strong) NSArray * sourceArray;
@end

@implementation TZScreeningViewController

#pragma mark 配置界面和加载数据

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClick)];
    self.sourceArray = @[@"全部",@"开心直招",@"企业直招",@"代招"];
    self.cellTitles1 = @[@"职位分类",@"区域",@"薪资",@"福利",@"信誉度",@"经验",@"来源"];
    [self configTableView];
    [self setUpPopselectView];
   
}

- (void)configTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = __kColorWithRGBA(246, 246, 246, 1.0);
    
      [self.tableView registerNib:[UINib nibWithNibName:@"SourceCell" bundle:nil] forCellReuseIdentifier:sourceCellIdentify];
     [self.tableView registerNib:[UINib nibWithNibName:@"FilterNormalCell" bundle:nil] forCellReuseIdentifier:filterCellIdentify];
//    // 如果外面没有赋值过来，才设初值【赶集也是这么做的】
//    if (self.resultDic == nil|| self.resultDic.count < 6) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//
//        [dic setObject:@"不限" forKey:@"job"];//默认 不限
//        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userCity"] forKey:@"area"];//默认
//        [dic setObject:@"不限" forKey:@"salary"];//默认 不限
//        [dic setObject:@"不限" forKey:@"welfare"];//默认 不限
//        [dic setObject:@"不限" forKey:@"trustDegree"];//默认 不限
//        [dic setObject:@"不限" forKey:@"exp"];//默认 不限
//        [dic setObject:@"不限" forKey:@"origin"];//默认 不限
//        self.resultDic = dic;
//    }
}

- (void)setUpPopselectView {
    TZPopSelectView *selectView = [[TZPopSelectView alloc] init];
    CGFloat height = 44 * (self.selectView.options.count + 1);
    selectView.frame = CGRectMake(30, __kScreenHeight + 64 + 100, __kScreenWidth - 60, height);
    selectView.hidden = YES;
    selectView.delegate = self;
    self.selectView = selectView;
    
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor lightGrayColor];
    cover.alpha = 0.4;
    cover.frame = CGRectMake(0, __kScreenHeight, __kScreenWidth, __kScreenHeight);
    self.cover = cover;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:cover];
    [self.navigationController.view addSubview:selectView];
}

#pragma mark 按钮的点击事件

- (IBAction)okButtonClick {
    // 返回数据给上个控制器，调用block
    
    self.returnScreeningInfoBlock(self.resultDic,self.laid,self.isHotJobType);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    
    NSLog(@"zhangying  ---TZScreeningviewcontroller  dealloc");
    
}
#pragma mark tableView的数据源和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellTitles1.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<6){
    return 58;
    }else if (indexPath.row == 6){  //来源
        return 152+20;
    }else{
        return  58;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row <6){
        
        FilterNormalCell *cell = (FilterNormalCell *)[tableView dequeueReusableCellWithIdentifier:filterCellIdentify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lblname.text = self.cellTitles1[indexPath.row];
        NSString *detailStr =@"";
        switch (indexPath.row) {
            case 0:
                detailStr = self.resultDic[@"job"];
                break;
            case 1:
                detailStr = self.resultDic[@"area"];
                break;
            case 2:
                detailStr = self.resultDic[@"salary"];
                break;
            case 3:
                detailStr = self.resultDic[@"welfare"];
                break;
            case 4:
                detailStr = self.resultDic[@"trustDegree"];
                break;
            case 5:
                detailStr = self.resultDic[@"exp"];
                break;
            case 6:
                detailStr = @"";
                break;
            default:
                break;
        }
       
        cell.lbldetail.text = detailStr;
        [cell addSubview:[UIView divideViewWithHeight:cell.height]];
        return cell;
    }else if (indexPath.row == 6) {
        SourceCell *cell = (SourceCell *)[tableView dequeueReusableCellWithIdentifier:sourceCellIdentify];
//        cell.accessoryType = UITableViewCellAccessoryNone;
        MJWeakSelf
        
        cell.originStr = NotNullStr(self.resultDic[@"origin"]);
        cell.buttonBlock = ^(int index) {
            [weakSelf changeOption:index];
        };
        return cell;
    }else{
        static NSString *cellIdentify = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
         MJWeakSelf
        UIButton *searchButton = [PublicView createLoginNormalButtonWithTitle:@"搜索"];
        
        [[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf okButtonClick];
        }];
        [cell addSubview:searchButton];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).offset(7);
            make.left.mas_equalTo(cell.mas_left).offset(35);
            make.right.mas_equalTo(cell.mas_right).offset(-35);
            make.height.mas_equalTo(44);
        }];
        return cell;
    }
//        UISegmentedControl * _segment = [[UISegmentedControl alloc]initWithItems:self.sourceArray];
//        _segment.frame = CGRectMake(__kScreenWidth / 3.4 - 10, cell.contentView.centerY/2.315, 300 * mScreenWidth / 414, 30);
//        _segment.selectedSegmentIndex = 0;
//        [_segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 * mScreenWidth / 375]} forState:UIControlStateNormal];
//        _segment.backgroundColor = [UIColor whiteColor];
//        _segment.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:39 green:179 blue:246 alpha:1.0]);
//        _segment.tintColor = __kColorWithRGBA(39, 179, 246, 1.0);
//        [_segment addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventValueChanged];
//        [cell.contentView addSubview:_segment];
    
//    if (indexPath.row == 7) {
//        //添加一个搜索按钮
//
//
//        return cell;
//    }
    
    // 添加分隔线

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        switch (indexPath.row) {
            case 0: {  // 职位分类
                TZFullTimeJobViewController *fullTimeVc = [[TZFullTimeJobViewController alloc] initWithNibName:@"TZFullTimeJobViewController" bundle:nil];
                fullTimeVc.type = TZFullTimeJobViewControllerJobType;
                // 初始化returnJobType的block
                fullTimeVc.returnJobType = ^(NSString *jobType,NSString *laid,TZFullTimeJobType laidOrClassJobType) {
                    self.laid = laid;
                    self.isHotJobType = laidOrClassJobType == TZFullTimeJobTypeHot ? YES : NO;
                    if (![jobType isEqualToString:@""] && jobType != nil) { // 输入不为空才刷新
                        [self.resultDic setObject:jobType forKey:@"job"];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                };
                [self.navigationController pushViewController:fullTimeVc animated:YES];
               
            }  break;
            case 1: { // 区域
                 [self showPopSelectedViewWithArray:[TZCitisManager getCitis]];
                
            }  break;
            case 2: { // 薪资
                [self showPopSelectedViewWithArray:@[@"不限",@"面议",@"2000元/月以下",@"2001-3000元/月",@"3001-5000元/月",@"5001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15001-25000元/月",@"25001元/月以上"]];
                
            }  break;
            case 3: { // 福利
                [self showPopSelectedViewWithArray:self.welfares];
               
            }  break;
            case 4: { //  信誉度
                 [self showPopSelectedViewWithArray:@[@"不限",@"1星",@"2星",@"3星",@"4星",@"5星"]];
                
            }  break;
            case 5: { //经验
                [self showPopSelectedViewWithArray:@[@"不限",@"无经验",@"1年以下",@"1~3年",@"3~5年",@"5~10年",@"10年以上"]];
                
            }  break;
//            case 6: { // 来源
////                [self showPopSelectedViewWithArray:@[@"全部",@"开心直招",@"企业直招",@"代招"]];
//            }  break;
            default:
                break;
        }
        self.selectView.labTitle.text = self.cellTitles1[indexPath.row];
    
    self.row = indexPath.row;
    self.section = indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

#pragma mark --  segment点击事件
-(void)changeOption:(int)tagIndex{ // 0 全部  1 开心直招

    [self.resultDic setObject:self.sourceArray[tagIndex] forKey:@"origin"];
  
}

//-(void)changeOption:(UISegmentedControl *)segment {
//    NSLog(@"%@",self.sourceArray[segment.selectedSegmentIndex]);
//    [self.resultDic setObject:self.sourceArray[segment.selectedSegmentIndex] forKey:@"origin"];
//
//
//}
#pragma mark 弹出选择框相关

- (void)showPopSelectedViewWithArray:(NSArray *)options {
    self.selectView.options = [NSMutableArray arrayWithArray:options];;
    self.selectView.hidden = NO;
    // [UIView animateWithDuration:0.25 animations:^{ // 动画已取消
    self.cover.y = 0;
    self.selectView.y = 64 + 100;
    CGFloat maxHeight = __kScreenHeight - 180;
    self.selectView.height = 44 * (self.selectView.options.count + 1) > maxHeight ? maxHeight : 44 * (self.selectView.options.count + 1);
    self.selectView.y = (__kScreenHeight - self.selectView.height)/2;
    // }];
}

- (void)coverClick {
    self.selectView.hidden = YES;
    // [UIView animateWithDuration:0.25 animations:^{ // 动画已取消
    self.cover.y = __kScreenHeight;
    self.selectView.y = __kScreenHeight + (__kScreenHeight - 64 - self.selectView.height)/2;
    // }];
}

#pragma mark 选择框代理方法 TZPopSelectViewDelegate

- (void)popSelectViewDidClickCancleButton {
    [self coverClick];
}

- (void)popSelectViewDidSelectedCell:(NSString *)cellName index:(NSInteger)index {
    switch (self.row) {
        case 1:
            [self.resultDic setObject:cellName forKey:@"area"];
            break;
        case 2:
            [self.resultDic setObject:cellName forKey:@"salary"];
            break;
        case 3:
            [self.resultDic setObject:cellName forKey:@"welfare"];
            break;
        case 4:
            [self.resultDic setObject:cellName forKey:@"trustDegree"];
            break;
        case 5:
            [self.resultDic setObject:cellName forKey:@"exp"];
            break;
        default:
            break;
    }
        
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:self.section];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self coverClick];
}


@end
