//
//  TZCityPickerView.h
//  DemoProduct
//
//  Created by ttouch on 15/12/10.
//  Copyright © 2015年 iCE. All rights reserved.
//  城市选择器

#import <Foundation/Foundation.h>

@interface TZCityPickerView : UIView

+ (instancetype)shareView;

- (void)show;
- (void)showWithDidSelectAddressBlock:(void (^)(TZCityModel *cityModel1,TZCityModel *cityModel2,TZCityModel *cityModel3,NSString *addressStr))didSelectAddressBlock;

@property (nonatomic, copy) void (^didSelectAddressBlock)(TZCityModel *cityModel1,TZCityModel *cityModel2,TZCityModel *cityModel3,NSString *addressStr);

@end

