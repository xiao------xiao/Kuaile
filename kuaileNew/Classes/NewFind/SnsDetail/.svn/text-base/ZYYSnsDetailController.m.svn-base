//
//  ZYYSnsDetailController.m
//  DemoProduct
//
//  Created by 一盘儿菜 on 16/6/25.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import "ZYYSnsDetailController.h"
#import "TZFindSnsCell.h"
#import "ZYYJudgeCell.h"
#import "TZFindSnsModel.h"
#import "ZYYSnsDetailHeader.h"
#import "TZContactTool.h"
//#import "XYTipView.h"
#import "SelectAlert.h"
#import "ICEGiftView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK+InterfaceAdapter.h>
#import "ReportView.h"
#import "XYUserInfoModel.h"
#import "YYKit.h"

#import "IQKeyboardManager.h"

@interface ZYYSnsDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate> {
    BOOL _noDismissKeyboard;
    BOOL _canLoadTableView;
    BOOL _showingTip;
    NSInteger _row;
    NSInteger _section;
}
//@property(nonatomic,strong) UITableView * tableView1;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet HWEmotionTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *comtentView;
@property (weak, nonatomic) IBOutlet UIButton *keyBoardBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) ReportView *tipView;
@property (nonatomic, copy) NSString *commentid;
@property (nonatomic, copy) NSString *cid;

@property (nonatomic, strong, getter=getBackView)   UIView      *backView;
@property (nonatomic, strong, getter=getSheetView)  UIView      *sheetView;
@property (nonatomic, strong, getter=getGiftView)   ICEGiftView *giftView;
//@property(nonatomic,strong) NSArray * titleArray;
@property(nonatomic,assign) BOOL isCommet;
// 评论数据
@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) XYUserInfoModel *infoModel;

@property (nonatomic,strong) NSArray * titles;
@end

@implementation ZYYSnsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.commentTextView.placeholder = @"评论一下吧...";
    self.commentTextView.delegate = self;
    self.rightNavImageName = @"cz";
    _showingTip = YES;
    _isCommet = YES;
    [self refreshLikeBtnAnimation:NO];
    _commentArray = [NSMutableArray array];
    [self refreshDataWithHeader];

    [mNotificationCenter addObserver:self selector:@selector(keyboardWillChangeF:) name:UIKeyboardWillShowNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFe:) name:UIKeyboardWillHideNotification object:nil];
    // 表情选中的通知
    [mNotificationCenter addObserver:self selector:@selector(emotionSelect:) name:HWEmotionDidSelectNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    self.infoModel = [TZUserManager getUserModel];
    XYUserInfoModel *mod = self.infoModel;
    if (!self.infoModel) {
        [TZUserManager syncUserModelWithCompletion:^(XYUserInfoModel *model) {
            self.infoModel = model;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)configTableView {
    _canLoadTableView = NO;
    [super configTableView];
    self.tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 51);
    [self.tableView registerNib:[UINib nibWithNibName:@"TZFindSnsCell" bundle:nil] forCellReuseIdentifier:@"TZFindSnsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYYJudgeCell" bundle:nil] forCellReuseIdentifier:@"ZYYJudgeCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _canLoadTableView = YES;
//    [self.tableView reloadData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithHeader)];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataWithFooter)];
    self.tableView.mj_footer = footer;
    
    if (self.model.comment.count) {
        [self.commentBtn setTitle:self.model.comment_num forState:0];
    } else {
        [self.commentBtn setTitle:@"评论" forState:0];
    }
}

- (void)refreshDataWithFooter {
    self.page ++;
    if (self.page > self.totalPage) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)refreshSnsDetailData {
    [self refreshDataWithHeader];
}

- (void)keyboardWillChangeF:(NSNotification *)notification {
    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        CGRect bounds = self.view.bounds;
        bounds.origin.y = rect.size.height;
        self.view.bounds = bounds;
    }];

}
- (void)keyboardWillChangeFe:(NSNotification *)notification {

    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect bounds = self.view.bounds;
        bounds.origin.y = 0;
        self.view.bounds = bounds;
    }];
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    _commentTextView = textView;
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (void)refreshDataWithHeader {
    self.page = 1;
    NSString *sid = self.model ? self.model.sid : _sid;
    NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
    if (!sid) return;
    [TZHttpTool postWithURL:ApiSnsGetDetailSns params:@{@"sid":sid, @"sessionid":sessionid} success:^(NSDictionary *result) {
        
        
        
//        self.model = [TZFindSnsModel mj_objectArrayWithKeyValuesArray:result[@"data"]].firstObject;
        NSArray *array =result[@"data"];
        
        if (array.count <= 0) {
            return ;
        }
        self.model = [TZFindSnsModel modelWithJSON:array.firstObject];
        
        for (NSDictionary * dic in array) {
            self.commentId = dic[@"sid"];
            NSArray * commenArr = dic[@"comment"];
            for (NSDictionary * dcit in commenArr) {
                self.cid = dcit[@"cid"];
            }
            if (self.page == 1) {
                [
                 _commentArray removeAllObjects];
            }
            NSArray * commentArray = [TZSnsCommentModel mj_objectArrayWithKeyValuesArray:dic[@"comment"]];
            [_commentArray addObjectsFromArray:commentArray];
            
            self.model.comment = _commentArray;
            self.models = [NSMutableArray arrayWithObject:self.model];
            [self refreshSlideNumber];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView endRefresh];
            });
        });
    } failure:^(NSString *msg) {
        [self showInfo:msg];
        [self.tableView endRefresh];
    }];
}

