//
//  ZYYCreateTopicViewController.m
//  DemoProduct
//
//  Created by liujingyi on 16/1/5.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "TZSnsCreateController.h"
#import "TZTestCell.h"
#import "TZFindSnsModel.h"
// 选择图片
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZPhotoPickerController.h"
// 来自微博
#import "HWEmotionTextView.h"
#import "HWComposeToolbar.h"
#import "HWComposePhotosView.h"
#import "HWEmotionKeyboard.h"
#import "HWEmotion.h"
#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>

#import <MapKit/MapKit.h>
#import "ProgressHUD.h"


@interface TZSnsCreateController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSString * locationCityStr;
    BOOL _isNetFlag;
    BOOL _retap;
//    BOOL  _isUpdateImagsFailed;
    
}
/** 输入控件 */
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet HWEmotionTextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic, strong) UIButton *webBtn;
@property (nonatomic, strong) UIButton *friendBtn;
@property (nonatomic, strong) UIButton *QQZoneBtn;
@property (nonatomic, assign) CGFloat itemWH;


@property(nonatomic,assign) NSInteger* tag;
// 数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, assign) BOOL isFirstEdit;
@property (nonatomic, weak) HWComposeToolbar *toolbar; ///< 键盘顶部的工具条
@property (nonatomic, strong) HWEmotionKeyboard *emotionKeyboard; ///< 表情键盘
@property (nonatomic, assign) BOOL switchingKeybaord;
// 资源路径
@property (nonatomic, copy) NSString *imgsPath;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *data;

@property (nonatomic, assign) BOOL showImgPickerVc;

@end

@implementation TZSnsCreateController

- (HWEmotionKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[HWEmotionKeyboard alloc] init];
        // 键盘的宽度
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[TZSnsCreateController alloc] initWithNibName:@"TZSnsCreateController" bundle:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![TZUserManager isLogin]) {
        return;
    }
    
    _isNetFlag = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    if ([self.titleText isEqualToString:@"自拍美拍"]) {
//        self.isFirstEdit = NO;
//
//        [self takePhoto];
//        
//    }else {
//        if (!self.iShow) {
//            if (self.showImgPickerVc) {
//                [self presentImagePickerVc];
//            }
//        }
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.showImgPickerVc = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uid = [ICELoginUserModel sharedInstance].uid;
    _dataArray = [[NSMutableArray alloc] init];
    _assetArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = self.titleText;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(reportBtnClick)];
    [super viewDidLoad];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        options.shouldMoveFile = YES;
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:nil options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{

                NSLog(@"保存照片出错:%@",error.localizedDescription);
//            }
        });
    }];
    self.isFirstEdit = YES;
    
    [self configLocation];
    self.showImgPickerVc = YES;
    [self configCollectionView];
    [self configShareView];
    [self imagePickerVc];
    // 添加输入控件
    [self setupTextView];
    // 添加工具条
    [self setupToolbar];
}

/// 添加输入控件
- (void)setupTextView {
    // 垂直方向上永远可以拖拽（有弹簧效果）
    _textView.alwaysBounceVertical = YES;
    _textView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _textView.placeholder = @"说点什么吧...";
    
    // 文字改变的通知
    [mNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 表情选中的通知
    [mNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HWEmotionDidSelectNotification object:nil];
    // 删除文字的通知
    [mNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HWEmotionDidDeleteNotification object:nil];
    // 发送文字的通知
    [mNotificationCenter addObserver:self selector:@selector(emotionDidSend) name:HWEmotionDidSendNotification object:nil];
}

/// 表情被选中了
- (void)emotionDidSelect:(NSNotification *)notification {
    HWEmotion *emotion = notification.userInfo[HWSelectEmotionKey];
    [self.textView insertEmotion:emotion];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TZUserManager isLogin];
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    
    if ([self.titleText isEqualToString:@"自拍美拍"]) {
        self.isFirstEdit = NO;
        
//        [self takePhoto];
        
    }else {
        if (!self.iShow) {
            if (self.showImgPickerVc) {
                [self presentImagePickerVc];
            }
        }
    }
    
    if (self.isFirstEdit) {
        [self.textView becomeFirstResponder];
        self.isFirstEdit = NO;
    }
    
    [locationManager startUpdatingLocation];
}

/// 添加工具条
- (void)setupToolbar {
    HWComposeToolbar *toolbar = [[HWComposeToolbar alloc] init];
    toolbar.type = HWComposeToolbarTypeDefault;
    toolbar.width = mScreenWidth;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _itemWH = (mScreenWidth - 60) / 4;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12;
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.contentInset = UIEdgeInsetsMake(12, 12, 12, 12);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self refreshCollectionView];
}


