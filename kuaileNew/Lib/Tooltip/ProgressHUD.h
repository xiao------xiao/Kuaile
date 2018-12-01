//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
#define HUD_STATUS_COLOR		[UIColor blackColor]

#define HUD_SPINNER_COLOR		[UIColor blackColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0.0 alpha:0.1]
#define HUD_WINDOW_COLOR		[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]

#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"progresshud-success"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"progresshud-error"]
#define HUD_DELAY 2
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ProgressHUD : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (ProgressHUD *)shared;

/**
 消失
 */
+ (void)dismiss;

/**
 默认加载样式文字为Loading
 */
+ (void)showLoading;

/**
 自定义加载文字

 @param status 文字
 */
+ (void)showLoading:(NSString *)status;

/**
 纯文字提示

 @param status 文字
 */
+ (void)show:(NSString *)status;

/**
 纯文本提示

 @param status      文本
 @param Interaction 是否有交互
 */
+ (void)show:(NSString *)status Interaction:(BOOL)Interaction;
/**
 纯文本成功提示
 
 @param status      文本
 */
+ (void)showSuccess:(NSString *)status;
/**
 纯文本成功提示
 
 @param status      文本
 @param Interaction 是否有交互
 */
+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction;
/**
 纯文本失败提示
 
 @param status      文本
 */
+ (void)showError:(NSString *)status;
/**
 纯文本失败提示
 
 @param status      文本
 @param Interaction 是否有交互
 */
+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction;

@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *background;
@property (nonatomic, retain) UIToolbar *hud;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label;

@end
