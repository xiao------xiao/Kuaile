//
//  ICEGetCityViewController.h
//  kuaile
//
//  Created by ttouch on 15/11/20.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ICEGetCityBack)(NSString *city);

@interface ICEGetCityViewController : TZBaseViewController

@property (nonatomic, copy) ICEGetCityBack back;

@end
