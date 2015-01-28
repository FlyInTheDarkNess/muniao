//
//  OrderDetailCellFour.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderDetailCellFour.h"

@interface OrderDetailCellFour ()

@property (weak, nonatomic) IBOutlet UIImageView *tenantImageView;

@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *renzhengLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;



@end


@implementation OrderDetailCellFour

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellRefresh{
    NSLog(@"订单详情：第四行加载");
}


@end
