//
//  HWSearchBar.h
//
//  Created by apple on 14-10-8.
//

#import <UIKit/UIKit.h>

@interface HWSearchBar : UITextField
+ (instancetype)searchBar;

/** 设置占位文字 */
@property (nonatomic, strong) NSString *placeholderText;

@end
