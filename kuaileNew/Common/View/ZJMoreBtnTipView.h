//
//  ZJGoodsClassifyView.h
//  yishipi
//
//  Created by 吴振建 on 16/9/30.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJMoreBtnTipView : UIView
@property(nonatomic,copy)void(^btnClickBlock)(NSInteger tag);

@property(nonatomic,strong)UIButton *coverBtn;

//@property (nonatomic, strong) NSArray *imgs;
//@property (nonatomic, strong) NSArray *texts;

- (void)creatViewBtn;
@end
