//
//  interface.h
//
//  Created by 陈冰 on 15/5/7.
//  Copyright (c) 2015年 Glacier. All rights reserved.
//

#ifndef __interface_h
#define __interface_h

// 服务器域名
//正式服务器
//#define ApiSystemDomain @"www.online.com"


//正式环境

//#define ApiSystemDomain @"http://120.55.165.117/index.php/app"
//#define ApiSystemDomainNew   @"http://match.app.letusport.com/api/web/v2/"
//#define ApiSystemImage @"http://120.55.165.117/"


//测试服务器
#define ApiSystemDomain @"http://192.168.3.131/hpjobweb/index.php/app"
#define ApiSystemDomainNew   @"http://192.168.3.131/hpjobweb/app/index/"
#define ApiSystemImage @"http://192.168.3.131/hpjobweb/"


//#define ApiSystemDomain @"http://www.hap-job.com/index.php/app"
//#define ApiSystemDomainNew   @"http://www.hap-job.com/index.php/app"
//#define ApiSystemImage @"http://www.hap-job.com/"



//获取版本信息
#define ApiItunesConnect @"http://itunes.apple.com/lookup?id=1068849473"

// 公共上传图片
#define ApiUploadImage      ApiSystemDomain@"/auth/uploadImg"
// 意见反馈
#define ApiFeedBack         ApiSystemDomain@"/index/advice"

// -------职位------------------------------------------------------------------------------------------
// 得到职位柄
#define ApiGetLinkage       ApiSystemDomain@"/search/getLinkage"
// 职位列表「一般的」
#define ApiRecruit          ApiSystemDomain@"/search/recruit"
// 推送来的推荐职位列表
#define ApiRecruitByIds     ApiSystemDomain@"/index/getRecruitsByIds"
// 职位列表「热门的」
#define ApiHotRecruit       ApiSystemDomain@"/search/hotRecruit"
// 职位/公司详情
#define ApiRecruitInfo      ApiSystemDomain@"/search/recruitInfo"
// 职位评论列表
#define ApiJobCommentList        ApiSystemDomain@"/search/getRecruitComment"
// 评论职位
#define ApiCommentJob        ApiSystemDomain@"/search/commentRecruit"
// 得到收藏职位
#define ApiViewFav          ApiSystemDomain@"/profile/viewFav"
// 公司详情信息 【暂不用】
//#define ApiGetCompanyInfo   ApiSystemDomain@"/company/getCompanyInfo"
// 得到该公司其他职位
#define ApiGetOthers        ApiSystemDomain@"/search/getOthers"
// 投递简历
#define ApiDeliver          ApiSystemDomain@"/profile/deliver"
// 投递记录
#define ApiPostLog          ApiSystemDomain@"/profile/postLog"
// 热门职位分类
#define ApiHot              ApiSystemDomain@"/search/hot"
// 校园招聘
#define ApiSchoolJob        ApiSystemDomain@"/search/schoolJob"
// 兼职工作
#define ApiPartTimeJob      ApiSystemDomain@"/search/partTimeJob"
// 入职返现
#define ApiReturnMoney      ApiSystemDomain@"/search/returnMoney"
// 包吃包住
#define ApiEatJob           ApiSystemDomain@"/search/eatJob"
// 附近工作
#define ApiNearJobs         ApiSystemDomain@"/search/nearJobs"
// 放心企业
#define ApiRelievedCompany  ApiSystemDomain@"/search/relievedCompany"
// 高薪职位
#define ApiHighSalary       ApiSystemDomain@"/search/highSalary"
// 搜索职位
#define ApiSearchIndex      ApiSystemDomain@"/search/index"
// 全部福利列表
#define ApiAllWelfares      ApiSystemDomain@"/search/allWelfares"

// ---------登录------------------------------------------------------------------------------------------
// 登录
#define ApiLogin            ApiSystemDomain@"/auth/login"
// 注册
#define ApiRegister         ApiSystemDomain@"/auth/register"
// 判断是否注册
#define ApiIsRegistered         ApiSystemDomain@"/profileExtend/isRegister"
// 忘记密码
//#define ApiFindPassword     ApiSystemDomain@"/auth/find_password"
#define ApiFindPassword     ApiSystemDomain@"/auth/editPassword"