#pragma mark - UITableViewDelegateAndDataSoure
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TZFindSnsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZFindSnsCell"];
        if (_model) {
            cell.model = self.model;
        }
        cell.blockClickZanReload = ^(NSString *msg) {
            [self showInfo:msg];
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            [mNotificationCenter postNotificationName:@"needRefreshFindVcNoti" object:nil];
        };
        
        MJWeakSelf
        [cell setCareBtnClicked:^ {
            if ([TZUserManager isLogin]) {
                [TZHttpTool postWithURL:ApiSnsConcernUser params:@{@"sessionid":[mUserDefaults objectForKey:@"sessionid"],@"buid":_model.uid} success:^(NSDictionary *result) {
                    _model.isconcern = !_model.isconcern;
                    cell.careBtn.selected = _model.isconcern;
                    cell.careBtn.layer.borderWidth = _model.isconcern ? 0 : 1;
//                    NSMutableArray *indexArr = [NSMutableArray array];
//                    for (NSInteger i = 0; i < weakSelf.models.count; i++) {
//                        TZFindSnsModel *handleModel = weakSelf.models[i];
//                        if ([handleModel.uid isEqualToString:_model.uid]) {
//                            handleModel.isconcern = _model.isconcern;
//                            NSIndexPath *index = [NSIndexPath indexPathWithIndex:i];
//                            [indexArr addObject:index];
//                        }
//                    }
                    [[UIViewController currentViewController] showSuccessHUDWithStr:result[@"msg"]];
                    [mNotificationCenter postNotificationName:@"needRefreshFindVcNoti" object:nil];
                    //                [mNotificationCenter postNotificationName:@"didEditUserInfoNoti" object:nil];
                    [tableView reloadData];
                } failure:^(NSString *msg) {
                }];
            }
        }];

        
        cell.moreBtn.hidden = YES;
        cell.careBtnRightMarginConstrain.constant = 15;
        return cell;
    } else {
        ZYYJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYYJudgeCell"];
        TZSnsCommentModel *model = self.models[indexPath.row];
        cell.model = model;
        if ([model.uid isEqualToString:self.infoModel.uid]) {
            cell.isMine = YES;
        } else {
            cell.isMine = NO;
        }
        [cell setTapAvatarBlock:^(TZSnsCommentModel *model){
            
            
            
            if ((![model.uid isEqualToString:[TZUserManager getUserModel].uid]) && (![self.model.uid isEqualToString:[TZUserManager getUserModel].uid])) {
                return ;
            }
            
            UIAlertController * alert = [ UIAlertController alertControllerWithTitle:@"" message:@"删除评论" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * okAlert = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString * sessionid = [mUserDefaults objectForKey:@"sessionid"];
                [TZHttpTool postWithURL:ApiSnsDelComment params:@{@"sessionid":sessionid, @"cid":@(model.cid.integerValue)} success:^(NSDictionary *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.models removeObject:model];
                        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [mNotificationCenter postNotificationName:@"needRefreshFindVcNoti" object:nil];
                        self.model.comment_num = [NSString stringWithFormat:@"%zd", self.model.comment_num.integerValue-1];
                        [self.tableView reloadData];
                    });
                    [self showHint:result[@"msg"]];
                } failure:^(NSString *msg) {
                    [self showHint:msg];
                }];
            }];
            [alert addAction:cancelAlert];
            [alert addAction:okAlert];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            
            
        }];
        [cell.textView setCallBack:^(BOOL isMember, NSString *url) {
            if (self.textView.isFirstResponder) {
                [self.textView endEditing:YES]; return ;
            }
            if (!url) {
                NSLog(@"该特殊字符未有对应ID，无法前往"); return;
            }
            if (isMember) {
               
            } else if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
                TZWebViewController *webViewVc = [[TZWebViewController alloc] init];
                webViewVc.url = url;
                [self.navigationController pushViewController:webViewVc animated:YES];
            }
        }];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        _isCommet = NO;
        [self.commentTextView becomeFirstResponder];
    }
    
    if (self.models.count <= 0) {
        return;
    }
    
    TZSnsCommentModel *model = self.models[indexPath.row];
    self.commentTextView.placeholder = [NSString  stringWithFormat:@"回复%@：",model.unickname];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.model.totalHeight;
    } else {
//        CGFloat height = [self.models[indexPath.row] contentLableHeight] + 72;
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_canLoadTableView) {
        return 0;
    }
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    ZYYSnsDetailHeader *headerView = [[ZYYSnsDetailHeader alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, 64)];
    headerView.backgroundColor = [UIColor whiteColor];
    NSString *str = self.model.comment_num ? self.model.comment_num : @"0";
    NSString *comment = [NSString stringWithFormat:@"评论(%@)",str];
    headerView.namesArray = @[comment];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, mScreenWidth, 10);
    view.backgroundColor = TZColorRGB(246);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < 1) {
        return 15;
    }
    return 0;
}
-(void)longatap:(UILongPressGestureRecognizer *)longtap {
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.textView) {
        return;
    }
    if (_noDismissKeyboard) {
        return;
    }
    if (self.textView.isFirstResponder) {
        [self.textView endEditing:YES]; return ;
    }
}

