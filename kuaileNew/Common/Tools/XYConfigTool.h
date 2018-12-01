//
//  XYConfigTool.h
//  yinliaopifa
//
//  Created by 肖兰月 on 2017/1/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYConfigTool : NSObject
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat extraAddWidth;
@property (nonatomic, assign) CGFloat btnFont;
@property (nonatomic, strong) NSArray *configArr;
@property (nonatomic, assign) CGFloat configArrH;
@property (nonatomic, strong) NSArray *genderArr;

@property (nonatomic, assign) CGFloat genderconfigArrH;
@end