// 注销登陆
#define ApiLogout           ApiSystemDomain@"/auth/logout"
// 第三方登录
#define ApiAuthLogin        ApiSystemDomain@"/auth/authLogin"
// 检测第三方登录有没有登录过
#define ApiAuthHaveLogin    ApiSystemDomain@"/auth/have_login"
// 添加经纬度
#define ApiUpdateLocation   ApiSystemDomain@"/auth/get_address"
// 发送验证码
#define ApiSms              ApiSystemDomain@"/auth/sms"

// -------简历--------------------------------------------------------------------------------------
// 创建简历
#define ApiCreateNewRes     ApiSystemDomain@"/profile/createNewRes"
// 修改简历
#define ApiUpdateResume     ApiSystemDomain@"/profile/updateResume"
// 简历详情 ［安卓使用了］
#define ApiResumeView       ApiSystemDomain@"/profile/resumeView"
// 简历预览（获取填写的简历数据）
#define ApiPreviewResume    ApiSystemDomain@"/profile/preview"
// 工作经验列表
#define ApiJobExpList       ApiSystemDomain@"/profile/jobExpList"
// 修改工作经验
#define ApiUpdateWorkExp    ApiSystemDomain@"/profile/updateWorkExp"
// 删除工作经验
#define ApiDeleteResumeJob  ApiSystemDomain@"/profile/deleteResumeJob"
// 我的简历（简历列表）
#define ApiResumeList       ApiSystemDomain@"/profile/resume"
// 刷新简历
#define ApiRefreshResume    ApiSystemDomain@"/profile/refreshResume"
// 设为默认简历
#define ApiSetDefaultResu   ApiSystemDomain@"/profile/defaultRes"
// 删除简历
#define ApiDelResume        ApiSystemDomain@"/profile/del"
// 谁看过我
#define ApiLookThrough      ApiSystemDomain@"/profile/lookThrough"
// 三天内自动投递 [暂时未用上]
#define ApiAutoDelivery     ApiSystemDomain@"/profile/auto_delivery"

// -------个人中心------------------------------------------------------------------------------------------
// 修改密码
#define ApiPassword         ApiSystemDomain@"/auth/password"
// 修改个人信息
#define ApiEditPerson       ApiSystemDomain@"/auth/editPerson"
#define ApiEditUser         ApiSystemDomain@"/profileExtend/editUser"

#define ApiGetRecruitQR     ApiSystemDomain@"/profileExtend/getRecruitQR2"

