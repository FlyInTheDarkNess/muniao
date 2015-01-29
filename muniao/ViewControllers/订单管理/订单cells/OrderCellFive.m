//
//  OrderCellFive.m
//  muniao
//
//  Created by 赵中良 on 15/1/28.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderCellFive.h"

@interface OrderCellFive ()

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;


@end

@implementation OrderCellFive

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellOrder:(Order *)cellOrder{
    switch ([cellOrder.status integerValue]) {
        case 1:
            _orderPriceLabel.textColor = [UIColor redColor];
            break;
        case 2:
             _orderPriceLabel.textColor = [UIColor redColor];
            break;
        case 3:
            _orderPriceLabel.textColor = [UIColor redColor];
            break;
        case 4:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
        case 5:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
        case 6:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
        case 7:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
        case 8:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
        case 9:
            _orderPriceLabel.textColor = [UIColor redColor];
            break;
        case 10:
            _orderPriceLabel.textColor = [UIColor redColor];
            break;
        case 100:
            _orderPriceLabel.textColor = [UIColor grayColor];
            break;
            
        default:
            NSLog(@"失败");
            break;
    }

    _orderPriceLabel.text = [NSString stringWithFormat:@"已付定金：￥%@,到店支付：￥%.2f",cellOrder.prepay_Price,[cellOrder.total_Price floatValue] - [cellOrder.prepay_Price floatValue]];
}

@end
