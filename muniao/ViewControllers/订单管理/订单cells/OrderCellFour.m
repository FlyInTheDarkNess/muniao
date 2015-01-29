//
//  OrderCellFour.m
//  muniao
//
//  Created by 赵中良 on 15/1/28.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderCellFour.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件

@interface OrderCellFour ()

@property (weak, nonatomic) IBOutlet UIImageView *tenantImageView;
@property (weak, nonatomic) IBOutlet UILabel *tenantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RemarksLabel;


@end

@implementation OrderCellFour

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellOrder:(Order *)cellOrder{
    [_tenantImageView setImageWithURL:[NSURL URLWithString:cellOrder.tenantPicUrl]];
    _tenantNameLabel.text = cellOrder.tenantName;
//    _RemarksLabel.text = cellOrder.;
}

@end
