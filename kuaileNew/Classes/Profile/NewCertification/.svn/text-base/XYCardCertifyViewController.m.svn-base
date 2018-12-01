//
//  XYCardCertifyViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/27.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYCardCertifyViewController.h"
#import "XYShowPhotoView.h"
#import "TZButtonsHeaderView.h"
#import "XYCertifyView.h"
#import "XYInquireWageViewController.h"
#import "XYProgressView.h"
#import "ICECommissionViewController.h"
#import "ProgressHUD.h"

@interface XYCardCertifyViewController ()<UIImagePickerControllerDelegate> {
    BOOL _netFlag;
}
@property (nonatomic, strong) XYCertifyView *certifyView;
@property (nonatomic, strong) XYShowPhotoView *photoView;
@property (nonatomic, strong) UIImage *faceIcon;
@property (nonatomic, copy) NSString *facePath;
@property (nonatomic, strong) UIImage *backIcon;
@property (nonatomic, copy) NSString *backPath;
@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) XYProgressView *progressView;
@end

@implementation XYCardCertifyViewController

- (XYProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[XYProgressView alloc] init];
        _progressView.backgroundColor = [UIColor whiteColor];
        _progressView.frame = CGRectMake((mScreenWidth - 100) / 2.0, (mScreenHeight - 100) / 2.0 - 40, 100, 100);
        [self.view addSubview:_progressView];
    }
    return _progressView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self configCertifyView];
    [self configPhotoView];
    [self configSubmitBtn];
}

- (void)configCertifyView {
    CGFloat certifyViewH = 50;
    if (mScreenWidth < 375) certifyViewH = 44;
    _certifyView = [[XYCertifyView alloc] init];
    _certifyView.frame = CGRectMake(0, 0, mScreenWidth, certifyViewH);
    _certifyView.firstImgView.image = [UIImage imageNamed:@"lanse-1"];
    [_certifyView.cardBtn setTitleColor:TZColor(6, 191, 252) forState:0];
    [_certifyView addBottomSeperatorViewWithHeight:1];
    [self.view addSubview:_certifyView];
}


- (void)configPhotoView {
    CGFloat photoViewY = CGRectGetMaxY(_certifyView.frame);
    _photoView = [[XYShowPhotoView alloc] init];
    _photoView.frame = CGRectMake(0, photoViewY, mScreenWidth, (mScreenWidth - 15)/(2*1.46) + 5 + 90);
    
    MJWeakSelf
    [_photoView setDidClickPhotoBtn:^(NSInteger tag) {
        weakSelf.index = tag;
        [weakSelf presentToImagePickerVc];
        if (tag == 1) {
            
        } else {
            
        }
    }];
    [self.view addSubview:_photoView];
}

- (void)presentToImagePickerVc {
//    UIImagePickerController *imgPickerVc = [[UIImagePickerController alloc] init];
//    imgPickerVc.delegate = self;
//    imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentViewController:imgPickerVc animated:YES completion:nil];
    
    CGFloat photoViewH = 90;
    UIImageView *imgView = [[UIImageView alloc] init];
    if (mScreenWidth > 320) photoViewH = 121.5;
    if (mScreenWidth > 375) photoViewH = 140;
    imgView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - photoViewH);
    imgView.image = [UIImage imageNamed:@"Group 11"];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imgPickerVc = [[UIImagePickerController alloc] init];
        [imgPickerVc.view addSubview:imgView];
        imgPickerVc.delegate = self;
        imgPickerVc.allowsEditing = YES;
        imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPickerVc.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:imgPickerVc animated:YES completion:nil];
    } else {
        [self showAlertViewWithTitle:@"该设备不支持拍照"];
    }
}

- (void)configSubmitBtn {
    TZButtonsBottomView *submitBtn = [[TZButtonsBottomView alloc] init];
    submitBtn = [[TZButtonsBottomView alloc] init];
    submitBtn.frame = CGRectMake(25, mScreenHeight - 50 - 64 - 70, mScreenWidth - 50, 50);
    submitBtn.backgroundColor = [UIColor clearColor];
    submitBtn.titles = @[@"提交"];
    submitBtn.bgColors = @[TZColor(0, 198, 255)];
    MJWeakSelf
    [submitBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        
        [self uploadCardData];
    }];
    [self.view addSubview:submitBtn];
}



