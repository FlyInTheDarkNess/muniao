//
//  OrderRemindCellThree.h
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@protocol OrderManageDelegate <NSObject>

-(void)orderManage:(Order *)Cellorder Type:(NSInteger)type;

@end


@interface OrderRemindCellThree : UITableViewCell

@property (nonatomic,strong) Order *MyOrdrer;
@property (nonatomic,weak) id<OrderManageDelegate>delegate;

-(void)CellRefresh;

@end