- (void)refreshSlideNumber {
    self.models = self.model.comment;
    [self.tableView reloadData];
}

#pragma mark - click Event

- (IBAction)commentAction:(UIButton *)sender {
    _row = 0;
    _section = 0;
    [self showInputTextViewWithTipTitle:@"评论一下吧" inputType:InputTypeComment];
}

- (IBAction)reportAction:(UIButton *)sender {
    _row = 0;
    _section = 0;
    [self showInputTextViewWithTipTitle:@"说点什么吧" inputType:InputTypeReport];
}



#pragma mark - 通知方法

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

#pragma mark - 私有方法
- (void)showInputTextViewWithTipTitle:(NSString *)tipTitle inputType:(InputType)inputType {
    if ([TZUserManager isLogin]) {
        _noDismissKeyboard = YES;
        [self.view bringSubviewToFront:self.contentView];
        if ([tipTitle containsString:@"回复"]) {
            TZSnsCommentModel *model = self.model.comment[_row];
            self.commentId = model.cid;
        }
        self.inputType = inputType;
        self.textView.placeholder = tipTitle;
        [self.textView becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _noDismissKeyboard = NO;
        });
    }
}

/// 刷新点赞按钮 animation:是否需要动画
- (void)refreshLikeBtnAnimation:(BOOL)animation{
    if (animation) { // 需要动画
        NSNumber *animationScale1 = @(1.5);
        NSNumber *animationScale2 = @(0.90);
        [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.zanBtn.imageView.layer setValue:animationScale1 forKeyPath:@"transform.scale"];
            [self refreshLikeBtnImage];
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
        [self refreshLikeBtnImage];
    }
    // 刷新点赞文字
    if (self.model.is_zan) {
        self.zanBtn.selected = YES;
        [self.zanBtn setTitle:self.model.hit_num forState:UIControlStateSelected];
    } else if (self.model.hit_num.integerValue) {
        self.zanBtn.selected = NO;
        [self.zanBtn setTitle:self.model.hit_num forState:UIControlStateNormal];
    } else {
        self.zanBtn.selected = NO;
        [self.zanBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
}

/// 刷新点赞按钮图片
- (void)refreshLikeBtnImage {
    if (self.model.is_zan) {
        [self.zanBtn setImage:[UIImage imageNamed:@"zan_sel"] forState:UIControlStateSelected];
        [self.zanBtn setTitleColor:TZMainColor forState:UIControlStateSelected];
    } else {
        [self.zanBtn setImage:[UIImage imageNamed:@"zan_def"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:TZColorRGB(133) forState:UIControlStateNormal];
    }
    self.zanBtn.selected = self.model.is_zan;
}


#pragma mark -- 导航右边按钮弹框
- (void)didClickRightNavAction {
    __block typeof(self) WEAKself = self;
    if (_model.ismine) {
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
            NSString * str = [mUserDefaults objectForKey:@"sessionid"];;
            [TZHttpTool postWithURL:ApiSnsShieldSns params:@{@"sessionid":str,@"sid":_model.sid} success:^(NSDictionary *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.refreshUIBlock) {
                        self.refreshUIBlock();
                    }
                });
                [self.tableView reloadData];
                
            } failure:^(NSString *msg) {
                NSLog(@"%@",msg);
            }];
        }else if (selectIndex == 2) { // 举报用户
            ReportView * report = [[ReportView alloc]init];
            report.sid = self.commentId;
            report.titleArray = @[@"色情低俗",@"广告骚扰",@"谣言",@"政治敏感",@"威胁恐吓",@"其他"];
            
            [[UIApplication sharedApplication].keyWindow addSubview:report];
        }else if (selectIndex == 3) { // 删除帖子
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshDeleteUIBlock) {
                self.refreshDeleteUIBlock(self.model,self.commentId);
            }
        }
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
    } showCloseButton:NO];

}

