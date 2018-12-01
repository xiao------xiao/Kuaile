//
//  XYPhotoViewController.m
//  kuaile
//
//  Created by 肖兰月 on 2017/2/9.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYPhotoViewController.h"

@interface XYPhotoViewController ()

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XYPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"头像";
    
    if (!self.isOther) {
        self.rightNavImageName = @"diandian";
    }
    
    self.view.backgroundColor = TZColorRGB(20);
    [self configImageView];
}

- (void)configImageView {
    _imgView = [[UIImageView alloc] init];
    CGFloat imgViewHW = mScreenWidth - 4;
    _imgView.frame = CGRectMake(2, (mScreenHeight - imgViewHW)/2.0 - 64, imgViewHW, imgViewHW);
    _imgView.image = self.currentIcon;
    [self.view addSubview:_imgView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didClickRightNavAction {
    [TZImagePickerTool selectImageForEditFrom:self complete:^(UIImage *origionImg, UIImage *editedImage) {
        self.icon = editedImage;
        _imgView.image = editedImage;
        [self updataHeadImg:editedImage isIcon:YES];
//        if (self.didSelecteAvatarBlock) {
//            self.didSelecteAvatarBlock(editedImage);
//        }
    }];
}


- (void)updataHeadImg:(UIImage *)image isIcon:(BOOL)isIcon {
    if (!image) return;
    NSArray *fileArr = @[
                         @{
                             @"file": image,
                             @"name" : @"headImage.png",
                             @"key" : @"avatar"
                             }
                         ];
    [self showTextHUDWithPleaseWait];
    RACSignal *signal = [ICEImporter uploadFilesWithUrl:ApiUploadPersonImg params:@{ @"avatar": @"headImage" } files:fileArr];
    [signal subscribeNext:^(NSDictionary *result) {
        [self hideTextHud];
        NSLog(@"%@",result);
        ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
        //        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"][@"avatar"]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
        NSString *str = [ApiSystemImage stringByAppendingString:result[@"data"]];
        userModel.avatar = str;
        if (isIcon) {
            userModel.avatar = str;
            params[@"avatar"] = str;
        } else {
            userModel.background = str;
            params[@"background"] = str;
        }
        [TZHttpTool postWithURL:ApiEditUser params:params success:^(NSDictionary *result) {
            [self showSuccessHUDWithStr:@"上传成功"];
            [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
        } failure:^(NSString *msg) {
            [self showErrorHUDWithError:msg];
        }];
    }];
}

@end
