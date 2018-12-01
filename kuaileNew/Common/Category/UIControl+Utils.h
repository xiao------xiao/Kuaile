//
//  UIControl+Utils.h
//  yangmingFinance
//
//  Created by ttouch on 2016/11/17.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Utils)

- (void)setControlEventTouchWithBlock:(void (^)(id sender))block;

@end
