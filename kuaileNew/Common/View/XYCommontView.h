//
//  XYCommentView.h
//  kuaile
//
//  Created by 肖兰月 on 2017/2/14.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCommontView : UIView

@property (nonatomic, strong) UILabel *frontLabel;
@property (nonatomic, strong) UILabel *backLabel;

@property (nonatomic, copy) NSString *frontText;
@property (nonatomic, copy) NSString *backText;

@property (nonatomic, assign) CGFloat fontSize;


@end
