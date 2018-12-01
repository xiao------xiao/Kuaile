//
//  ICESysInfoViewController.m
//  kuaile
//
//  Created by ttouch on 15/11/19.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import "ICESysInfoViewController.h"

@interface ICESysInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ICESysInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息详情";
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
    
    NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
    [contentStyle setLineSpacing:7.0];
    if (self.strSysInfo.length > 40) {
        [contentStyle setFirstLineHeadIndent:34.0];
    }
    NSAttributedString *notiAtrText = [[NSAttributedString alloc] initWithString:self.strSysInfo attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSParagraphStyleAttributeName:contentStyle}];

    self.textView.attributedText = notiAtrText;
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navi_back" highImage:@"navi_back"];
}

- (void)back {
    if (self.navigationController.childViewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
