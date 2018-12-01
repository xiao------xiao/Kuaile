//
//  ZYYSnsDetailHeader.h
//  DemoProduct
//
//  Created by 一盘儿菜 on 16/6/25.
//  Copyright © 2016年 周毅莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYYSnsDetailHeader : UIView {
    UIView *_indexView;
}
@property (nonatomic, copy) NSArray *namesArray;
@property (nonatomic, copy) NSArray *viewsArray;
@property (nonatomic, assign) NSInteger slideNumber;
@property (nonatomic, copy) void(^didChangeCallBack)(NSInteger index);
@end