- (void)configShareView {
    //朋友圈
    self.friendBtn = [self setupButtonInShareViewWithImage:@"pyq_d" selImage:@"pyq_c" x:0 tag:100];
    [self.shareView addSubview:self.friendBtn];
    //QQ空间
    self.QQZoneBtn = [self setupButtonInShareViewWithImage:@"qzone_d" selImage:@"qzone_c" x:40 tag:200];
    [self.shareView addSubview:self.QQZoneBtn];
    //新浪
    self.webBtn = [self setupButtonInShareViewWithImage:@"weibo_d" selImage:@"weibo_c" x:80 tag:300];
    [self.shareView addSubview:self.webBtn];
}

- (UIButton *)setupButtonInShareViewWithImage:(NSString *)image selImage:(NSString *)selImage x:(CGFloat)x tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80 + x, (self.shareView.height - 25)/2.0, 25, 25);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    button.contentMode = UIViewContentModeScaleAspectFill;
    button.tag = tag;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/// 上传帖子详情照片
- (void)uploadSnsImagesArr {
    __weak typeof(self) weakSelf = self;
    _fileArray = [NSMutableArray array];
    if (weakSelf.dataArray.count <= 0) return;
    
    for (NSInteger i = 0; i < weakSelf.dataArray.count; i++) {
        UIImage *originalImage = weakSelf.dataArray[i];
        
        NSDictionary *dict = @{ @"file" : originalImage,
                                @"name" : [NSString stringWithFormat:@"imgOperation%ld.png",(long)i],
                                @"key"  : @"img" };
        [_fileArray addObject:dict];
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.titleText isEqualToString:@"自拍美拍"]) {
        if (self.dataArray.count > 1) {
            return self.dataArray.count;
        } else {
            return 1;
        }
    } else {
        if (self.dataArray.count >= 9) {
            return 9;
        } else {
            return self.dataArray.count + 1;
        }
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.deleteBtn.hidden = YES;
    if (self.dataArray.count) {
        if (indexPath.row == self.dataArray.count) {
            cell.imageView.image = [UIImage imageNamed:@"addpic"];
        } else {
            cell.imageView.image = self.dataArray[indexPath.row];
            cell.asset = _assetArray[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@"addpic"];
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteButtonClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.dataArray && indexPath.row == self.dataArray.count) || !self.dataArray) {
        
        if ([self.titleText isEqualToString:@"自拍美拍"]) {
//            self.isFirstEdit = NO;
            
            [self takePhoto];
            return;
        }
        
        [self presentImagePickerVc];
    } else { // 预览照片
        NSInteger *row = indexPath.row;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assetArray selectedPhotos:_dataArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowTakePicture = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _assetArray = [NSMutableArray arrayWithArray:assets];
            _dataArray = [NSMutableArray arrayWithArray:photos];
            [self refreshCollectionView];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - 点击事件

- (void)shareBtnClick:(UIButton *)btn {
    self.tag = btn.tag;
    if (btn.tag == 100) {
        self.friendBtn.selected = YES;
        self.QQZoneBtn.selected = NO;
        self.webBtn.selected = NO;
    }else if (btn.tag == 200) {
        self.friendBtn.selected = NO;
        self.QQZoneBtn.selected = YES;
        self.webBtn.selected = NO;
    }else if (btn.tag == 300) {
        self.friendBtn.selected = NO;
        self.QQZoneBtn.selected = NO;
        self.webBtn.selected = YES;
    }
    
}
-(void)frinedAndQQWithWeb:(NSInteger)tag {
    if (tag == 100) {
        [self shareButtonClickHandler:ShareTypeWeixiTimeline];
    }else if (tag == 200) {
        [self shareButtonClickHandler:ShareTypeQQSpace];
    }else if (tag == 300) {
        [self shareButtonClickHandler:ShareTypeSinaWeibo];
    }
}

- (void)shareButtonClickHandler:(ShareType)type
{
    UIImage *shareImage = [UIImage imageNamed:@"Icon-40"];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiSnsShare,self.data]];
    NSString *shareContent = @"我正在使用开心工作APP，找工作，赢大奖，享服务。";
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:@"[有人@你] 下载开心工作APP，开开心心找工作"
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatParamsByText:@"我正在使用开心工作APP，找工作，赢大奖，享服务。" title:@"[有人@你] 下载开心工作APP，开开心心找工作" url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    NSInteger typeInt = type;
    SSDKPlatformType shareType = typeInt;
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        BOOL ret = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
        if (ret) {
            [[UIViewController currentViewController] showTextHUDWithStr:@"分享中..."];
        }
    }
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            [[UIViewController currentViewController] showSuccessHUDWithStr:@"分享成功"];
            ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid": userModel.uid }];
            [ICEImporter shareIntegralWithParams:params];
        } else if (state == SSDKResponseStateFail) {
            NSLog(@"分享失败! %@",error);
            [[UIViewController currentViewController] showErrorHUDWithError:@"分享失败"];
        } else if (state == SSDKResponseStateCancel) {
            NSLog(@"取消分享 %@",userData);
        }
        [[UIViewController currentViewController] hideTextHud];
    }];
}

