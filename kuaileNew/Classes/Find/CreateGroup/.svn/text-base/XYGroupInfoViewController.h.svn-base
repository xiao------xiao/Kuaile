//
//  XYGroupInfoViewController.h
//  kuaile
//
//  Created by 肖兰月 on 2017/4/13.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "TZResumeRootController.h"
@class XYGroupInfoModel;


/**
 *  群组成员类型
 */
typedef NS_ENUM(NSInteger, XYGroupOccupantType){
    XYGroupOccupantTypeOwner,//创建者
    XYGroupOccupantTypeMember,//成员
    XYGroupOccupantTypeJoin// 为加入
};


@interface XYGroupInfoViewController : TZResumeRootController
// 群ID
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) XYGroupInfoModel *model;

@property (nonatomic, assign) XYGroupOccupantType occupantType;

@property (assign, nonatomic) BOOL pushFromChatVc;

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;



@end
