//
//  ICECommissionViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/14.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICECommissionViewController.h"
#import "ICECertifyViewController.h"
#import "XYFaceCertifyViewController.h"

@interface ICECommissionViewController ()
{
    ICECommissionType _type;
}
@property (weak, nonatomic) IBOutlet UILabel *labCommission;

@end

@implementation ICECommissionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil commissionType:(ICECommissionType)type {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    self.leftNavImageName = @"back_w";
    [self configBtnSubmit];
    switch (self.style) {
        case ICECommissionStyleCommiss:
            self.labCommission.text = @"3.审核通过后可提现佣金"; break;
        case ICECommissionStyleWage:
            self.labCommission.text = @"3.审核通过后可查询工资"; break;
        default:
            break;
    }
}

- (void)configBtnSubmit {
    self.btnSubmit.layer.cornerRadius = 35 / 2.0;
    self.btnSubmit.clipsToBounds = YES;
    [[self.btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {        
        XYFaceCertifyViewController *faceVc = [[XYFaceCertifyViewController alloc] init];
        [self.navigationController pushViewController:faceVc animated:YES];
    }];
}

- (void)didClickLeftNavAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    switch (_type) {
        case ICECommissionTypeNormal: {
            self.viewHeight.constant = 53;
            self.labFirstDesc.hidden = NO;
            self.imgViewType.hidden = YES;
        } break;
        case ICECommissionTypePassing: {
            self.viewHeight.constant = 140;
            self.imgViewType.hidden = NO;
            self.labFirstDesc.hidden = YES;
            self.btnSubmit.hidden = YES;
            self.imgViewType.image = [UIImage imageNamed:@"wdyj_shz"];
        } break;
        case ICECommissionTypeNoPass: {
            self.viewHeight.constant = 140;
            self.imgViewType.hidden = NO;
            self.labFirstDesc.hidden = YES;
            self.imgViewType.image = [UIImage imageNamed:@"wdyj_wtg"];
            [self.btnSubmit setTitle:@"重 新 认 证" forState:UIControlStateNormal];
        } break;
        default: break;
    }
}

@end
