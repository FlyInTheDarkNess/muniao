//
//  OrderRemindCellTwo.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderRemindCellTwo.h"

@interface OrderRemindCellTwo ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *rentNumber;
@property (weak, nonatomic) IBOutlet UILabel *rentRoomNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation OrderRemindCellTwo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellRefresh{
    _rentNumber.text = _MyOrdrer.rentNumber;
    _rentRoomNumberLabel.text = _MyOrdrer.rentNumber;
    _startDateLabel.text = _MyOrdrer.start_Date;
    _endDateLabel.text = _MyOrdrer.end_Date;
}

@end
