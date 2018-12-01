//
//  ICECommentViewController.h
//  kuaile
//
//  Created by ttouch on 15/10/27.
//  Copyright © 2015年 ttouch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICECommentStyle) {
    ICECommentStyleComment,          // regular table view
    ICECommentStyleReback         // preferences style table view
};
typedef void(^ReturnICEComment)(NSString *);

@interface ICECommentViewController : TZBaseViewController

@property (nonatomic, copy) NSString *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) ReturnICEComment returnBlock;
@property (nonatomic, assign) ICECommentStyle commentStyle;
@property (nonatomic, copy) NSString *nickName;
@end
