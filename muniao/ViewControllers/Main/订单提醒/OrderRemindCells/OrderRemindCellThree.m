//
//  OrderRemindCellThree.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderRemindCellThree.h"

@interface OrderRemindCellThree ()

@property (weak, nonatomic) IBOutlet UIImageView *tenantImageView;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
- (IBAction)orderManage:(id)sender;
@end


@implementation OrderRemindCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)orderManage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [_delegate orderManage:_MyOrdrer Type:btn.tag];
}

-(void)CellRefresh{
    _tenantNameLabel.text = _MyOrdrer.tenantName;
    _fromLabel.text = @"美团网认证客户";
    _secondLabel.text = @"河北 石家庄";
    _remarkLabel.text = @"我要飞得更高，非得更高我要飞得更高，非得更高我要飞得更高，非得更高我要飞得更高，非得更高我要飞得更高，非得更高我要飞得更高，非得更高我要飞得更高，非得更高";
}


@end