- (void)deleteButtonClik:(UIButton *)sender {
    [_dataArray removeObjectAtIndex:sender.tag];
    [_assetArray removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
//        if (_dataArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        if ([_titleText isEqualToString:@"自拍美拍"]) {
            [_collectionView reloadData];
        }else {
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];

        }
//        }
    } completion:^(BOOL finished) {
        [self refreshCollectionView];
    }];
}

/// 发布按钮点击事件
- (void)reportBtnClick {
    // 1.检查
    
    if (_isNetFlag) {
        return;
    }
    
    if ([ICELoginUserModel sharedInstance].connectionState == eEMConnectionDisconnected) {
        [ProgressHUD show:@"网络异常"];
        return;
    }

    
    if (!locationCityStr) {
        [ProgressHUD show:@"定位失败，请开启定位"];
        return;
    }
    
    if (([_titleText isEqualToString:@"广场"] || [_titleText isEqualToString:@"老乡"] || [_titleText isEqualToString:@"动态"]  || [_titleText isEqualToString:@"发布新帖"]) && self.textView.text.length <= 0) {
        [self showInfo:@"说点什么吧"]; return;
    }
    
    
    if (_retap) {
        return;
    }
    _retap = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _retap = NO;
    });
    
    _isNetFlag = YES;
    
    [self.view endEditing:YES];
    [self showTextHUDWithPleaseWait];
    
    [self uploadSnsImagesArr];
    
    
    // 2.上传图片
    __weak typeof(self) weakSelf = self;
    weakSelf.imgsPath = [NSString string];
    if (_fileArray.count <= 0) {
        [self sendSnsData]; return;
    }
    NSMutableString * str = [NSMutableString string];
    
    [TZHttpTool postWithUploadImages:ApiSnsUploadSnsImags params:nil formDataArray:_fileArray process:nil success:^(NSDictionary *result) {
         _isNetFlag = NO;
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        self.imgsPath = str;
        if (weakSelf.imgsPath.length > 1) {
            weakSelf.imgsPath = [weakSelf.imgsPath substringToIndex:weakSelf.imgsPath.length];
        }
        [self sendSnsData];
    } failure:^(NSString *msg) {
         _isNetFlag = NO;
     
        [ProgressHUD showError:@"图片上传失败,请重新上传"];
    }];
    
//    [TZHttpTool postWithUploadImages:ApiSnsUploadSnsImags params:nil files:_fileArray process:nil complete:^(BOOL successed, NSDictionary *result) {
//        _isNetFlag = NO;
//
//        NSLog(@"okokoook%@", str);
//
//        if (successed || !_isUpdateImagsFailed) {
//            [str deleteCharactersInRange:NSMakeRange(0, 1)];
//            self.imgsPath = str;
//            if (weakSelf.imgsPath.length > 1) {
//                weakSelf.imgsPath = [weakSelf.imgsPath substringToIndex:weakSelf.imgsPath.length];
//            }
//            [self sendSnsData];
//        } else {
//            _isUpdateImagsFailed = NO;
////            [self showErrorHUDWithError:@"图片上传失败"];
//            [ProgressHUD showError:@"图片上传失败,请重新上传"];
//
//        }
//
//    } completeOne:^(BOOL successed, NSDictionary *result) {
    
    
//        NSString * appendStr = [NSString stringWithFormat:@"#%@",result[@"data"]];
//
//        NSLog(@"发发发 %@", appendStr);
//
//        if (appendStr.length > 7) {
//            [str appendString:appendStr];
//        }else {
////            [ProgressHUD showError:@"图片上传失败"];
//            _isUpdateImagsFailed = YES;
//        }
//    }];
}

