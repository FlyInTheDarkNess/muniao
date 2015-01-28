//
//  Order.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "Order.h"

@implementation Order
//@synthesize orderId,orderNum,total_Price,prepay_Price,detail_Price,start_Date,end_Date,roomTitle,roomTitle2,tenantName,room_Id,rentNumber,sameRoom,rent_Type,addDate,canPayDate,source,RoomPicUrl,status,ruzhu,refundType,moblie,tenantPicUrl;

-(id)initWithOrderId:(NSString *)orderid orderNum:(NSString *)Ordernum total_Price:(NSString *)total_price prepay_Price:(NSString *)prepay_price start_Date:(NSString *)start_date end_Date:(NSString *)end_date roomTitle:(NSString *)roomtitle roomTitle2:(NSString *)roomtitle2 tenantName:(NSString *)tenantName room_Id:(NSString *)room_id rentNumber:(NSString *)rentnumber sameRoom:(NSString *)sameroom rent_Type:(NSString *)rent_type addDate:(NSString *)adddate canPayDate:(NSString *)canpaydate source:(NSString *)source RoomPicUrl:(NSString *)roompicurl status:(NSString *)status ruzhu:(NSString *)ruzhu refundType:(NSString *)refundtype moblie:(NSString *)moblie tenantPicUrl:(NSString *)tenantpicurl detail_Price:(NSString *)detail_price{
    if (self = [super init]) {
        _orderId = orderid;
        _orderNum = Ordernum;
        _total_Price = total_price;
        _prepay_Price = prepay_price;
        _detail_Price = detail_price;
        _start_Date = start_date;
        _end_Date = end_date;
        _roomTitle = roomtitle;
        _roomTitle2 = roomtitle2;
        _tenantName = tenantName;
        _room_Id = room_id;
        _rentNumber = rentnumber;
        _sameRoom = sameroom;
        _rent_Type = rent_type;
        _addDate = adddate;
        _canPayDate = canpaydate;
        _source = source;
        _RoomPicUrl = roompicurl;
        _status = status;
        _ruzhu = ruzhu;
        _refundType = refundtype;
        _moblie = moblie;
        _tenantPicUrl = tenantpicurl;
    }
    return self;
}


@end
