//
//  XYFaceCertifyViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/24.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYFaceCertifyViewController.h"
#import "XYCertifyView.h"
#import "TZButtonsHeaderView.h"
#import "XYCardCertifyViewController.h"
#import "XYIncomeListViewController.h"
#import "XYTestView.h"
#import "XYProgressView.h"

@interface XYFaceCertifyViewController ()<UIImagePickerControllerDelegate> {
    BOOL _netFlag;
}
@property (nonatomic, strong) XYCertifyView *certifyView;
@property (nonatomic, strong) TZButtonsBottomView *certifyBtn;
@property (nonatomic, strong) UIImage *faceIcon;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) BOOL uploadIcon;
@property (strong, nonatomic) XYProgressView *progressView;
@property (copy, nonatomic) NSString *facePath;
@end

@implementation XYFaceCertifyViewController

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
    self.uploadIcon = NO;
    [self configCertifyView];
    [self configImgView];
    [self configCertifyBtn];
    
}

- (void)configCertifyView {
    CGFloat certifyViewH = 50;
    if (mScreenWidth < 375) certifyViewH = 44;
    _certifyView = [[XYCertifyView alloc] init];
    _certifyView.frame = CGRectMake(0, 0, mScreenWidth, certifyViewH);
//    [_certifyView setDidClickBtnBlock:^{
//        XYCardCertifyViewController *cardVc = [[XYCardCertifyViewController alloc] init];
//        [self.navigationController pushViewController:cardVc animated:YES];
//    }];
    [self.view addSubview:_certifyView];

}

- (void)configImgView {
    CGFloat imgViewW = 190;
    CGFloat imgViewY = 130;
    if (mScreenWidth < 375) {
        imgViewW = 127;
        imgViewY = 90;
    }
    _iconView = [[UIImageView alloc] init];
    _iconView.frame = CGRectMake(0, 100, mScreenWidth, 270);
    _iconView.image = [UIImage imageNamed:@"avatarVertify"];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
    [self.view addSubview:_iconView];
//    
//    CGFloat lineY = CGRectGetMaxY(_iconView.frame);
//    UIView *line = [[UIView alloc] init];
//    line.frame = CGRectMake((mScreenWidth - 230)/2.0, lineY, 230, 2);
//    line.backgroundColor = TZColorRGB(220);
//    [self.view addSubview:line];
    
//    CGFloat labelY = CGRectGetMaxY(_iconView.frame) + 20;
//    UILabel *remindLabel = [[UILabel alloc] init];
//    remindLabel.frame = CGRectMake((mScreenWidth - 200)/2.0, labelY, 200, 21);
//    remindLabel.text = @"请尽量将脸部置于框内";
//    remindLabel.textColor = TZColorRGB(190);
//    remindLabel.textAlignment = NSTextAlignmentCenter;
//    remindLabel.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:remindLabel];
}

- (void)configCertifyBtn {
    _certifyBtn = [[TZButtonsBottomView alloc] init];
    _certifyBtn.frame = CGRectMake(25, mScreenHeight - 50 - 64 - 70, mScreenWidth - 50, 50);
    _certifyBtn.backgroundColor = [UIColor clearColor];
    _certifyBtn.titles = @[@"立即验证"];
    _certifyBtn.bgColors = @[TZColor(0, 198, 255)];
    MJWeakSelf
    [_certifyBtn setDidClickButtonWithIndex:^(TZBaseButton *btn, NSInteger index) {
        if (!weakSelf) {
//            CGFloat photoViewH = 101.5;
//            UIImageView *imgView = [[UIImageView alloc] init];
//            if (mScreenWidth > 320) photoViewH = 121.5;
//            if (mScreenWidth > 375) photoViewH = 140;
//            imgView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - photoViewH);
//            imgView.image = [UIImage imageNamed:@"Group 10"];
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imgPickerVc = [[UIImagePickerController alloc] init];
//                [imgPickerVc.view addSubview:imgView];
                imgPickerVc.delegate = weakSelf;
                imgPickerVc.allowsEditing = YES;
                imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgPickerVc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                [weakSelf presentViewController:imgPickerVc animated:YES completion:nil];
            } else {
                [weakSelf showAlertViewWithTitle:@"该设备不支持拍照"];
            }
            
        } else {
            [weakSelf vertifyFaceIconData];
        }
    }];
    [self.view addSubview:_certifyBtn];
}


- (void)vertifyFaceIconData {
    if (!self.faceIcon) return;
    if (_netFlag) return;

    _netFlag = YES;
    NSArray *fileArr = @[@{
                             @"file": self.faceIcon,
                             @"name" : @"headImage.png",
                             @"key" : @"img"
                        }];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @1;
    params[@"avatar"] = @"headImage";
    [TZHttpTool postWithUploadImages:ApiFaceIcon params:params formDataArray:fileArr process:^(NSInteger writedBytes, NSInteger totalBytes) {
        CGFloat percent = writedBytes / (CGFloat)totalBytes;
        self.progressView.hidden = NO;
        self.progressView.progress = percent;
        if (writedBytes == totalBytes) {
            self.progressView.hidden = YES;
        }
    } success:^(NSDictionary *result) {
        _netFlag = NO;
        XYCardCertifyViewController *cardVc = [[XYCardCertifyViewController alloc] init];
        [self.navigationController pushViewController:cardVc animated:YES];
        
        //compleone
         self.facePath = result[@"data"];
    } failure:^(NSString *msg) {
        
    }];
    
    
//    [TZHttpTool uploadOperationToUrl:ApiFaceIcon params:params files:fileArr process:^(NSInteger writedBytes, NSInteger totalBytes) {
//        CGFloat percent = writedBytes / (CGFloat)totalBytes;
//        self.progressView.hidden = NO;
//        self.progressView.progress = percent;
//        if (writedBytes == totalBytes) {
//            self.progressView.hidden = YES;
//        }
//    } complete:^(BOOL successed, NSDictionary *result) {
//        _netFlag = NO;
//        XYCardCertifyViewController *cardVc = [[XYCardCertifyViewController alloc] init];
//        [self.navigationController pushViewController:cardVc animated:YES];
//    } completeOne:^(BOOL successed, NSDictionary *result) {
//        self.facePath = result[@"data"];
//    }];
    
}

#pragma mark -- UIImagePickerControllerDelegate;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info[UIImagePickerControllerMediaType]);
    self.faceIcon = info[UIImagePickerControllerOriginalImage];
    _iconView.image = self.faceIcon;
    self.uploadIcon = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
//    if (picker == picker_camera_)
//    {
//        //如果是 来自照相机的image，那么先保存
//        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        UIImageWriteToSavedPhotosAlbum(original_image, self,
//                                       @selector(image:didFinishSavingWithError:contextInfo:),
//                                       nil);
//    }
//    
//    //获得编辑过的图片
//    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
//    
//    
//    [self dismissModalViewControllerAnimated:YES];
//    [picker release];
}




@end
