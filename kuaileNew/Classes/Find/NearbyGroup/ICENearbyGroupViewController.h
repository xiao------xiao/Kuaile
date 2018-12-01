//
//  ICENearbyGroupViewController.h
//  kuaile
//
//  Created by ttouch on 15/10/17.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ICENearbyGroupViewControllerTypeNear,     // 附近的群
    ICENearbyGroupViewControllerTypeRecommed, // 推荐的群
} ICENearbyGroupViewControllerType;

@interface ICENearbyGroupViewController : TZBaseViewController
@property (nonatomic, assign) ICENearbyGroupViewControllerType type;
@end
