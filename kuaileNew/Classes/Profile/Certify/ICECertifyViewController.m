//
//  ICECertifyViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICECertifyViewController.h"
#import "IQKeyboardManager.h"

@interface ICECertifyViewController ()
{
    BOOL _isSaveImg;
}
@end

@implementation ICECertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证";
    [self configNaviBar];
    [self configImgViewTap];
    [self configTextFieldIDCardNum];
    self.segmentGender.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    [[self.textFieldIDCardNum.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldIDCardNum.text = [text substringToIndex:18];
        if (![ICETools validateIDCard:text]) {
            [self showPopTipView:@"请填写标准身份证号码！" showInView:self.textFieldIDCardNum];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)loadNetData {
    [self showHudInView:self.view hint:@"照片上传中..."];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary: @{
                                                         @"photo": @"imgPhoto",
                                                         @"id_number" : self.textFieldIDCardNum.text,
                                                         @"name": self.textFieldName.text,
                                                         @"gender": @(self.segmentGender.selectedSegmentIndex)
                                                        }];
    NSArray *fileArr = @[
                         @{
                             @"file":self.imgView.image,
                             @"name" : @"imgPhoto.png",
                             @"key" : @"photo"
                             }
                         ];
    RACSignal *sign = [ICEImporter approveWithParams:params files:fileArr];
    [sign subscribeCompleted:^{
        [self showInfo:@"上传成功!"];
        [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5f];
    }];
}

- (void)configNaviBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 22);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_isSaveImg) {
            DLog(@"确定按钮被点击");
            if (self.segmentGender.selectedSegmentIndex == UISegmentedControlNoSegment) {
                [self showPopTipView:@"请选择您的性别！" showInView:self.segmentGender];
                return ;
            }
            if (self.textFieldName.text.length == 0) {
                [self showPopTipView:@"请填您的姓名！" showInView:self.textFieldName];
                return ;
            }
            if (self.textFieldIDCardNum.text.length == 0) {
                [self showPopTipView:@"请填写身份证号码！" showInView:self.textFieldIDCardNum];
                return ;
            }
            if (self.textFieldIDCardNum.text.length < 18) {
                [self showPopTipView:@"请填写18位身份证号码！" showInView:self.textFieldIDCardNum];
                return ;
            }
            [self loadNetData];
        } else {
            [self showPopTipView:@"请上传本人手持身份证照片！" showInView:self.imgView];
        }
    }];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 22)];
    [btnView addSubview:rightBtn];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)configTextFieldIDCardNum {
    [[self.textFieldIDCardNum.rac_textSignal filter:^BOOL(NSString*text){
        return text.length >= 18;
    }] subscribeNext:^(NSString*text){
        self.textFieldIDCardNum.text = [text substringToIndex:18];
    }];
}

- (void)configImgViewTap {
    [[self.imgViewTap rac_gestureSignal] subscribeNext:^(id x) {
        [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
            _isSaveImg = YES;
            self.imgView.image = editedImage;
        }];
    }];
}

- (void)popViewCtrl {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
