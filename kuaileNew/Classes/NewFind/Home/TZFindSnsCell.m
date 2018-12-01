
//
//  TZFindSnsCell.m
//  kuaile
//
//  Created by ttouch on 2016/12/21.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZFindSnsCell.h"
#import "TZFindSnsModel.h"
#import "TZPhotosGroupView.h"
#import "SelectAlert.h"
#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "ReportView.h"
#import "ORTimeTool.h"
#import "ICESelfInfoViewController.h"
#import "XYFundamentTabViewController.h"
#import "ProgressHUD.h"

@interface TZFindSnsCell () {
    BOOL _netFlag;
}

@property(nonatomic,strong) UIImageView * imageVie;
@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;
@property (nonatomic, strong, getter=getGiftView)   ICEGiftView *giftView;
@property (nonatomic,strong) NSMutableArray * imgSupArr;
@property (nonatomic,strong) NSArray * titles;
@end

@implementation TZFindSnsCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.iconImgView.layer.cornerRadius = 20;
    
    self.evaluateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.evaluateBtn.layer.cornerRadius = 5;
    self.zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.zanBtn.layer.cornerRadius = 5;
    
    self.careBtn.layer.borderColor = TZMainColor.CGColor;
    self.careBtn.layer.borderWidth = 1.0;
    self.careBtn.layer.cornerRadius = 14;
    [self.careBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.careBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.careBtn setTitleColor:TZMainColor forState:UIControlStateNormal];
    [self.careBtn setTitleColor:TZColorRGB(168) forState:UIControlStateSelected];
    
    [self.zanBtn setImage:[UIImage imageNamed:@"zan_def"] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:TZColorRGB(133) forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"zan_sel"] forState:UIControlStateSelected];
    [self.zanBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
    
    if (self.width < 375) {
        self.attentionBtnConstraintH.constant = 24;
        self.attentionBtnConstraintW.constant = 50;
        self.careBtn.layer.cornerRadius = 12;
        self.careBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.nameLbl.font = [UIFont systemFontOfSize:13];
    }
}

- (NSMutableArray *)imgSupArr {
    if (!_imgSupArr) {
        _imgSupArr = [NSMutableArray array];
    }
    return _imgSupArr;
}


