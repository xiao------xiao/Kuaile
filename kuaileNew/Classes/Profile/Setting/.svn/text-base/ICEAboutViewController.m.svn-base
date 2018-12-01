//
//  ICEAboutViewController.m
//  kuaile
//
//  Created by ttouch on 15/9/22.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "ICEAboutViewController.h"
#import "ICEProvisionViewController.h"

@interface ICEAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labVersion;

@end

@implementation ICEAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.labVersion.text = [NSString stringWithFormat:@"版本号 v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (IBAction)actionPromess:(id)sender {
    ICEProvisionViewController *iceprovision = [[ICEProvisionViewController alloc] init];
    [self.navigationController pushViewController:iceprovision animated:YES];
}

- (IBAction)actionClause:(id)sender {
    [self pushWebVcWithFilename:@"im.html" title:@"使用条款和隐私政策"];
}

@end
