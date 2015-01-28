//
//  Order.h
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
/* 订单ID类型Int*/
@property(nonatomic,strong) NSString *orderId;//订单ID类型Int
@property(nonatomic,strong) NSString *orderNum;//订单编号 string
@property(nonatomic,strong) NSString *total_Price;//总价float,
@property(nonatomic,strong) NSString *prepay_Price;//订金float,//到店支付为 total_price-prepay_price  相等时到店支付为0
@property(nonatomic,strong) NSString *detail_Price;//预留的
@property(nonatomic,strong) NSString *start_Date;//入住日期
@property(nonatomic,strong) NSString *end_Date;//离店日期
@property(nonatomic,strong) NSString *roomTitle;//金马_经济学院 邮专 双人房 短期出租",//房间标题
@property(nonatomic,strong) NSString *roomTitle2;//房间别名
@property(nonatomic,strong) NSString *tenantName;//房客昵称
@property(nonatomic,strong) NSString *room_Id;//房源ID
@property(nonatomic,strong) NSString *rentNumber;//入住人数
@property(nonatomic,strong) NSString *sameRoom;//预订数量
@property(nonatomic,strong) NSString *rent_Type;///整组 单间 床位
@property(nonatomic,strong) NSString *addDate;//订单提交时间（用于判断确认超时）
@property(nonatomic,strong) NSString *canPayDate;//房东确认时间（用于判断付款超时）
@property(nonatomic,strong) NSString *source;//订单来源 可不使用
@property(nonatomic,strong) NSString *RoomPicUrl;//房间图片 大小207X155
@property(nonatomic,strong) NSString *status;//订单状态
@property(nonatomic,strong) NSString *ruzhu;//待入住
@property(nonatomic,strong) NSString *refundType;//租房协议
@property(nonatomic,strong) NSString *moblie;//房客手机号
@property(nonatomic,strong) NSString *tenantPicUrl;//房客手机号

-(id)initWithOrderId:(NSString *)orderid
            orderNum:(NSString *)Ordernum
         total_Price:(NSString *)total_price
        prepay_Price:(NSString *)prepay_price
          start_Date:(NSString *)start_date
            end_Date:(NSString *)end_date
           roomTitle:(NSString *)roomtitle
          roomTitle2:(NSString *)roomtitle2
          tenantName:(NSString *)tenantName
             room_Id:(NSString *)room_id
          rentNumber:(NSString *)rentnumber
            sameRoom:(NSString *)sameroom
           rent_Type:(NSString *)rent_type
             addDate:(NSString *)adddate
          canPayDate:(NSString *)canpaydate
              source:(NSString *)source
          RoomPicUrl:(NSString *)roompicurl
              status:(NSString *)status
               ruzhu:(NSString *)ruzhu
          refundType:(NSString *)refundtype
              moblie:(NSString *)moblie
        tenantPicUrl:(NSString *)tenantpicurl
        detail_Price:(NSString *)detail_price;






@end
