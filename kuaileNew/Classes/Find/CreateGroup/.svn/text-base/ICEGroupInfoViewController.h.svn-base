//
//  ICEGroupInfoViewController.h
//  kuaile
//
//  Created by ttouch on 15/10/21.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  群组成员类型
 */
typedef enum{
    ICEGroupOccupantTypeOwner,//创建者
    ICEGroupOccupantTypeMember,//成员
    ICEGroupOccupantTypeJoin// 为加入
}ICEGroupOccupantType;

@interface ICEGroupInfoViewController : TZBaseViewController <IChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgViewGroupHead;
@property (weak, nonatomic) IBOutlet UITextField *labGroupName;
@property (weak, nonatomic) IBOutlet UITextField *labGroupDesc;
@property (weak, nonatomic) IBOutlet UILabel *labGroupNum;
@property (weak, nonatomic) IBOutlet UILabel *labGroupHost;
@property (weak, nonatomic) IBOutlet UITextView *labGroupAddress;
@property (weak, nonatomic) IBOutlet UIView *viewGroupPeople;

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil group:(EMGroup *)chatGroup;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil groupID:(NSString *)chatGroupID;

@end
