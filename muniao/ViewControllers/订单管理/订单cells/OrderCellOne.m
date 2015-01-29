//
//  OrderCellOne.m
//  muniao
//
//  Created by 赵中良 on 15/1/28.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderCellOne.h"

@interface OrderCellOne ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation OrderCellOne

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellOrder:(Order *)cellOrder{
    NSString *str;
    switch ([cellOrder.status integerValue]) {
        case 1:
            str = [NSString stringWithFormat:@"待确认"];
            self.backgroundColor = [UIColor redColor];
            break;
        case 2:
            str = [NSString stringWithFormat:@"已确认，待付款"];
            self.backgroundColor = [UIColor redColor];
            break;
        case 3:
            str = [NSString stringWithFormat:@"已付款,已入住"];
            self.backgroundColor = [UIColor redColor];
            break;
        case 4:
            str = [NSString stringWithFormat:@"已完成"];
            self.backgroundColor = [UIColor lightGrayColor];
            break;
        case 5:
            str = [NSString stringWithFormat:@"待处理退款"];
            self.backgroundColor = [UIColor grayColor];
            break;
        case 6:
            str = [NSString stringWithFormat:@"已退款"];
            self.backgroundColor = [UIColor grayColor];
            break;
        case 7:
            str = [NSString stringWithFormat:@"已拒绝"];
            self.backgroundColor = [UIColor grayColor];
            break;
        case 8:
            str = [NSString stringWithFormat:@"已过确认时间"];
            self.backgroundColor = [UIColor grayColor];
            break;
        case 9:
            str = [NSString stringWithFormat:@"已付款，可收取定金"];
            self.backgroundColor = [UIColor redColor];
            break;
        case 10:
            str = [NSString stringWithFormat:@"已付款，待入住"];
            self.backgroundColor = [UIColor redColor];
            break;
        case 100:
            str = [NSString stringWithFormat:@"已取消"];
            self.backgroundColor = [UIColor grayColor];
            break;
//        case 11:
//            str = [NSString stringWithFormat:@"待确认"];
//            break;
            
            
        default:
            NSLog(@"失败");
            break;
    }
    _statusLabel.text = str;
}

@end
