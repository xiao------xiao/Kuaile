//
//  ICEIssueViewController.h
//  kuaile
//
//  Created by ttouch on 15/10/27.
//  Copyright © 2015年 ttouch. All rights reserved.
//

typedef void(^ICEIssueBlock)();

@interface ICEIssueViewController : TZBaseViewController

@property (nonatomic, copy) ICEIssueBlock issueBlock;

@end
