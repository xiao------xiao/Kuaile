//
//  TZAddJobExpViewController.h
//  kuaile
//
//  Created by liujingyi on 15/9/21.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZResumeRootController.h"

@class TZJobExpModel;
typedef void(^ReturnJobExpModel)(TZJobExpModel *);
typedef void(^ReturnJobExpModels)(NSMutableArray *);


@interface TZAddJobExpViewController : TZResumeRootController
@property (nonatomic, strong) NSMutableArray *jobExps;
@property (nonatomic, copy) ReturnJobExpModel returnJobExpModel;
@property (nonatomic, copy) ReturnJobExpModels returnJobExpModels;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) NSInteger index;


@end
