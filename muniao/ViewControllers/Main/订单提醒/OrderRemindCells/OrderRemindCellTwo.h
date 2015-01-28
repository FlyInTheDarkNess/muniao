//
//  OrderRemindCellTwo.h
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderRemindCellTwo : UITableViewCell

@property (nonatomic,strong) Order *MyOrdrer;

-(void)CellRefresh;


@end