- (void)groupSync {
    
    if (_netFlag) {
        return;
    }
    
    
    _netFlag = YES;
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
//    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
//        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
//        params1[@"type"] = @2;
//        params1[@"avatar"] = @"headImage";
//        [TZHttpTool uploadImageWithUrl:ApiFaceIcon params:params1 image:self.faceIcon completion:^(NSDictionary *result, NSError *error) {
//            self.facePath = (NSString *)result;
//        }];
//    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
        params2[@"type"] = @3;
        params2[@"avatar"] = @"headImage";
//        [TZHttpTool uploadImageWithUrl:ApiFaceIcon params:params2 image:self.backIcon completion:^(NSDictionary *result, NSError *error) {
//            self.backPath = (NSString *)result;
            
//            NSMutableDictionary *params3 = [NSMutableDictionary dictionary];
//            params3[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
//            params3[@"face_base"] = self.facePath;
//            params3[@"back_base"] = self.backPath;
//            [TZHttpTool postWithURL:ApiApprove params:params3 success:^(NSDictionary *result) {
//                XYInquireWageViewController *inquireVc = [[XYInquireWageViewController alloc] init];
//                [self.navigationController pushViewController:inquireVc animated:YES];
//            } failure:^(NSString *msg) {
//                [self showErrorHUDWithError:msg];
//            }];
//        }];
        
        NSDictionary *dict = @{ @"file" : self.backIcon,
                                @"name" : [NSString stringWithFormat:@"imgOperation%ld.png",1],
                                @"key"  : @"img" };
        NSArray *fileArr = [NSArray arrayWithObject:dict];
     
        
         [TZHttpTool postWithUploadImages:ApiFaceIcon params:params2 formDataArray:fileArr process:^(NSInteger writedBytes, NSInteger totalBytes) {
            
            CGFloat percent = writedBytes / (CGFloat)totalBytes;
//            NSMutableString *str = [NSMutableString stringWithFormat:@"%.f",percent];
//            [str appendString:@"%"];
            self.progressView.hidden = NO;
            self.progressView.progress = percent;
            if (writedBytes == totalBytes) {
                self.progressView.hidden = YES;
                [ProgressHUD showLoading];

            }
        } success:^(NSDictionary *result) {
            
            
            NSDictionary *dict1 = @{ @"file" : self.faceIcon,
                                    @"name" : [NSString stringWithFormat:@"imgOperation%ld.png",2],
                                    @"key"  : @"img" };
            NSArray *fileArr1 = [NSArray arrayWithObject:dict1];

            
            
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            params1[@"type"] = @2;
            params1[@"avatar"] = @"headImage";
            
            
           
            
          [TZHttpTool postWithUploadImages:ApiFaceIcon params:params1 formDataArray:fileArr1 process:nil success:^(NSDictionary *result) {
                
                  self.facePath = result[@"data"];
                NSMutableDictionary *params3 = [NSMutableDictionary dictionary];
                params3[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
                params3[@"face_base"] = self.facePath;
                params3[@"back_base"] = self.backPath;
              
                [TZHttpTool postWithURL:ApiApprove params:params3 success:^(NSDictionary *result) {
                    
                    [ProgressHUD dismiss];
                    
                    //                [self showHint:result[@"msg"]];
                    
                    ICECommissionViewController *iCECommission = [[ICECommissionViewController alloc] initWithNibName:@"ICECommissionViewController" bundle:nil commissionType:ICECommissionTypePassing];
                    iCECommission.style = ICECommissionStyleWage;
                    _netFlag = NO;
                    
                    [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:iCECommission animated:YES];
                        
                    });
                    
                    //                XYInquireWageViewController *inquireVc = [[XYInquireWageViewController alloc] init];
                    //                [self.navigationController pushViewController:inquireVc animated:YES];
                } failure:^(NSString *msg) {
                    [ProgressHUD dismiss];
                    _netFlag = NO;
                    [self showErrorHUDWithError:msg];
                    
                }];

                
           } failure:^(NSString *msg) {
             

           }];

      
            
            
//            [TZHttpTool uploadImageWithUrl:ApiFaceIcon params:params1 image:self.faceIcon completion:^(NSDictionary *result, NSError *error) {
//                self.facePath = (NSString *)result;
//                
//                
//            }];

            
            
            
             self.backPath = result[@"data"];
        } failure:^(NSString *msg) {
           
        }];
    });

}

- (void)uploadCardData {
    if (!self.faceIcon && !self.backIcon) {
        [self showErrorHUDWithError:@"请上传身份证照片"];
        return;
    }
    [self groupSync];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info[UIImagePickerControllerMediaType]);
    if (self.index == 1) { // 左边
        self.faceIcon = info[UIImagePickerControllerOriginalImage];
        UIImage *face = self.faceIcon;
        [_photoView.faceBtn setBackgroundImage:self.faceIcon forState:0];
    } else {  // 右边
        self.backIcon = info[UIImagePickerControllerOriginalImage];
        UIImage *back = self.backIcon;
        [_photoView.guohuiBtn setBackgroundImage:self.backIcon forState:0];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