- (void)setModel:(TZFindSnsModel *)model {
    _model = model;
    // 用户信息
    self.nameLbl.text = model.unickname;
    CGFloat nameW = [CommonTools sizeOfText:model.unickname fontSize:14].width;
    CGFloat maxNameConstraintW = 0;
    if (mScreenWidth < 375) {
        maxNameConstraintW = self.width * 0.4 - 5;
    } else {
        maxNameConstraintW = self.width * 0.5 - 5;
    }
    self.nameConstraintW.constant = nameW > maxNameConstraintW ? maxNameConstraintW : nameW;
    self.timeSiteLbl.text = [NSString stringWithFormat:@"%@ %@",[ORTimeTool timeNewShortStr:model.create_at.integerValue],model.fcityname];
    [self.iconImgView sd_setImageWithURL:TZImageUrlWithShortUrl(model.uvatar) placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
    // 如果是用户自己
    if (model.ismine) {
        self.careBtn.hidden = YES;
    } else {
        self.careBtn.hidden = NO;
    }
    if ([model.gender isEqual:@"1"]) {
        [self.sexLbl setTitle:model.age forState:UIControlStateNormal];
        [self.sexLbl setBackgroundImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
    }else {
        [self.sexLbl setTitle:model.age forState:UIControlStateNormal];
        [self.sexLbl setBackgroundImage:[UIImage imageNamed:@"boy"] forState:UIControlStateNormal];
    }
    // 图片
    self.imgSupViewContrainstH.constant = model.imageViewHeight;
    self.imgSupView.models = model.imgArr;

    self.createTimeLabel.hidden = YES;
    
    // 点赞内容
    if (model.zan_list.count) {
        self.hitViewH.constant = 40;
        self.lineView.hidden = NO;
        for (NSInteger i = 0; i < model.zan_list.count; i++) {
             UIImageView *imageView = [self createdZanImgView:i];
            imageView.hidden = NO;
            id  zanimage = model.zan_list[i];
            if ([zanimage isKindOfClass:[TZSnsHitModel class]]) {
                TZSnsHitModel *zanmodel = zanimage;
                [imageView sd_setImageWithURL:[NSURL URLWithString:zanmodel.uvatar] placeholderImage:TZPlaceholderAvaterImage options:SDWebImageRefreshCached];
            }
        }
        for (NSInteger i = model.zan_list.count; i < self.imgSupArr.count; i++) {
            UIImageView *imageView = [self createdZanImgView:i];
            imageView.hidden = YES;
        }
        [self setNeedsLayout];
    } else {
        self.hitViewH.constant = 0;
        self.lineView.hidden = YES;
    }
    
    self.zanBtn.selected = model.is_zan;
    [self.zanBtn setTitle:model.zan_num forState:UIControlStateNormal];
    
    self.careBtn.selected = model.isconcern;
    self.careBtn.layer.borderWidth = model.isconcern ? 0 : 1;
    
    self.zanImageView.image = model.is_zan ? [UIImage imageNamed:@"zan_sel"] : [UIImage imageNamed:@"zan_def"];
    // 评论
    [self.evaluateBtn setTitle:model.comment_num forState:UIControlStateNormal];
    [self.evaluateBtn setTitle:model.comment_num forState:UIControlStateSelected];
    // 内容
    if (model.content && model.content.length) {
        self.contentStrView.attributedText = [[NSAttributedString alloc] initWithAttributedString:model.content];
    }

//    self.contentStrView.attributedText = [[NSAttributedString alloc] initWithString:model.content];
    self.contentStrContrainstH.constant = model.textHeight;
    
    self.contentStrView.backgroundColor = [UIColor whiteColor];
    self.imgSupView.backgroundColor = [UIColor whiteColor];
    [self updateConstraints];
}

- (UIImageView *)createdZanImgView:(NSInteger)image {
    UIImageView *zanImgView;
    if (image < self.imgSupArr.count) {
        zanImgView = self.imgSupArr[image];
    } else {
        zanImgView = [UIImageView new];
        zanImgView.contentMode = UIViewContentModeScaleAspectFill;
        zanImgView.tag = image;
        zanImgView.clipsToBounds = YES;
        zanImgView.userInteractionEnabled = YES;
        [self.imgSupArr addObject:zanImgView];
        [self.zanImgSupView addSubview:zanImgView];
    }
    return zanImgView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
  
    for (NSInteger i = 0; i < self.imgSupArr.count; i ++) {
        if (i < self.imgSupArr.count) {
            UIImageView *imageView = [self createdZanImgView:i];
            CGFloat zanimgViewX = i * (30 + 10);
            imageView.frame = CGRectMake(zanimgViewX, 5, 30, 30);
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 15;
        }
    }
}

- (IBAction)clickCareBtn:(UIButton *)sender {
    if (self.careBtnClicked) {
        self.careBtnClicked();
    }
}
#pragma mark -- 评论跳转按钮
- (IBAction)clickEvaluateBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FindSnsCelldelegate:removeArray:)]) {
        [self.delegate FindSnsCelldelegate:self removeArray:_model];
    }
}
#pragma mark -- 右边弹框视图
- (IBAction)moreBtnClick:(UIButton *)sender {
    if (![TZUserManager isLogin]) return;
    __block typeof(self) WEAKself = self;
    if (_model.ismine || [_model.uid isEqualToString:[TZUserManager getUserModel].uid]) {
        self.titles = @[@"分享",@"不看该内容",@"举报用户",@"删除帖子"];
    }else {
        self.titles = @[@"分享",@"不看该内容",@"举报用户"];
    }
    [SelectAlert showWithTitle:@"选择您的操作" titles:self.titles selectIndex:^(NSInteger selectIndex) {
        if (selectIndex == 0) { // 分享
            [self showSheet];
            [self showPhotoActionSheet];
            [self configGiftBtn];
        }else if (selectIndex == 1) { // 不看该内容
            [TZHttpTool postWithURL:ApiSnsShieldSns params:@{@"sessionid":[mUserDefaults objectForKey:@"sessionid"],@"sid":_model.sid} success:^(NSDictionary *result) {
                if (_moreBtnClick) {
                    self.moreBtnClick();
                }
            } failure:^(NSString *msg) {
                NSLog(@"%@",msg);
            }];
        }else if (selectIndex == 2) { // 举报用户
            ReportView * report = [[ReportView alloc]init];
            report.sid = _model.sid;
            report.titleArray = @[@"色情低俗",@"广告骚扰",@"谣言",@"政治敏感",@"威胁恐吓",@"其他"];
            [[UIApplication sharedApplication].keyWindow addSubview:report];
        }else if (selectIndex == 3) { // 删除帖子
            if ([self.delegate respondsToSelector:@selector(FindSnsCelldelegate:sidID:removeArray:)]) {
                [self.delegate FindSnsCelldelegate:self sidID:_model.sid removeArray:_model];
            }
        }
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
    } showCloseButton:NO];
    
}

