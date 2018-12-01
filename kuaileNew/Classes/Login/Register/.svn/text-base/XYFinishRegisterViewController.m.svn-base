//
//  XYFinishRegisterViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/3/7.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYFinishRegisterViewController.h"
#import "XYDetailListCell.h"
#import "XYFoundationCell.h"
#import "TZButtonsHeaderView.h"
#import "TZTableViewController.h"
#import "ICESelfInfoModel.h"
#import "TZResumeModel.h"
#import "TZBaseViewController.h"

typedef NS_ENUM(NSUInteger, SexType) {
    SexTypeMen,
    SexTypeWoman,
    
};
@interface XYFinishRegisterViewController()<UITextFieldDelegate,TZDatePickerViewDelegate>
@end
@interface XYFinishRegisterViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSString *_avatar;
}
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSMutableArray *cellSubTitles;
@property (nonatomic, strong) NSArray *cellTitles;

@property (nonatomic, strong) ICESelfInfoModel *modelSelfInfo;
@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) TZResumeModel *model;
@property (nonatomic, strong) UIImage *icon;
@property (copy, nonatomic) NSString *allWord;

//********************************************
@property (retain, nonatomic) UIImageView *headImage;
@property (assign, nonatomic) SexType sextype;
@property (retain, nonatomic) UIButton *btnwomen;
@property (retain, nonatomic) UIButton *btnmen;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *nickname;
@property (retain, nonatomic) UITextField *nicknameTxt;
@property (retain, nonatomic) UITextField *birthTxt;

//@property (nonatomic, strong) UIButton *maskView;

@end

@implementation XYFinishRegisterViewController
-(void)setSextype:(SexType)sextype{
    _sextype = sextype;
    if(sextype==SexTypeMen){
        self.btnmen.selected = YES;
        self.btnwomen.selected = NO;
    }else{
        self.btnmen.selected = NO;
        self.btnwomen.selected = YES;
    }
}

