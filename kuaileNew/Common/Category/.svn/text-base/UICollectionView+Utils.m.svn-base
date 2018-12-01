//
//  UICollectionView+Utils.m
//  yangmingFinance
//
//  Created by ttouch on 2016/11/19.
//  Copyright © 2016年 上海通渔信息科技有限公司. All rights reserved.
//

#import "UICollectionView+Utils.h"

@implementation UICollectionView (Utils)

- (void)registerCellByNibName:(NSString*)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:nibName];
}

- (void)registerCellByClassName:(NSString*)nameClass {
    [self registerClass:NSClassFromString(nameClass) forCellWithReuseIdentifier:nameClass];
}

@end
