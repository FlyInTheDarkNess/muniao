//
//  OrderRemindCellOne.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderRemindCellOne.h"

@implementation OrderRemindCellOne
@synthesize MyOrdrer;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**********************************************************
 
 函数名称：-(void)showView
 
 函数描述：cell加载数据
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)CellRefresh{
    self.textLabel.text = MyOrdrer.roomTitle2;
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [btn setTitle:@"订单详情" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn addTarget:self action:@selector(pressDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = btn;
    
}

-(IBAction)pressDetailBtn:(id)sender{
    NSLog(@"订单详情：点击订单详情");
    [_delegate checkOrderDetail:MyOrdrer];
}


@end
