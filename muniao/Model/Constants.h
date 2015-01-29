//
//  Constants.h
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#ifndef muniao_Constants_h
#define muniao_Constants_h

//登陆接口
#define URL_LOGIN @"http://appapi.muniao.com/server/app_user/api.do?op=login"

//app统计接口
#define URL_APP_LOG @"http://appapi.muniao.com/server/app_user/api.do?op=applog"

//意见反馈接口
#define URL_FEED_BACK @"http://appapi.muniao.com/server/iuiue/infoapp/feedbackios_json.asp"

//检测版本更新接口
#define URL_CHECK_UPDATE @"http://appapi.muniao.com/server/app_user/api.do?op=checkupdateios"

//短信验证码接口
#define URL_VAIL_DATE @"http://appapi.muniao.com/server/app_user/api.do?op=vaildatecode"

//找回密码接口
#define URL_FORGET_PASSWORD @"http://appapi.muniao.com/server/app_user/api.do?op=forgetpwd"

//房东租币接口
#define URL_MY_ACCOUNTS @"http://appapi.muniao.com/server/app_user/api.do?op=accounts"

//申请提现接口
#define URL_FOR_CASH @"http://appapi.muniao.com/server/app_user/api.do?op=cash"

//订单列表(新)
#define URL_ORDER_LIST @"http://appapi.muniao.com/server/app_user/apiv2.do?op=orderlist"

//订单详情
#define URL_ORDER_DETAIL @"http://appapi.muniao.com/server/app_user/apiv2.do?op=orderinfo"

//订单收取定金
#define URL_GET_HIRE @"http://appapi.muniao.com/server/app_user/api.do?op=hire"

//确认订单
#define URL_ORDER_CAN_PAY @"http://appapi.muniao.com/server/app_user/api.do?op=ordercanpay"

//设置收款方式
#define URL_SAVE_CHARGE @"http://appapi.muniao.com/server/app_user/api.do?op=savecharge"

//房间列表
#define URL_MY_ROOMS @"http://appapi.muniao.com/server/app_user/api.do?op=myrooms"

//房间列表、、简化
#define URL_MY_ROOMS_MIN @"http://appapi.muniao.com/server/app_user/api.do?op=myrooms_min"

//四个月排期
#define URL_PAIQI @"http://appapi.muniao.com/server/app_user/api.do?op=calendars"

//排期修改接口
#define URL_CHANGE_PAIQI @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendars"

//评价列表接口
#define URL_APP_RAISE @"http://appapi.muniao.com/server/app_user/api.do?op=appraise"

//评价回评接口
#define URL_RE_APPRAISE @"http://appapi.muniao.com/server/app_user/api.do?op=reappraise"

//订单数量接口
#define URL_NEW_ORDER @"http://appapi.muniao.com/server/app_user/api.do?op=neworder"

//我的收益接口
#define URL_ORDER_STATISTICS @"http://appapi.muniao.com/server/app_user/api.do?op=orderstatistics"

//批量关房
#define URL_ROOM_CLOSE @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendars_closetoday"

//租币明细
#define URL_MY_ACCOUNTS_DETAIL @"http://appapi.muniao.com/server/app_user/api.do?op=accountdetail"

//提现记录
#define URL_MY_GETCASH_DETAIL @"http://appapi.muniao.com/server/app_user/api.do?op=cashlogs"


/*
// 订单详情接口
#define URL_Message_DETAIL @"http://appapi.muniao.com/server/app_user/api.do?op=orderinfo"

*/
//UDID钥匙串名称
#define KEYCHAIN_UDID @"com.company.muniao.udid"

//uid存储名称
#define UDKEY_UID @"com.company.muniao.uid"

//手机号存储名称
#define UDKEY_MOBILE @"com.company.muniao.mobile"

//密码存储名称
#define UDKEY_PASSWORD @"com.company.muniao.password"

//zend存储名称
#define UDKEY_ZEND @"com.company.muniao.zend"

//房东店铺名称
#define UDKEY_OWNERNAME @"com.company.muniao.name"

//房东聊天UUid
#define UDKEY_URND @"com.company.muniao.urnd"

//房东聊天Uzend
#define UDKEY_UZEND @"com.company.muniao.uzend"

//推送Device Token
#define UDKEY_DEVICE_TOKEN @"com.company.muniao.token"

//获取房东聊天UUid
#define MY_UUID ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_URND])

//获取房东聊天Uzend
#define MY_UZEND ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_UZEND])

//获取房东手机号
#define MY_MOBILE ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_MOBILE])

//获取房东手机号
#define MY_PASSWORD ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_PASSWORD])

//获取房东聊天Device Token
#define MY_TOKEN ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_DEVICE_TOKEN])

//获取uid
#define MY_UID ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_UID])

//获取zend
#define MY_ZEND ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_ZEND])

//获取房东店铺名称
#define MY_OWNERNAME ((NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:UDKEY_OWNERNAME])

//获取当前网络状态
#define MY_ISCONNECT ((BOOL *)[[NSUserDefaults standardUserDefaults] boolForKey:UserDefaults_IsConnect])