//个人中心上传图片与更换背景
#define ApiUploadPersonImg  ApiSystemDomain@"/profileExtend/uploadImg"
// 用户信息
#define ApiProfileInfo      ApiSystemDomain@"/profileExtend/getUserInfo"
// 获取个人信息
#define ApiGetPerson        ApiSystemDomain@"/auth/getPerson"
// 获取很多人的个人信息
#define ApiGetManyPerson    ApiSystemDomain@"/index/getUserByPhone"
// 绑定手机号
#define ApiBindPhone        ApiSystemDomain@"/auth/binding"
// 解绑手机号
#define ApiUnbindPhone      ApiSystemDomain@"/auth/unbind"
// 签到
#define ApiSign             ApiSystemDomain@"/auth/sign"
// 领取任务奖励
#define ApiReceive             ApiSystemDomain@"/profileExtend/receiveAward"
// 是否签到
#define ApiIsSign           ApiSystemDomain@"/auth/is_sign"
// 签到记录
#define ApiSignRecord       ApiSystemDomain@"/auth/sign_record"
// 求职意向
#define ApiJobInvension     ApiSystemDomain@"/profile/jobInvension"
// 获取用户求职意向
#define ApiUserInvension    ApiSystemDomain@"/profile/user_intension"
// 积分记录
#define ApiPointRecord      ApiSystemDomain@"/auth/point_record"
// 获取用户积分
#define ApiGetPoint         ApiSystemDomain@"/auth/getPoint"
// 积分任务列表
#define ApiPointTaskList     ApiSystemDomain@"/profileExtend/pointMissions"
// 积分明细列表
#define ApiPointDetailList     ApiSystemDomain@"/profileExtend/pointLog"
// APP首页轮播广告
#define ApiAds              ApiSystemDomain@"/auth/ads"
// 是否审核（用户佣金）
#define ApiIdentificationv  ApiSystemDomain@"/auth/identification"
// 认证（用户佣金）
#define ApiApprove          ApiSystemDomain@"/auth/approve"
// 佣金金额
#define ApiUserCommission   ApiSystemDomain@"/auth/user_commission"
// 获取银行信息
#define ApiBankInfo         ApiSystemDomain@"/auth/bank_info"
// 佣金提现
#define ApiWithdraw         ApiSystemDomain@"/auth/withdraw"
// 佣金明细
#define ApiCommissionLog    ApiSystemDomain@"/auth/commission_log"
// 工资查询
#define ApiSalaryQuery      ApiSystemDomain@"/auth/salary_query"
// 系统消息
#define ApiGetMessages      ApiSystemDomain@"/profile/getMessages"
// 删除系统消息
#define ApiDeleteMessage    ApiSystemDomain@"/profile/delMessage"
// 删除投递记录
#define ApiDeleteDeliverLog  ApiSystemDomain@"/profile/delDeliverLogs"
//积分信息
#define ApiDeleteSignInfo    ApiSystemDomain@"/profileExtend/getSignInfo"
//签到页面
#define ApiDeleteSignDate    ApiSystemDomain@"/profileExtend/getSignDate"
//签到
#define ApiDeleteSign        ApiSystemDomain@"/profileExtend/sign"
//关注的人
#define ApiAttentionList     ApiSystemDomain@"/friend/getConcernOrFan"

//人脸验证
#define ApiFaceIcon          ApiSystemDomain@"/auth/uploadForApprove"

//生成订阅
#define ApiSubscribe         ApiSystemDomain@"/profileExtend/jobSubscribe"
//工作面试
#define ApiInterViewMessage        ApiSystemDomain@"/message/getSpecialMessage"

#define ApiDeletefetOtherInfo   ApiSystemDomain@"/profileExtend/getOtherUserInfo"


#define ApiLanchScreen ApiSystemDomain@"/auth/startImg"

// ----- 消息 -----
#define ApiDeletefetAvatar ApiSystemDomain@"/message/getAvatar"

#define ApiDeletefetMessageList ApiSystemDomain@"/message/getMessageList"
// 删除
#define ApiDelMessage ApiSystemDomain@"/message/delMessage"
//-------发现---------------------------------------------------------
// 创建群
#define ApiCreateGroup      ApiSystemDomain@"/profile/createGroup"
// 附近的群
#define ApiNearGroups       ApiSystemDomain@"/profile/nearGroups"
// 附近的人
#define ApiNearPeople       ApiSystemDomain@"/profile/nearPeople"
// 获取群信息
#define ApiGetGroupInfo     ApiSystemDomain@"/profile/getGroupInfo"
// 获得推荐群
#define ApiGetRecommendGroups ApiSystemDomain@"/profile/getRecommendGroups"
// 发布动态
#define ApiReleaseDynamic   ApiSystemDomain@"/profile/releaseDynamic"
// 评论动态
#define ApiCommentSns       ApiSystemDomain@"/profile/commentSns"
// 点赞动态
#define ApiZanSns           ApiSystemDomain@"/profile/zanSns"
// 生活服务
#define ApiLifeService      ApiSystemDomain@"/search/lifeService"
// 删除群
#define ApiDelGroup         ApiSystemDomain@"/profile/delGroup"
// 分享得积分
#define ApiShareIntegral    ApiSystemDomain@"/profile/shareIntegral"
// 加好友得积分
#define ApiAddFriendsIntegral ApiSystemDomain@"/profile/addFriendsIntegral"
// 举报
#define ApiReportSns        ApiSystemDomain@"/profile/reportSns"
// 修改群资料
#define ApiEditGroup        ApiSystemDomain@"/profileExtend/editGroupInfo"
//#define ApiEditGroup        ApiSystemDomain@"/profile/editGroup"


