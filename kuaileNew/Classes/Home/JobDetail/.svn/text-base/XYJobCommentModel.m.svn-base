//
//  XYJobCommentModel.m
//  kuaile
//
//  Created by 肖兰月 on 2017/5/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import "XYJobCommentModel.h"


@implementation XYJobReplyModel

- (NSString *)time {
//    return [CommonTools getTimeStampBytimeStr:_time dateFormat:@"yyyy-MM-dd HH:mm"];
    return [CommonTools getTimeStrBytimeStamp:_time dateFormat:@"yyyy-MM-dd HH:mm"];

}


@end



@implementation XYJobCommentModel

- (CGFloat)cellHeight {
    XYJobReplyModel *model = _reply;
    CGFloat replyY = [CommonTools sizeOfText:model.content fontSize:13 width:mScreenWidth - 70].height + 50 + 5;
    CGFloat commentY = [CommonTools sizeOfText:_content fontSize:13 width:mScreenWidth - 16].height + 63;
    return (commentY + replyY);
}

- (NSString *)create_at {
    return [CommonTools getTimeStrBytimeStamp:_create_at dateFormat:@"yyyy-MM-dd HH:mm"];
}

@end
