//
//  OrderDetailCellTwo.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderDetailCellTwo.h"

@interface OrderDetailCellTwo ()

@property (weak, nonatomic) IBOutlet UILabel *roomTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *roomTitle2Label;

@property (weak, nonatomic) IBOutlet UILabel *allPayLabel;

@property (weak, nonatomic) IBOutlet UILabel *prePayLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastPayLabel;

@property (weak, nonatomic) IBOutlet UILabel *comeDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *leaveDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *personNumberLabel;

@end

@implementation OrderDetailCellTwo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellRefresh{
    NSLog(@"订单详情：第二行加载");
}




@end