-(void)setupView{
    UIImageView *portrait = [[UIImageView alloc] init];
    portrait.image = [UIImage imageNamed:@"icon_head"];
    [self.view addSubview:portrait];
    self.headImage = portrait;
    
    UIImageView *camera = [[UIImageView alloc] init];
    camera.image = [UIImage imageNamed:@"icon_change"];
    [portrait addSubview:camera];
    
    UIButton *spareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spareButton.backgroundColor = [UIColor clearColor];
    [spareButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:spareButton];
    
    UILabel *lblone = [[UILabel alloc] init];
    [lblone setTitle:@"让我们了解你" color:color_darkgray];
    lblone.font = xfont(16);
    lblone.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:lblone];
    
    UILabel *lbltwo = [[UILabel alloc] init];
    lbltwo.font = fontBig;
    lbltwo.textAlignment = NSTextAlignmentCenter;
    [lbltwo setTitle:@"选性别" color:color_lightgray];
    [self.view addSubview:lbltwo];
    
   
    UIButton *btnmen = [[UIButton alloc] init];
    [btnmen setImage:[UIImage imageNamed:@"icon_male"] forState:UIControlStateNormal];
    [btnmen setImage:[UIImage imageNamed:@"icon_male_sel"] forState:UIControlStateSelected];
    [self.view addSubview:btnmen];
    self.btnmen = btnmen;
    UILabel *lblmen = [[UILabel alloc] init];
     lblmen.font = fontBig;
    [lblmen setTitle:@"男" color:color_darkgray];
    lblmen.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:lblmen];
    
    UIButton *btnwomen = [[UIButton alloc] init];
    [btnwomen setImage:[UIImage imageNamed:@"icon_female"] forState:UIControlStateNormal];
    [btnwomen setImage:[UIImage imageNamed:@"icon_female_sel"] forState:UIControlStateSelected];
    [self.view addSubview:btnwomen];
    self.btnwomen = btnwomen;
    UILabel *lblwoman = [[UILabel alloc] init];
     lblwoman.font = fontBig;
    [lblwoman setTitle:@"女" color:color_darkgray];
    lblwoman.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:lblwoman];
    [[self.btnmen rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.sextype = SexTypeMen;
    }];
    self.sextype = SexTypeMen;
    [[self.btnwomen rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.sextype = SexTypeWoman;
    }];
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.view.mas_top).offset(18);
    }];
    [camera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(portrait.mas_trailing).offset(-5);
        make.bottom.mas_equalTo(portrait.mas_bottom);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        
    }];
    
    [spareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(portrait.mas_leading);
        make.bottom.mas_equalTo(portrait.mas_bottom);
        make.trailing.mas_equalTo(portrait.mas_trailing);
        make.top.mas_equalTo(portrait.mas_top);
    }];
    [lblone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(portrait.mas_bottom).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(18);
        
    }];
    [lbltwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(lblone.mas_bottom).offset(32);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(15);
    }];
    
    [btnmen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view.mas_centerX).offset(-35);
        make.top.mas_equalTo(lbltwo.mas_bottom).offset(16);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        
    }];
    [lblmen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btnmen.mas_centerX);
        make.top.mas_equalTo(btnmen.mas_bottom).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    
    [btnwomen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_centerX).offset(35);
        make.top.mas_equalTo(btnmen.mas_top);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        
    }];
    [lblwoman mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btnwomen.mas_centerX);
        make.top.mas_equalTo(btnwomen.mas_bottom).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    
    
    UIView *cellOne = [[UIView alloc] init];
    [self.view addSubview:cellOne];
    [cellOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lblwoman.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.view.mas_leading).offset(35);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-35);
        make.height.mas_equalTo(58);
    }];
    UIView *cellTwo = [[UIView alloc] init];
    [self.view addSubview:cellTwo];
    [cellTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellOne.mas_bottom);
        make.leading.mas_equalTo(cellOne.mas_leading);
        make.trailing.mas_equalTo(cellOne.mas_trailing);
        make.height.mas_equalTo(58);
    }];
     [cellOne addSubview:[UIView divideViewWithViewHeight:58 xMargin:0]];
    [cellTwo addSubview:[UIView divideViewWithViewHeight:58 xMargin:0]];
    
    UILabel *lblnick = [[UILabel alloc] init];
    lblnick.text =@"用户昵称";
    lblnick.textColor = color_lightgray;
    lblnick.font = fontBig;
    [cellOne addSubview:lblnick];
    [lblnick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cellOne.mas_leading);
        make.centerY.mas_equalTo(cellOne.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    UILabel *lblbirth = [[UILabel alloc] init];
    lblbirth.text =@"出生年月";
    lblbirth.textColor = color_lightgray;
    lblbirth.font = fontBig;
    [cellTwo addSubview:lblbirth];
    [lblbirth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(cellTwo.mas_leading);
        make.centerY.mas_equalTo(cellTwo.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    UIButton *btnRefreshNickName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefreshNickName setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [[btnRefreshNickName rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self getRandomUserName];
    }];
    [cellOne addSubview:btnRefreshNickName];
    [btnRefreshNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(cellOne.mas_trailing);
        make.centerY.mas_equalTo(cellOne.mas_centerY);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    
    UITextField *nickNameTxt = [[UITextField alloc] init];
    nickNameTxt.font = fontBig;
    nickNameTxt.textAlignment = NSTextAlignmentRight;
    nickNameTxt.delegate = self;
    nickNameTxt.tag = 101;
    nickNameTxt.borderStyle = UITextBorderStyleNone;
    nickNameTxt.placeholder = @"";
    nickNameTxt.text = @"王明";
    
    [cellOne addSubview:nickNameTxt];
    
    [nickNameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lblnick.mas_trailing);
        make.centerY.mas_equalTo(cellOne.mas_centerY);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(btnRefreshNickName.mas_leading);
    }];
    
    
//    UIImageView *arrowImage = [[UIImageView alloc] init];
//    arrowImage.image = [UIImage imageNamed:@"down_arrow"];
//    [cellTwo addSubview:arrowImage];
    UIButton *arrowImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowImage setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
//    [[arrowImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [self getRandomUserName];
//    }];
     [cellTwo addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(cellTwo.mas_trailing);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(cellTwo.mas_centerY);
    }];
    
    
    UITextField *birthTxt = [[UITextField alloc] init];
    birthTxt.font = fontBig;
    birthTxt.borderStyle = UITextBorderStyleNone;
    birthTxt.textAlignment = NSTextAlignmentRight;
    birthTxt.delegate = self;
    birthTxt.tag = 102;
    birthTxt.placeholder = @"";
    birthTxt.text = @"请选择";
    [cellTwo addSubview:birthTxt];
    
    [birthTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lblbirth.mas_trailing);
        make.centerY.mas_equalTo(cellTwo.mas_centerY);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(arrowImage.mas_leading);
    }];
    
    self.nicknameTxt = nickNameTxt;
    self.birthTxt = birthTxt;
    
    
    _createBtn = [PublicView createLoginNormalButtonWithTitle:@"完成"];
   
    MJWeakSelf
    [[_createBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf submitRequest];
        
    }];
   
    [self.view addSubview:_createBtn];
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellTwo.mas_bottom).offset(34);
        make.trailing.mas_equalTo(cellTwo.mas_trailing);
        make.leading.mas_equalTo(cellTwo.mas_leading);
        make.height.mas_equalTo(44);
    }];
    [self setNeedDatePicker:YES];
   
    
    
}
-(void)takePicture{
    NSLog(@"paizhaopian");
    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
        self.headImage.image =editedImage;
        
//        selCell.avater.image = editedImage;
        self.icon = editedImage;
        [self updataHeadImg:editedImage];
    }];
}
- (TZResumeModel *)model {
    if (_model == nil) {
        _model = [[TZResumeModel alloc] init];
    }
    return _model;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写注册信息";
//    self.leftNavImageName = @"back_w";
    self.navigationItem.rightBarButtonItem = nil;
//    [self loadNetWorkData];
//    [self configTableView];
//    [self configDefaultData];
//    [self configConformBtn];
   
//    [self configDefaultData];
//    [self loadUserNameData];
    [self setupView];
    [self loadUserNameData];
    [self getRandomUserName];
}


