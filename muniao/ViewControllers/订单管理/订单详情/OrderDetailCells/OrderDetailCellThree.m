//
//  OrderDetailCellThree.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderDetailCellThree.h"

@interface OrderDetailCellThree ()

@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;


@end


@implementation OrderDetailCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellRefresh{
    NSLog(@"订单详情：第三行加载");
}

@end