//通知名称：改变websocket当前状态
#define NO_WebSocketStatusChange @"WebSocketStatusChange"

//通知名称：聊天界面增加新消息
#define NO_ChatChangeMessages @"ChatChangeMessages"

//通知名称：刷新聊天页面
#define NO_CHatViewRefresh @"ChatViewControllerRefresh"

//通知名称；绑定token
#define NO_APNS_BD @"ChatOrderAPNS_bangding"

//通知名称：解除绑定token
#define NO_APNS_JB @"ChatOrderAPNS_jiebang"

#define APNS_SHUA @"MainViewRefresh"

//排期房态修改接口（新）
#define URL_ROOM_STATUS_CHANGE @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendar_sameroom"

//排期价格修改接口（新）
#define URL_ROOM_PRICE_CHANGE @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendar_price"

//我的收款方式接口
#define URL_MY_WAY_FORCASH @"http://appapi.muniao.com/server/app_user/api.do?op=mycharge"

//我的收益接口
#define URL_MY_EAENINGS @"http://appapi.muniao.com/server/app_user/api.do?op=orderstatistics"

//求租列表接口
#define URL_QIUZU @"http://appapi.muniao.com/server/app_user/api.do?op=qiuzu"

//求租回复接口
#define URL_REQIUZU @"http://appapi.muniao.com/server/app_user/api.do?op=reqiuzu"

//求租的所有回复
#define URL_REQIUZU_LIST @"http://appapi.muniao.com/server/app_user/api.do?op=reqiuzulist"

//星期价格修改
#define URL_PRICEBYWEEK @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendar_pricebyweek"

//置顶价格接口
#define URL_TOTOP_PRICE @"http://appapi.muniao.com/server/app_user/api.do?op=totop_price"

//提交置顶接口
#define URL_POST_TOTOP @"http://appapi.muniao.com/server/app_user/api.do?op=totop"

//网页版支付宝
#define URL_PAY_ZFB_WEB @"http://appapi.muniao.com/server/app_user/api.do?op=totop_alipay"

//网页版财付通
#define URL_PAY_CFT_WEB @"http://appapi.muniao.com/server/app_user/api.do?op=totop_tenpay"

//获取代签名
#define URL_DAIQIAN_STRING @"http://user2.muniao.com/pay/alipay_rsa/securitypay.php"

//appStore获取数据
#define URL_APPSTORE_VERSION @"http://itunes.apple.com/lookup?id=886106183"

//更新接口
#define URL_UPDATE @"https://itunes.apple.com/us/app/mu-niao-duan-zu-fang-dong/id886106183?l=zh&ls=1&mt=8"

//刷新房源排名接口
#define URL_REFRESH_ROOM @"http://appapi.muniao.com/server/app_user/api.do?op=refresh"

//修改星期价格接口
#define URL_WEEK_PRICE_CHANGE @"http://appapi.muniao.com/server/app_user/api.do?op=editcalendar_pricebyweek"

//新版登陆接口
#define URL_NEW_LOGIN @"http://appapi.muniao.com/server/app_user/api.do?op=login_webim"

//websocket聊天online接口
#define URL_WEBSOCKET_ONLINE @"http://webim.muniao.com:8080/webim2/app.do?action=online"

//推送消息数量传送，及绑定手机token
#define URL_BANGDING_TOKEN @"http://webim.muniao.com:8080/webim2/app.do?action=bind_devicetoken"

//APNS 推送解除绑定token
#define URL_JIEBANG_TOKEN @"http://webim.muniao.com:8080/webim2/app.do?action=unbind_devicetoken"

//WebSocket聊天历史记录
#define URL_WEBSOCKET_HISTORY @"http://webim.muniao.com:8080/webim2/app.do?action=history"

//删除与某一人的聊天记录
#define URL_WEBSOCKET_HISTORY_DELETE @"http://webim.muniao.com:8080/webim2/app.do?action=clear_history"

//订单通知列表
#define URL_ORDER_TONGZHI @"http://webim.muniao.com:8080/webim2/app.do?action=pushs"

//订单已读(删除)
#define URL_ORDER_READ @"http://webim.muniao.com:8080/webim2/app.do?action=readpushs"







//属性列表：

//判断是否启动过
#define UserDefaults_EverLaunch @"muniao.everLaunch"

//声音设置
#define UserDefaults_Sound @"muniao.sound"

//震动设置
#define UserDefaults_Shake @"muniao.shake"

//是否连接网络
#define UserDefaults_IsConnect @"muniao.isconnect"



//判断是否高于ios8的版本
#define ios8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0?YES:NO)

//判断是否高于ios7的版本
#define ios7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?YES:NO)

//判断是否为手机（pad）
#define iphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone?YES:NO)

#define MY_SCREEN ([UIScreen mainScreen].bounds)

#define MY_WIDTH (MY_SCREEN.size.width)

#define MY_HEIGHT (MY_SCREEN.size.height)

#endif