//-------网页---------------------------------------------------------
// 工资列表
#define ApiSalaryList       ApiSystemDomain@"/auth/salaryList/uid/"
// 薪资查询第一步
#define ApiSalaryList1       ApiSystemDomain@"/auth/salary_list1"
// 薪资查询第二步
#define ApiSalaryList2       ApiSystemDomain@"/auth/salary_list2"
// 薪资查询第三步
#define ApiSalaryList3       ApiSystemDomain@"/auth/salary_list3"

// 位置转码获取详细地址
#define ApiAnalysisLocation ApiSystemDomain@"/index/getLocation"
// 分享
#define ApiShare            @"http://www.hap-job.com/app/auth/share/from/" 

#define ApiJobShare          @"http://m.hap-job.com/company-info-Download.html?id="
#define ApiSnsShare          @"http://www.hap-job.com/app/sns/snsShare?sid="

// 广场
#define ApiSns              ApiSystemDomain@"/index/sns/uid/"
#define ApiSnsNew           @"http://www.hap-job.com/app/index/sns"
// 抽奖活动
#define ApiAward            @"http://www.hap-job.com/app/index/award/uid/"
// 限时抢购
#define ApiMoneyGoods       ApiSystemDomain@"/goods/moneyGoods/uid/"
// 积分兑换
#define ApiIntegralGoods    ApiSystemDomain@"/goods/integralGoods/uid/"
// 简历预览
#define ApiViewResume       ApiSystemDomain@"/auth/viewResume/resume_id/%@"
// 获取群组头像
#define ApiTeamAvatar       ApiSystemDomain@"/index/teamAvatar/group/"
// 全职工作
#define ApiClass            ApiSystemImage@"html/class/class.html"
// 获取个人头像
#define ApiUserAvatar       ApiSystemDomain@"/index/userAvatar/username/"
// 得到生活服务城市列表
#define ApiGetCitys         ApiSystemDomain@"/search/getCitys"
// 搜索好友
#define ApiHaveUser         ApiSystemDomain@"/index/haveUser"
// 搜索好友
#define ApiSensitive         ApiSystemDomain@"/profile/getSensitive"
// 获取通讯录好友
#define ApiGetContact        ApiSystemDomain@"/profile/getAddressBook"

// 创建话题
#define ApiSnsCreate              ApiSystemDomainNew@"sns/create"
// 帖子列表
#define ApiSnsList                ApiSystemDomainNew@"sns/list"
// 评论帖子
#define ApiSnsComment             ApiSystemDomainNew@"sns/comment"
// 回复帖子
#define ApiSnsReply               ApiSystemDomainNew@"sns/reply"

// 评论列表
#define ApiSnsCommentList         ApiSystemDomainNew@"sns/comments"
// 帖子详情
#define ApiSnsDetail              ApiSystemDomainNew@"sns/detail"

// 用户的帖子
//#define ApiSnsUserList            ApiSystemDomainNew@"user/sns-list"
#define ApiSnsUserList            ApiSystemDomain@"/sns/getUserSns"




