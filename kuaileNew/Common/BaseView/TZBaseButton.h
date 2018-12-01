//
//  TZBaseButton.h
//  yishipi
//
//  Created by ttouch on 16/9/28.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZBaseButton : UIButton

/// 图片方向 1.左边 2.右边
@property (nonatomic, assign) NSInteger direction;

/// 可以取消选中
@property (nonatomic, assign) BOOL canCancelSelect;

/// 可以保持选中  在选中其中按钮的时候，不要把我取消选中
@property (nonatomic, assign) BOOL canKeepSelect;

@end
