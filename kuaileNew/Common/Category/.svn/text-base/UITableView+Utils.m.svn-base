//
//  UITableView+Utils.m
//  yishipi
//
//  Created by ttouch on 16/9/26.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

- (void)registerCellByNibName:(NSString*)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
}

- (void)registerCellByClassName:(NSString*)nameClass{
    [self registerClass:NSClassFromString(nameClass) forCellReuseIdentifier:nameClass];
}

@end
