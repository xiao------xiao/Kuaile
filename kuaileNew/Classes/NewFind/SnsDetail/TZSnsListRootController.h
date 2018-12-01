//
//  TZReportRootController.h
//  DemoProduct
//
//  Created by 谭真 on 16/6/9.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import <UIKit/UIKit.h>
// 来自微博
#import "HWEmotionTextView.h"
#import "HWComposeToolbar.h"
#import "HWComposePhotosView.h"
#import "HWEmotionKeyboard.h"
#import "HWEmotion.h"

typedef enum : NSUInteger {
    InputTypeReport,
    InputTypeComment,
    InputTypeReply,
} InputType;

@interface TZSnsListRootController : TZTableViewController

/// 记录回复和评论的内容
@property (nonatomic, assign) InputType inputType;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) UIButton *changeKBbtn;
@property (nonatomic, strong) UIButton *sendBbtn;

@property (nonatomic, strong) UIView *contentView;
/** 输入控件 */
@property (nonatomic, strong) HWEmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) HWComposeToolbar *toolbar;
/** 表情键盘 */
@property (nonatomic, strong) HWEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
@property (nonatomic, assign) BOOL noDismissKeyboard;

@property (nonatomic, assign) BOOL dismissFromScroll;  ///< 因为滑动导致键盘dismiss
@property (nonatomic, assign) BOOL isReply;            ///< 球场页 是在回复，不是评论
@property (nonatomic, assign) CGFloat textViewHeight;

- (void)configTableView;
- (void)saveTextViewAttriText;
- (void)switchKeyboard;
@end

