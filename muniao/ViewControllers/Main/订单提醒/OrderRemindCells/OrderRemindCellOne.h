//
//  OrderRemindCellOne.h
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@protocol OrderDetailDelegate <NSObject>

-(void)checkOrderDetail:(Order *)Cellorder;

@end


@interface OrderRemindCellOne : UITableViewCell

@property (nonatomic,strong) Order *MyOrdrer;
@property (nonatomic,weak) id<OrderDetailDelegate>delegate;

-(void)CellRefresh;

@end