- (void)configGiftBtn {
    [[self.getGiftView.btnQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQ];
    }];
    [[self.getGiftView.btnWeChat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiSession];
    }];
    [[self.getGiftView.btnSina rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeSinaWeibo];
    }];
    [[self.getGiftView.btnQzone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeQQSpace];
    }];
    [[self.getGiftView.btnWeChatFriend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self shareButtonClickHandler:ShareTypeWeixiTimeline];
    }];
    [[self.getGiftView.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}


- (void)shareButtonClickHandler:(ShareType)type
{
    UIImage *shareImage = [UIImage imageNamed:@"Icon-40"];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiSnsShare,self.model.sid]];
    NSString *shareContent = @"我正在使用开心工作APP，找工作，赢大奖，享服务。";
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    
    
    NSString *shareContenta;
    if (self.model.shareTitle.length > 0) {
        shareContent = self.model.shareTitle;
        
    }else {
        shareContent = @"美拍签到";
        
    }
    
    NSArray *titles = @[@"动态",@"美拍",@"广场",@"老乡",@"附近"];
    
    NSString *shareTitle = [NSString stringWithFormat:@"开心工作-%@",titles[self.model.tag.integerValue-1]];
    
    // v3.3.0版 分享
    if (type == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareURL.absoluteString];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:shareImage
                                        url:shareURL
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:shareContent
//                                     images:shareImage
//                                        url:shareURL
//                                      title:@"[有人@你] 下载开心工作APP，开开心心找工作"
//                                       type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupWeChatParamsByText:@"我正在使用开心工作APP，找工作，赢大奖，享服务。" title:@"[有人@你] 下载开心工作APP，开开心心找工作" url:shareURL thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    NSInteger typeInt = type;
    SSDKPlatformType shareType = typeInt;
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
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
        [self cancelAnimation:^{
            [self.backView removeFromSuperview];
        }];
    }];
}
- (void)showSheet {
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [self.backView addSubview:self.sheetView];
    [self.sheetView addSubview:self.giftView];
}
/** 显示 */
- (void)showPhotoActionSheet {
    CGRect frame = self.sheetView.frame;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 300;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        DLog(@"完成");
    }];
}

/** 隐藏 */
- (void)cancelAnimation:(void (^)(void))comple {
    CGRect frame = self.sheetView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.25f animations:^{
        self.sheetView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (comple) {
            comple();
        }
        [self.backView removeFromSuperview];
    }];
}

#pragma mark - Getters And Setters
- (ICEGiftView *)getGiftView {
    if (_giftView == nil) {
        _giftView = [[ICEGiftView alloc] init];
        _giftView.frame = CGRectMake(0, 0, __kScreenWidth, 300);
    }
    return _giftView;
}
/** 底板SheetView*/
- (UIView *)getSheetView{
    if (_sheetView == nil) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300);
        _sheetView = [[UIView alloc] initWithFrame:frame];
        _sheetView.backgroundColor = [UIColor lightGrayColor];
    }
    return _sheetView;
}

