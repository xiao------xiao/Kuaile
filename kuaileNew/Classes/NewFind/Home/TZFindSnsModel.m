//
//  TZFindSnsModel.m
//  kuaile
//
//  Created by ttouch on 2016/12/26.
//  Copyright © 2016年 ttouch. All rights reserved.
//

#import "TZFindSnsModel.h"
#import "HWTextPart.h"
#import "RegexKitLite.h"
#import "HWSpecial.h"
#import "HWEmotionTool.h"
#import "NSString+Emoji.h"
#import "HWEmotion.h"
#import "NSAttributedString+Utils.h"
#import "NSDate+Extension.h"
#import "TZMapManager.h"
#import "XYGroupInfoModel.h"

@implementation ICEModelPicture
MJCodingImplementation
@end

@implementation TZFindSnsModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments":[TZSnsCommentModel class],@"hits":[TZSnsHitModel class],@"zan_list":[TZSnsHitModel class]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
   return @{@"comments":[TZSnsCommentModel class],@"hits":[TZSnsHitModel class],@"zan_list":[TZSnsHitModel class]};
}


- (void)setContent:(NSString *)content {
    _shareTitle = content;
    _content = content;
    if (content && content.length) {
        // 利用comments生成attributedComments
        NSAttributedString *attr = [NSAttributedString attributedTextWithText:content textColor:[UIColor blackColor] fontSize:16];
        self.attributedTitle = attr;
        _content = attr;
    }
}

// 计算友好时间
- (void)setUpdated_at:(NSString *)updated_at {
    _friendlyTime = [CommonTools getFriendTimeFromTimeStamp:updated_at];
}

/// 处理点赞数据
//- (void)setIs_hit:(NSString *)is_hit {
//    _is_hit = is_hit;
//    self.is_zan = [is_hit boolValue];
//}

/// 处理图片数据

-(void)setImages:(NSString *)images {
    
    _images = images;
    _imgArr = [NSMutableArray array];
    if ([images isKindOfClass:[NSString class]]) {
        if ([images containsString:@"#"]) {
            NSMutableArray * array = [images componentsSeparatedByString:@"#"];
            for (NSString * imagestr in array) {
                ICEModelPicture * model = [[ICEModelPicture alloc]init];
                model.images = imagestr;
                model.width = (mScreenWidth - 42) / 3;
                model.height = model.width;
                [_imgArr addObject:model];
            }
            _imageViewHeight = (_imgArr.count + 2) / 3 * ((mScreenWidth -42)/3+8);
        }else {
            if ([images isEqualToString:@""]) {
                ICEModelPicture * model = [[ICEModelPicture alloc]init];
                model.images = images;
                model.width = 0;
                model.height = 0;
                [_imgArr addObject:model];
                _imageViewHeight = 2;
            }else {
                ICEModelPicture * model = [[ICEModelPicture alloc]init];
                model.images = images;
                model.width = mScreenWidth -16 -10;
                model.height = model.width;
                [_imgArr addObject:model];
                _imageViewHeight = model.height +8;
            }
        }
    }
   
    // 计算高度
    [self refreshCellHeight];
}
//每个元素包含点赞用户id和小头像地址
-(void)setZan_list:(NSArray *)zan_list {
    
    _zan_list = zan_list;
    
//    NSLog(@"%@",[zan_list[0] uvatar]);
    
//    _hitsUser = [NSMutableArray array];
//    if (zan_list != nil) {
//        for (NSDictionary *imageAUTOR in zan_list) {
//            if ([imageAUTOR isKindOfClass:[TZSnsHitModel class]]) {
//                continue;
//            }
//            TZSnsHitModel * model = [[TZSnsHitModel alloc]init];
//            model.uvatar = imageAUTOR[@"uvatar"];
//            [_hitsUser addObject:model];
//        }
//    }
    // 计算高度
    [self refreshCellHeight];
}

- (void)setHitsUser:(NSMutableArray *)hitsUser {
    _hitsUser = hitsUser;
    [self refreshCellHeight];
}


/// 赋值属性字体，计算高度
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    CGSize contentSize = [self.attributedTitle boundingRectWithSize:CGSizeMake(mScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textHeight = contentSize.height + 9;
    
    // 计算高度
    [self refreshCellHeight];
}

- (void)refreshCellHeight {
    CGFloat hitHeight;
    
    hitHeight = self.zan_list.count ? 40 : 0;
    
//    hitHeight = self.hitsUser.count ? 40 : 0;
    self.totalHeight = _imageViewHeight + 100 + _textHeight + hitHeight;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation TZSnsCommentModel

MJCodingImplementation

- (void)setContent:(NSString *)content {
    _content = content;
    if (!_user) {
        [self createAttributeContent];
    }
}

- (void)setUser:(ICELoginUserModel *)user {
    _user = user;
    if (_content) {
        [self createAttributeContent];
    }
}

- (void)setIs_hit:(NSString *)is_hit {
    _is_hit = is_hit;
    _isHit = [is_hit isEqualToString:@"1"];
}

- (void)setBuser:(ICELoginUserModel *)buser {
    _buser = buser;
    if (_user) {
        [self createAttributeContent];
    }
}

- (void)createAttributeContent {
    NSDictionary *attrbutesMain = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TZMainColor};
    NSDictionary *attrbutesNormal = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableString *allContent = [NSMutableString string];
    NSMutableString *allContentReply = [NSMutableString string];
    [allContentReply appendFormat:@" %@=%@=:",_user.nickname,_user.uid];
    // 在帖子详情页需要的数据
    if (_buser && _buser.nickname) { // 如果是回复别人的
        [allContent appendString:@"回复"];
        [allContent appendFormat:@" %@=%@=:",_buser.nickname,_buser.uid];
        [allContent appendString:@": "];
    }
    [allContent appendString:_content];
    _contentAtr = [NSAttributedString attributedTextWithText:allContent textColor:[UIColor darkGrayColor]];
    _contentLableHeight = [self.contentAtr boundingRectWithSize:CGSizeMake(mScreenWidth - 72, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 20;
    _contentCourseLableHeight = [self.contentAtr boundingRectWithSize:CGSizeMake(mScreenWidth - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 20;
}

- (NSString *)updated_at {
    return [CommonTools getFriendTimeFromTimeStamp:_create_at];
}

@end


@implementation TZSnsHitModel

MJCodingImplementation

-(void)setValue:(id)value forKey:(NSString *)key {
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

//
//@implementation HJSnsGetNearPeople
//
//
//@end


@implementation NearPeople
MJCodingImplementation

@end


@implementation NearGroup
MJCodingImplementation

@end

@implementation getGroupModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"groups": [XYGroupInfoModel class]};
}


@end

@implementation getRecommendGroup


@end
