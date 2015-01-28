//
//  OrderDetailCellFive.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderDetailCellFive.h"


@implementation OrderDetailCellFive

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)orderManage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
            NSLog(@"接受订单");
            break;
            
        case 2:
            NSLog(@"拒绝订单");
            
        default:
            NSLog(@"订单详情:点击错误");
            break;
    }
}




@end