- (UIView *)getBackView{
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backView.alpha = 0;
    }
    return _backView;
}



- (IBAction)clickZanBtn:(UIButton *)sender {
    
    
    if (_netFlag) {
        return;
    }
    
    if ([TZUserManager isLogin]) {
        
        _netFlag = YES;
        
        [ProgressHUD showLoading];

        
        sender.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        });
        [TZHttpTool postWithURL:ApiSnsZanSns params:@{@"sessionid":[mUserDefaults objectForKey:@"sessionid"],@"sid":@(_model.sid.integerValue),@"buid":_model.uid} success:^(NSDictionary *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 点赞数
                BOOL isAdd = NO;
                // 改变数据
                sender.selected = !sender.selected;
                NSInteger hitNum = self.model.zan_num.integerValue;
                if (sender.selected) {
                    hitNum ++;
                    isAdd = YES;
                } else {
                    hitNum --;
                }
                
                self.model.zan_num = [NSString stringWithFormat:@"%zd",hitNum];
                
                [self refreshLikeBtnAnimation:YES];
                
                NSMutableArray *zanlist = [NSMutableArray arrayWithArray:self.model.zan_list];
                
                XYUserInfoModel *user= [TZUserManager getUserModel];
                
                //        ICELoginUserModel *user = [ICELoginUserModel sharedInstance];
                TZSnsHitModel *model = [[TZSnsHitModel alloc] init];
                model.uvatar = user.avatar;
                model.uid = user.uid;
                if (isAdd) {
                    [zanlist addObject:model];
                }else {
                    for (TZSnsHitModel * user_item in zanlist) {
                        if ([user_item.uid isEqualToString:user.uid]) {
                            [zanlist removeObject:user_item]; break;
                        }
                    }
                }
                self.model.zan_list = zanlist;
                self.model.is_zan = !self.model.is_zan;
                _netFlag = NO;
                if (self.blockClickZanReload) {
                    self.blockClickZanReload(result[@"msg"]);
                }
                [ProgressHUD dismiss];
            });
            
        } failure:^(NSString *msg) {
            [[UIViewController currentViewController] showHint:@"网络不好！请检查网络"];
            _netFlag = NO;
            [ProgressHUD dismiss];

        }];
    }
}

/// 刷新点赞按钮 animation:是否需要动画
- (void)refreshLikeBtnAnimation:(BOOL)animation{
    if (animation) { // 需要动画
        self.zanBtn.selected = !self.zanBtn.isSelected;
        NSNumber *animationScale1 = @(1.6);
        NSNumber *animationScale2 = @(0.90);
        [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.zanBtn.imageView.layer setValue:animationScale1 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.zanBtn.imageView.layer setValue:animationScale2 forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.zanBtn.imageView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:nil];
            }];
        }];
    } else { // 不需要动画
        self.zanBtn.selected = !self.zanBtn.isSelected;
        
    }
}
// 赞数跳转
- (IBAction)clickSeeMoreZan:(id)sender {
//    if (self.checkMoreZanBlock) {
//        self.checkMoreZanBlock();
//    }
    
    XYFundamentTabViewController *zanVc = [[XYFundamentTabViewController alloc] init];
    zanVc.model = self.model;
    zanVc.rowH = 60;
    [[UIViewController currentViewController].navigationController pushViewController:zanVc animated:YES];
}

- (IBAction)userInfoBtnClick:(id)sender {
//     if (![TZUserManager isLogin]) return;
    // 个人中心
    ICESelfInfoViewController *userInfoVc = [[ICESelfInfoViewController alloc] init];
//    if (self.model.ismine) {
//        userInfoVc.type = ICESelfInfoViewControllerTypeSelf;
//    } else {
        userInfoVc.type = ICESelfInfoViewControllerTypeOther;
        userInfoVc.uid = self.model.uid;
        userInfoVc.nickName = self.model.unickname;
//    }
    [[UIViewController currentViewController].navigationController pushViewController:userInfoVc animated:YES];
}




@end