/// 表情被选中了
- (void)emotionSelect:(NSNotification *)notification {
    HWEmotion *emotion = notification.userInfo[HWSelectEmotionKey];
    [self.commentTextView insertEmotion:emotion];
}
- (IBAction)emojiBtnClicked:(UIButton *)sender {
    
    if (self.commentTextView.inputView == nil) { // 切换为自定义的表情键盘
        self.commentTextView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
        [_keyBoardBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
    } else { // 切换为系统自带的键盘
        self.commentTextView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
        [_keyBoardBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }
    // 开始切换键盘
    self.switchingKeybaord = YES;
    [self.commentTextView endEditing:YES];
    self.switchingKeybaord = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.commentTextView becomeFirstResponder];
    });
}

- (IBAction)sendBtnClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [TZUserManager isLogin];
    if (_isCommet) {
        NSMutableDictionary * params = @{
                                         @"sessionid" :[mUserDefaults objectForKey:@"sessionid"],
                                         @"sid" :@(self.commentId.integerValue),
                                         @"content" :self.commentTextView.text
                                         };
        [self commentLoadWork:params];
    }else {
        NSMutableDictionary * params = @{
                                         @"sessionid":[mUserDefaults objectForKey:@"sessionid"],
                                         @"sid":@(self.commentId.integerValue),
                                         @"content":self.commentTextView.text,
                                         @"cid": self.cid
                                         };
        [self commentLoadWork:params];
    }
}

#pragma mark -- 评论接口
-(void)commentLoadWork:(NSMutableDictionary *)params {
    
    [TZHttpTool postWithURL:ApiSnsCommentSns params:params success:^(NSDictionary *result) {
        [self showInfo:result[@"msg"]];
        
        self.commentTextView.text = nil;
        [self refreshDataWithHeader];
//        [self.tableView reloadData];
//        self.model.comment_num = [NSString s]
        [mNotificationCenter postNotificationName:@"needRefreshFindVcNoti" object:nil];
    } failure:^(NSString *msg) {
    }];
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
//    UIImage *shareImage = [UIImage imageNamed:@"hapjoba1a1"];
    
    ICELoginUserModel *userModel = [ICELoginUserModel sharedInstance];
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiSnsShare,self.model.sid]];
//    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ApiSnsShare,self.model.sid]];
    NSString *shareContent;
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


@end