// 屏蔽帖子
#define ApiSnsShieldSns            ApiSystemDomain@"/sns/shieldSns"
// 举报帖子
#define ApiSnsReportSns            ApiSystemDomain@"/sns/reportSns"
// 获取老乡帖子
#define ApiSnsGetSameTown            ApiSystemDomain@"/sns/getSameTownSns"
// 删除帖子
#define ApiSnsDel                 ApiSystemDomain@"/sns/delSns"
// 点赞列表
#define ApiSnsHitsList            ApiSystemDomain@"/sns/getZanList"
// 关注用户或取消关注
#define ApiSnsConcernUser            ApiSystemDomain@"/sns/concernUser"
// 广场图片上传
#define ApiSnsUploadSnsImags            ApiSystemDomain@"/sns/uploadSnsImags"
// 获取评论回复列表
#define ApiSnsGetComment            ApiSystemDomain@"/sns/getComment"
// 点赞帖子或取消点赞
#define ApiSnsZanSns           ApiSystemDomain@"/sns/zanSns"
// 添加评论或回复
#define ApiSnsCommentSns            ApiSystemDomain@"/sns/commentSns"
// 获取帖子
#define ApiSnsGetSns            ApiSystemDomain@"/sns/getSns"
// 发布帖子
#define ApiSnsWriteSns            ApiSystemDomain@"/sns/writeSns"
// 删除评论或回复
#define ApiSnsDelComment           ApiSystemDomain@"/sns/delComment"
// 获取用户的帖子
#define ApiSnsGetUserSns            ApiSystemDomain@"/sns/getUserSns"
//获取附近的人
#define ApiSnsGetNearInfo            ApiSystemDomain@"/sns/getNearInfo"
//获取帖子详情
#define ApiSnsGetDetailSns            ApiSystemDomain@"/sns/getDetailSns"
//获取推荐群
#define ApiSnsGetRecommendGroups            ApiSystemDomain@"/sns/getRecommendGroups"
//获取附近的人(分页)
#define ApiSnsGetNearPeople           ApiSystemDomain@"/sns/getNearPeople"
//获取附近的群(分页)
#define ApiSnsGetNearGroup            ApiSystemDomain@"/sns/getNearGroup"
//创建群组
#define ApiSnsCreateGroup           ApiSystemDomain@"/profileExtend/createGroup"
//上传修改群头像
#define ApiSnsUploadGroupAvatar           ApiSystemDomain@"/profileExtend/uploadGroupAvatar"
//群组信息
#define ApiSnsGroupInfo           ApiSystemDomain@"/profileExtend/groupInfo"
//查看群组全部成员
#define ApiSnsGetGroupAllMembers           ApiSystemDomain@"/profileExtend/getGroupAllMembers"
//批准入群
#define ApiSnsGetjoinGroup          ApiSystemDomain@"/friend/joinGroup"
#define ApiSnsGetRemoveGroup          ApiSystemDomain@"/friend/deleteGroupMember"

//退出群组
#define ApiQuitGroup          ApiSystemDomain@"/friend/quitGroup"

#define ApiGroupsInfo              ApiSystemDomain@"/profileExtend/getMuchGroupsInfo"
// -------职位------------------------------------------------------------------------------------------

//职位列表带搜索
#define ApiSnsRecruitList            ApiSystemDomain@"/recruitExtend/recruitList"
//投递简历
#define ApiSnsDeliver            ApiSystemDomain@"/profile/deliver"
//热门职位分类
#define ApiSnsHot            ApiSystemDomain@"/search/hot"
//收藏职位
#define ApiSnsFavorite           ApiSystemDomain@"/profile/favorite"
//取消职位收藏
#define ApiSnsDelFav          ApiSystemDomain@"/profile/delFav"


// ----------- 朋友 ----------------------------------------------------------------------------

#define ApiAddCompany                      ApiSystemDomain@"/profileExtend/addCompany"
#define ApiSearchCompany                   ApiSystemDomain@"/profileExtend/searchCompany"
#define ApiSearchFriend                    ApiSystemDomain@"/friend/searchFriends"
#define ApiRecommendFriendLists            ApiSystemDomain@"/friend/getCommendFriends"
// 更多好友通知
#define ApiRecommendMoreFriendLists        ApiSystemDomain@"/friend/getMoreNotice"
#define ApiRecommendNewFriendLists         ApiSystemDomain@"/friend/getNewFriends"

#define ApiRecommentColleague              ApiSystemDomain@"/friend/sameCompanyFriends"
#define ApiFriendsFromSamePlace            ApiSystemDomain@"/friend/sameTownFriends"
//获取已有好友
#define ApiGetFriendsList                  ApiSystemDomain@"/friend/getFriends"


// 找同事
#define ApiSearchColleague     @"http://restapi.amap.com/v3/place/text?"



#endif

