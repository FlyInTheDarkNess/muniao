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
    _roomTitleLabel.text = [NSString stringWithFormat:@"房间标题：%@",_order.roomTitle];
    _roomTitle2Label.text = [NSString stringWithFormat:@"房间别名：%@",_order.roomTitle2];
    _allPayLabel.text = [NSString stringWithFormat:@"应付房款：%@",_order.total_Price];
    _prePayLabel.text = [NSString stringWithFormat:@"预付定金：%@",_order.prepay_Price];
    _lastPayLabel.text = [NSString stringWithFormat:@"到店支付：%.2f",[_order.total_Price floatValue] - [_order.prepay_Price floatValue]];
    _comeDateLabel.text = [NSString stringWithFormat:@"入住时间：%@",_order.start_Date];
    _leaveDateLabel.text = [NSString stringWithFormat:@"离店时间：%@",_order.end_Date];
    _personNumberLabel.text = [NSString stringWithFormat:@"入住人数：%@",_order.rentNumber];
    NSLog(@"订单详情：第二行加载");
}




@end