- (void)loadUserNameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"网名汉字.txt" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    self.allWord = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
}

- (void)getRandomUserName {
    NSUInteger length = self.allWord.length;
    NSString *firstword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *secondword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *thirdword = [self.allWord substringWithRange:NSMakeRange(arc4random_uniform(length - 1), 1)];
    NSString *appendStr = [NSString stringWithFormat:@"%@%@%@",firstword,secondword,thirdword];
    
    [self refreshNickName:appendStr];
//    [self refreshCellDetailNamesWith:appendStr];
}


- (void)loadNetWorkData {
//    RACSignal *sign = [[ICEImporter getPerson:nil] subscribeNext:^(id x) {
//        _modelSelfInfo = [ICESelfInfoModel objectWithKeyValues:x[@"data"]];
//        [self configDefaultData];
//    }];
}

- (void)popViewCtrl {
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    // 登录成功
    userModel.hasLogin = YES;
    [self hideHud];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //同步二维码
    [TZUserManager syncUserQR];
}

- (void)didClickLeftNavAction {
    [self popViewCtrl];
}

//- (void)configDefaultData {
//    self.cellSubTitles = [NSMutableArray arrayWithArray:@[@"请填写",@"请选择",@"请选择"]];
//    self.cellTitles = @[@"用户昵称",@"出生日期",@"性别"];
//    [self.tableView reloadData];
//}



//- (void)configTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[UIView alloc] init];
//    [self.tableView registerCellByClassName:@"XYDetailListCell"];
//    [self.tableView registerCellByClassName:@"XYFoundationCell"];
//    [super configTableView];
//}


