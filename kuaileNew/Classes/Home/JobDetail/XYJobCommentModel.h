//
//  XYJobCommentModel.h
//  kuaile
//
//  Created by 肖兰月 on 2017/5/18.
//  Copyright © 2017年 ttouch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYJobReplyModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uvatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;

@end

//"name": "开心客服",
//"uvatar": "http://120.55.165.117/uploads/logo.png",
//"content": "你说的很有道理",
//"time": 1495089543


@interface XYJobCommentModel : NSObject

@property (nonatomic, copy) NSString *recruit_comment_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uvatar;
@property (nonatomic, copy) NSString *unickname;
@property (nonatomic, copy) NSString *bcid;
@property (nonatomic, copy) NSString *buid;
@property (nonatomic, copy) NSString *bunickname;
@property (nonatomic, copy) NSString *buvatar;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *recruit_id;
@property (nonatomic, copy) NSString *recruit_name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *create_at;
@property (nonatomic, strong) XYJobReplyModel *reply;


@property (nonatomic, assign) CGFloat cellHeight;

@end

//"recruit_comment_id": "12",
//"uid": "19547",
//"uvatar": "http://120.55.165.117/uploads/user_info/83261488361952.png",
//"unickname": "ying5",
//"bcid": "0",
//"buid": "0",
//"bunickname": "",
//"buvatar": "",
//"company_id": "341",
//"company_name": "乐星产电（无锡）有限公司",
//"recruit_id": "42",
//"recruit_name": "仓管",
//"content": "测试",
//"state": "2",
//"create_at": "1494213960"


