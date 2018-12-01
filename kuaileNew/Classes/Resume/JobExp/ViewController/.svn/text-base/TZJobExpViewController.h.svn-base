//
//  ICEJobExpViewController.h
//  kuaile
//
//  Created by ttouch on 15/9/17.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZResumeRootController.h"

typedef enum : NSUInteger {
    TZJobExpViewControllerTypeNormal,  // 正常状态，创建简历
    TZJobExpViewControllerTypeEdit,    // 编辑状态，编辑简历
} TZJobExpViewControllerType;

typedef void(^ReturnJobExps)(NSMutableArray *);

@interface TZJobExpViewController : TZResumeRootController
@property (nonatomic, assign) TZJobExpViewControllerType type;
@property (nonatomic, strong) NSMutableArray *jobExps;
@property (nonatomic, copy) ReturnJobExps returnJobExps;
@property (nonatomic, copy) NSString *resume_id;
@property (nonatomic, assign) BOOL isEditingJobExp;
@end