//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) { return 70; }
//    else { return 44; }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        XYFoundationCell *avaterCell = [tableView dequeueReusableCellWithIdentifier:@"XYFoundationCell"];
//        avaterCell.type = XYFoundationCellTypeAvater;
//        avaterCell.labelText = @"修改头像";
//        if (mScreenWidth < 375) {
//            avaterCell.label.font = [UIFont boldSystemFontOfSize:14];
//        } else {
//            avaterCell.label.font = [UIFont boldSystemFontOfSize:16];
//        }
//        avaterCell.label.textColor = TZColorRGB(171);
//        [avaterCell addBottomSeperatorViewWithHeight:1];
//        return avaterCell;
//    } else {
//        XYDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYDetailListCell"];
//        cell.text = self.cellTitles[indexPath.row - 1];
//        cell.subText = self.cellSubTitles[indexPath.row - 1];
//        if (indexPath.row == 1) {
//            cell.haveAccessoryBtn = YES;
//            cell.accessoryBtnText = @"换一个";
//            cell.accessoryBtn.hidden = NO;
//            cell.accessoryBtnTextColor = TZColor(6, 191, 252);
//            [cell setDidClickAccessoryBtnBlock:^{
////                self.section = 1;
//                self.row = 1;
//                [self getRandomUserName];
//            }];
//        }else {
//            cell.accessoryBtn.hidden = YES;
//        }
//        if (mScreenWidth < 375) {
//            cell.label.font = [UIFont boldSystemFontOfSize:14];
//            cell.subLabelFont = 14;
//        } else {
//            cell.label.font = [UIFont boldSystemFontOfSize:16];
//            cell.subLabelFont = 16;
//        }
//        cell.labelTextColor = TZColorRGB(171);
//        cell.subLabelTextColor = TZColorRGB(193);
//        [cell addBottomSeperatorViewWithHeight:1];
//        return cell;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        XYFoundationCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
//        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
//            selCell.avater.image = editedImage;
//            self.icon = editedImage;
//            [self updataHeadImg:editedImage];
//        }];
//    } else if (indexPath.row == 1) {
//        UIAlertView *nameAlert = [UIAlertView alertViewWithTitle:@"请输入昵称" message:nil delegate:self];
//        self.nameField = [nameAlert textFieldAtIndex:0];
//        self.nameField.keyboardType = UIKeyboardTypeDefault;
//        if (![self.cellSubTitles[0] isEqualToString:@"请填写"]) {
//            self.nameField.text = self.cellSubTitles[0];
//        }
//        [[nameAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
//            if (x.integerValue == 1) {
//                [self refreshCellDetailNamesWith:self.nameField.text];
//            }
//        }];
//        [nameAlert show];
//    } else if (indexPath.row == 2) {
//        [self showDatePickerView];
//    } else {
//        [self showPopSelectViewWithArray:@[@"男",@"女"]];
//    }
//    self.row = indexPath.row;
//    self.section = indexPath.section;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//

-(void)refreshNickName:(NSString *)name{
    self.nicknameTxt.text = name;
    self.nickname = name;
    
}

- (void)refreshBirthday:(NSString *)dateString {
  
    self.birthTxt.text = dateString;
    self.birthday = dateString;

}

- (void)updataHeadImg:(UIImage *)image {
    NSArray *fileArr = @[@{ @"file": image, @"name" : @"headImage.png", @"key" : @"avatar" } ];
    [[ICEImporter uploadFilesWithUrl:ApiUploadImage params:nil files:fileArr] subscribeNext:^(id result) {
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"]];
        _avatar = str;
//        userModel.avatar = str;
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_avatar]] placeholderImage:TZPlaceholderAvaterImage];
    }];
}

- (void)showAlertView {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"信息未填完将不会保存，确定离开界面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.alertView show];
}

- (void)submitRequest{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!self.icon) {
        [self showErrorHUDWithError:@"请选择头像"]; return;
    } else {
        params[@"avatar"] = _avatar;
    }
    params[@"gender"] = self.sextype == SexTypeMen? @"0" : @"1";
    if (self.birthday &&self.birthday.length>0) {
        params[@"birthday"] = [CommonTools getTimeStampBytimeStr:self.birthday];
    }else{
        [self showAlertView];
    }
    if (self.nickname && self.nickname.length>0) {
        params[@"nickname"] = self.nickname;
    }else{
        [self showAlertView];
    }

    [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];

            [self popViewCtrl];
        });
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

