//
//  OrderCellThree.m
//  muniao
//
//  Created by 赵中良 on 15/1/28.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderCellThree.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件

@interface OrderCellThree ()

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumberLabel;


@end



@implementation OrderCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellOrder:(Order *)cellOrder{
    [_roomImageView setImageWithURL:[NSURL URLWithString:cellOrder.RoomPicUrl]];
    _roomNameLabel.text = cellOrder.roomTitle;
    _inDateLabel.text = cellOrder.start_Date;
    _outDateLabel.text = [NSString stringWithFormat:@"离店时间：%@",cellOrder.end_Date];
    _personNumberLabel.text = [NSString stringWithFormat:@"入住人数：%@",cellOrder.rentNumber];
}


@end
