//
//  TZSystemDetailController.h
//  DemoProduct
//
//  Created by 谭真 on 16/1/21.
//  Copyright © 2016年 iCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "XYMessageModel.h"

@interface TZWebViewController : TZBaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;

@property (nonatomic, copy) NSString *shareImageUrlStr;
@property (nonatomic, copy) UIImage *shareImage;
@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, assign) BOOL isMsgHtml;

@property (nonatomic, strong) XYMessageModel *shareModel;

/// 是否需要分享 为YES表明需要分享
@property (nonatomic, assign) BOOL needShare;

- (void)webViewDidFinishLoad;
- (void)initWebViewJavascriptBridge;

@end