#pragma mark Textfeild Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag ==101){ //nickname
        UIAlertView *nameAlert = [UIAlertView alertViewWithTitle:@"请输入昵称" message:nil delegate:self];
        self.nameField = [nameAlert textFieldAtIndex:0];
        self.nameField.keyboardType = UIKeyboardTypeDefault;
        if (self.nicknameTxt.text.length>0) {
            self.nameField.text = self.nicknameTxt.text;
        }
        [[nameAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            if (x.integerValue == 1) {
                self.nicknameTxt.text = self.nameField.text;
                self.nickname = self.nameField.text;
//                [self refreshCellDetailNamesWith:self.nameField.text];
            }
        }];
        [nameAlert show];
    }else{ //birthday
          [self showDataPickerView];
    }
    return NO;
}

#pragma mark TZDatePickerViewDelegate

- (void)datePickerViewDidClickCancleButton {
    [self coverBtnClick];
}

- (void)datePickerViewDidClickUntilNowButton {
    // 局部刷新
//    [self refreshCellDetailNamesWith:@"至今"];
    [self coverBtnClick];
}

- (void)datePickerViewDidClickOKButton:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [formatter stringFromDate:datePicker.date];
    // 局部刷新
//    [self refreshCellDetailNamesWith:date];
    [self coverBtnClick];
    [self refreshBirthday:date];
//    self.maskView.hidden = YES;
}
#pragma mark MaskView

//- (void)configDatePickerView {
//    TZDatePickerView *datePickerView = [[TZDatePickerView alloc] init];
//    datePickerView.frame = CGRectMake(30, __kScreenHeight + 64 + 100, __kScreenWidth - 60, 200);
//    datePickerView.hidden = YES;
//    datePickerView.delegate = self;
//    da
//    self.datePickerView = datePickerView;
//    [self.maskView addSubview:datePickerView];
//    //    [self.navigationController.view addSubview:datePickerView];
//}
//_needDatePicker = needDatePicker;
//if (needDatePicker) {
//    _datePicker = [[TZDatePickerView alloc] init];
//    NSInteger top = (mScreenHeight - 200) / 2 - 64;
//    _datePicker.frame = CGRectMake(30, top, __kScreenWidth - 60, 200);
//    _datePicker.hidden = YES;
//    _datePicker.delegate = self;
//    [self.cover class];
//    [self.view addSubview:self.datePicker];
//}


//- (UIButton *)maskView {
//
//
//    if (!_maskView) {
//        _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _maskView.frame = [UIScreen mainScreen].bounds;
//        _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
//        [_maskView addTarget:self action:@selector(maskClick) forControlEvents:UIControlEventTouchUpInside];
//        _maskView.hidden = YES;
//        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
//
//
//
//    }
//
//    if (![_maskView.superview isKindOfClass:[UIView class]]) {
//        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
//
//    }
//
//    return _maskView;
//}
//- (void)maskClick {
//    _maskView.hidden = YES;;
//}
//- (void)showDatePickerView {
//
////    self.selectView.hidden = YES;
//
//    self.maskView.hidden = NO;
//    self.datePickerView.hidden = NO;
//    [UIView animateWithDuration:0.25 animations:^{
////        self.cover.y = 0;
//        self.datePickerView.y = (__kScreenHeight - self.datePickerView.height)/2;
//    }];
//}
//- (void)sendHttp {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (!self.icon) {
//        [self showErrorHUDWithError:@"请选择头像"]; return;
//    } else {
//        params[@"avatar"] = _avatar;
//    }
//    if ([self.cellSubTitles[0] isEqualToString:@"请填写"])   { [self showAlertView]; return;}
//    else { params[@"nickname"] = self.cellSubTitles[0];}
//    if ([self.cellSubTitles[1] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
//    else { params[@"birthday"] = [CommonTools getTimeStampBytimeStr:self.cellSubTitles[1]];}
//    if ([self.cellSubTitles[2] isEqualToString:@"请选择"])   { [self showAlertView]; return;}
//    else { params[@"gender"] = [self.cellSubTitles[2] isEqualToString:@"男"] ? @"0" : @"1";}
//
//    [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
//        [self showSuccessHUDWithStr:@"保存成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
//
//            [self popViewCtrl];
//        });
//    } failure:^(NSString *msg) {
//        [self showErrorHUDWithError:msg];
//    }];
//}


@end
