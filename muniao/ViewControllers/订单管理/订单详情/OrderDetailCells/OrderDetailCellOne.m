//
//  OrderDetailCellOne.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderDetailCellOne.h"

@interface OrderDetailCellOne ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatuLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@end

@implementation OrderDetailCellOne

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellRefresh{
    _orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",_order.orderNum];
    _orderDownLabel.text = [NSString stringWithFormat:@"下单时间：%@",_order.addDate];
    NSString *str;
    switch ([_order.status integerValue]) {
        case 1:
            str = [NSString stringWithFormat:@"待确认"];
            break;
        case 2:
            str = [NSString stringWithFormat:@"已确认，待付款"];
            break;
        case 3:
            str = [NSString stringWithFormat:@"已付款,已入住"];
            break;
        case 4:
            str = [NSString stringWithFormat:@"已完成"];
            break;
        case 5:
            str = [NSString stringWithFormat:@"待处理退款"];
            break;
        case 6:
            str = [NSString stringWithFormat:@"已退款"];
            break;
        case 7:
            str = [NSString stringWithFormat:@"已拒绝"];
            break;
        case 8:
            str = [NSString stringWithFormat:@"已过确认时间"];
            break;
        case 9:
            str = [NSString stringWithFormat:@"已付款，可收取定金"];
            break;
        case 10:
            str = [NSString stringWithFormat:@"已付款，待入住"];
            break;
        case 11:
            str = [NSString stringWithFormat:@"未付款，已过期"];
            break;
        case 100:
            str = [NSString stringWithFormat:@"已取消"];
            break;
            
            
        default:
            NSLog(@"失败");
            break;
    }

    _orderStatuLabel.text = [NSString stringWithFormat:@"订单状态：%@",str];
    _orderTypeLabel.text = @"下单方式：木鸟官方网站";
    NSLog(@"订单详情：第一行加载");
}


@end