- (void)sendSnsData {
    // 图片上传成功后请求发布话题接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([_titleText isEqualToString:@"广场"] || [_titleText isEqualToString:@"老乡"] || [_titleText isEqualToString:@"发布新帖"]) {
        self.index = 3;
    }else if ([_titleText isEqualToString:@"自拍美拍"]) {
        self.index = 2;
    }else {
        self.index = 1;
    }
    params[@"tag"] = @(self.index);
    params[@"sessionid"] = [mUserDefaults objectForKey:@"sessionid"];
    
    if (locationCityStr) {
        params[@"fcityname"] = locationCityStr;
    }else {
        [ProgressHUD show:@"定位失败，请开启定位"];
        _isNetFlag = NO;
        return;
    }
    params[@"content"] = [self.textView fullTextWithIDRemoveModel:YES];
    if (([_titleText isEqualToString:@"自拍美拍"] || [_titleText isEqualToString:@"动态"]) && self.imgsPath.length <= 0) {
        [self showInfo:@"请添加图片"]; return;
    }
    params[@"images"] = self.imgsPath;
    [TZHttpTool postWithURL:ApiSnsWriteSns params:params success:^(NSDictionary *result) {
        [self showSuccessHUDWithStr:@"发布成功"];
        self.data = result[@"data"];
        [self.textView.userArray removeAllObjects];
        self.textView.userArray = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.refreshModel) {
                self.refreshModel();
            }
            [self.navigationController popViewControllerAnimated:NO];
            [self frinedAndQQWithWeb:self.tag];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self frinedAndQQWithWeb:self.tag];
        });
        if (_callBack) _callBack();
    } failure:^(NSString *msg) {
        [self showErrorHUDWithError:msg];
    }];
}

#pragma mark - 通知方法

/// 删除文字
- (void)emotionDidDelete {
    [self.textView deleteBackward];
}

/// 发送文字
- (void)emotionDidSend {
    
}

/// 键盘的frame发生改变时调用（显示、隐藏等）
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y >= self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height - 64;
        }
    }];
}

/// 监听文字改变
- (void)textDidChange {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEmoji]) {
//        return (self.uid.integerValue == 626 || self.uid.integerValue == 5 || self.uid.integerValue == 601 || self.uid.integerValue == 599);
//    }
    return YES;
}

#pragma mark - HWComposeToolbarDelegate

- (void)composeToolbar:(HWComposeToolbar *)toolbar didClickButton:(HWComposeToolbarButtonType)buttonType {
    switch (buttonType) {
        case HWComposeToolbarButtonTypeCamera: {  // 拍照
            [self takePhoto];
        } break;
        case HWComposeToolbarButtonTypePicture: { // 相册
            /// 去选择照片
            [self presentImagePickerVc];
        }  break;
        case HWComposeToolbarButtonTypeEmotion: // 表情\键盘
            [self switchKeyboard]; break;
    }
}

#pragma mark - 私有方法

/// 切换键盘
- (void)switchKeyboard {
    // self.textView.inputView == nil : 使用的是系统自带的键盘
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    // 开始切换键盘
    self.switchingKeybaord = YES;
    [self.textView endEditing:YES];
    self.switchingKeybaord = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
    });
}

/// 去选择照片
- (void)presentImagePickerVc {
    NSInteger maxImagesCount = 0;
    if ([self.titleText isEqualToString:@"自拍美拍"]) {
        maxImagesCount = 1;
    } else {
        maxImagesCount = 9;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:self];
    imagePickerVc.selectedAssets = _assetArray;
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.navigationBar.barTintColor = TZMainColor;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _assetArray = [NSMutableArray arrayWithArray:assets];
        _dataArray = [NSMutableArray arrayWithArray:photos];
        [self refreshCollectionView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (kiOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    if (self.dataArray.count >= 9) {
        [self showInfo:@"你最多只能选择9张图片"]; return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && kiOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(kiOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
//        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset

        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result completion:^(NSArray<TZAssetModel *> *models) {
                    TZAssetModel *assetModel = [models lastObject];
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                }];
            }];
        }];
      
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_assetArray addObject:asset];
    [_dataArray addObject:image];
    [self refreshCollectionView];
}

- (void)refreshCollectionView {
    NSInteger row = ((self.dataArray.count + 4) / 4);
    row = MIN(row, 3);
    self.collectionViewH.constant = (_itemWH + 12) * row + 12;
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)configLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter  = 5.0f;
    [locationManager startUpdatingLocation];
    if (IOS8after) {
        [locationManager requestAlwaysAuthorization];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            locationCityStr = placemark.locality;
            NSLog(@"%@     %@",locationCityStr,placemark.name);
        }
    }];
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 错误: %@",error);
}


@end
