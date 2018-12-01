//
//  TZScreeningViewController.h
//  kuaile
//
//  Created by liujingyi on 15/9/23.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

// 返回用户选择的筛选信息
typedef void(^ReturnScreeningInfoBlock)(NSDictionary *,NSString *,BOOL);

@interface TZScreeningViewController : TZBaseViewController
@property (nonatomic, copy) NSString *jobTitle;
// 放在外面，允许外面赋值过来
@property (nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, copy) ReturnScreeningInfoBlock returnScreeningInfoBlock;
@property (nonatomic, strong) NSArray *welfares; // 福利选项

@property (nonatomic, assign) BOOL isSearch;     // 职列列表是搜索环境

/** 职位分类筛选参数laid */
@property (nonatomic, copy) NSString *laid;
@property (nonatomic, assign) BOOL isHotJobType;

@end
