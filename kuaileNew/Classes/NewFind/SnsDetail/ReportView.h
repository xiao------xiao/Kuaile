//
//  ReportView.h
//  kuaile
//
//  Created by 胡光健 on 2017/3/15.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportView : UIView
@property(nonatomic,strong) NSArray * titleArray;
@property(nonatomic,strong) UIView * View;

@property(nonatomic,strong) NSString * sid;
-(void)removeView;


@end
