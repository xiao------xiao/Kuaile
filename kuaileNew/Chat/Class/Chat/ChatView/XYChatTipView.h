//
//  XYChatTipView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/10.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYChatTipView : UIView

@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentBtn;

@property (nonatomic, copy) void (^didClickAttentionBtnBlock)(BOOL isSelected);
@property (nonatomic, copy) void (^didClickScreenBtnBlock)(BOOL isSelected);

- (IBAction)attentBtnClick:(UIButton *)sender;

@end
