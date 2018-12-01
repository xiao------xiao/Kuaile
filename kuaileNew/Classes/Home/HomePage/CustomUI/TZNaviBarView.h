//
//  TZNaviBarView.h
//  HappyWork
//
//  Created by liujingyi on 15/9/10.
//  Copyright (c) 2015年 memberwine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZNaviBarView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnCityWidthContraint;
@property (strong, nonatomic) IBOutlet UIView *bgColorView;


@end
