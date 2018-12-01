//
//  XYConfigViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYConfigViewController.h"
#import "XYTableViewCell.h"
#import "XYConfigModel.h"
#import "XYWelfareModel.h"

@interface XYConfigViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *promptionLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selModels;
@property (nonatomic, strong) NSString *laidStrs;
@property (nonatomic, strong) NSString *titleStrs;

@end

@implementation XYConfigViewController

- (NSMutableArray *)selModels {
    if (_selModels == nil) {
        _selModels = [NSMutableArray array];
    }
    return _selModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    if (_type != XYConfigViewControllerTypeTableView) {
        self.rightNavTitle = @"确定";
    } else if (_type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        self.rightNavTitle = @"保存";
    }
    [self configSubViews];
    NSArray *sel = self.selectedModels;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.didClickTableView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selRow inSection:0];
        UITableViewCell *selCell = [_tableView cellForRowAtIndexPath:indexPath];
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)configSubViews {
    if (self.type == XYConfigViewControllerTypeTextField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.frame = CGRectMake(0, 12, mScreenWidth, 40);
        _textField.delegate = self;
        _textField.text = self.placeText;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        UIView *left = [[UIView alloc] init];
        left.size = CGSizeMake(10, 40);
        _textField.leftView = left;
        UIView *right = [[UIView alloc] init];
        right.size = CGSizeMake(30, 40);
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.frame = CGRectMake(0, 10, 20, 20);
        [right addSubview:_cancelBtn];
        if (self.placeText.length < 1) {
            _cancelBtn.hidden = YES;
        }
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _textField.rightView = right;
        [_textField becomeFirstResponder];
        [_textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_textField];
    }
    
    if (self.type == XYConfigViewControllerTypeTextView) {
        _textView = [[UITextView alloc] init];
        _textView.text = self.placeText;
        _textView.frame = CGRectMake(0, 12, mScreenWidth, 100);
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        [_textView becomeFirstResponder];
        [self.view addSubview:_textView];
        
        CGFloat proLabelY = CGRectGetMaxY(_textView.frame) + 7;
        _promptionLabel = [[UILabel alloc] init];
        _promptionLabel.frame = CGRectMake(mScreenWidth - 10 - 150, proLabelY, 150, 21);
        _promptionLabel.textAlignment = NSTextAlignmentRight;
        _promptionLabel.textColor = TZColorRGB(140);
        _promptionLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_promptionLabel];
    }
    
    if (self.type == XYConfigViewControllerTypeTableView || self.type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64);
        _tableView.backgroundColor = TZControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerCellByClassName:@"XYTableViewCell"];
        [self.view addSubview:_tableView];
    }
}


#pragma mark -- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        return 0.000001;
    } else {
        return 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYTableViewCell"];
    if (self.type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        XYWelfareModel *model = self.models[indexPath.row];
        cell.textLabel.text = model.title;
        for (XYWelfareModel *selModel in self.selectedModels) {
            if ([model.title isEqualToString:selModel.title]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                model.clickCount = 1;
                break;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                model.clickCount = 0;
            }
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        if (mScreenWidth < 375) {
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.textLabel.textColor = [UIColor darkGrayColor];
    } else {
        cell.textLabel.text = self.models[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == XYConfigViewControllerTypeTableView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didSelecteTableViewRowBlock) {
                self.didSelecteTableViewRowBlock(self.models[indexPath.row], indexPath.row, YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else if (self.type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        XYTableViewCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
        XYWelfareModel *model = self.models[indexPath.row];
        NSInteger count = model.clickCount;
        count++;
        if (count == 2) {
            count = 0;
            selCell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            selCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        model.clickCount = count;
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



#pragma mark -- private

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger textLength = textView.text.length;
    if (textLength < 40) {
        _promptionLabel.hidden = YES;
    } else {
        NSInteger leftTextLength = 50 - textLength;
        NSString *lengthStr = [NSString stringWithFormat:@"还可以输入%zd个字",leftTextLength];
        if (leftTextLength < 1) {
            NSString *str = textView.text;
            str = [str substringToIndex:49];
            textView.text = str;
        }
        _promptionLabel.hidden = NO;
        _promptionLabel.text = lengthStr;
    }
    
}

- (void)textFieldTextChange:(UITextField *)textField {
    if (textField.text.length < 1) {
        _cancelBtn.hidden = YES;
    } else {
        _cancelBtn.hidden = NO;
    }
}

- (void)cancelBtnClick {
    self.textField.text = nil;
}

- (void)didClickRightNavAction {
    if (self.type == XYConfigViewControllerTypeTextField) {
        if (self.didClickConformBtnBlock) {
            self.didClickConformBtnBlock(self.textField.text);
        }
    }
    if (self.type == XYConfigViewControllerTypeTextView) {
        NSInteger length = self.textView.text.length;
        if (length > 50) {
            [self showErrorHUDWithError:@"输入的文字不可超过50个"]; return;
        }
        if (self.didClickConformBtnBlock) {
            self.didClickConformBtnBlock(self.textView.text);
        }
    }
    if (self.type == XYConfigViewControllerTypeTableViewWithSaveRightItem) {
        [self getWelfareLaids];
        if (self.didClickSaveBtnBlick) {
            NSArray *models = self.selModels;
            self.didClickSaveBtnBlick(self.titleStrs,self.laidStrs,self.selModels);
        }
        [TZUserManager saveWelfareDataWithModels:self.models];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWelfareLaids {
    NSMutableString *appStr = [NSMutableString string];
    NSMutableString *appId = [NSMutableString string];
    for (XYWelfareModel *model in self.models) {
        if (model.clickCount == 1) {
            [appStr appendString:[NSString stringWithFormat:@"、%@",model.title]];
            [appId appendString:[NSString stringWithFormat:@"#%@",model.laid]];
            [self.selModels addObject:model];
        }
    }
    if (appStr.length <= 1 && appId.length <= 1) return;
    [appStr deleteCharactersInRange:NSMakeRange(0, 1)];
    [appId deleteCharactersInRange:NSMakeRange(0, 1)];
    self.laidStrs = appId;
    self.titleStrs = appStr;
    
}


@end
