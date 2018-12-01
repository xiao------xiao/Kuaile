//
//  ICEPointDescViewController.m
//  kuaile
//
//  Created by ttouch on 15/10/20.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICEPointDescViewController.h"

@interface ICEPointDescViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ICEPointDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分说明";
    _textView.font = [UIFont systemFontOfSize:16 * mScreenWidth / 375.0];
}

@end
