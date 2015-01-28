//
//  OrderDetailViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/16.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//
#define OrderDetailViewCellIndentifierOne (@"orderDetailCell_one")
#define OrderDetailViewCellIndentifierTwo (@"orderDetailCell_two")
#define OrderDetailViewCellIndentifierThree (@"orderDetailCell_three")
#define OrderDetailViewCellIndentifierFour (@"orderDetailCell_four")
#define OrderDetailViewCellIndentifierFive (@"orderDetailCell_five")

#import "OrderDetailViewController.h"
#import "OrderDetailCellOne.h"
#import "OrderDetailCellTwo.h"
#import "OrderDetailCellThree.h"
#import "OrderDetailCellFour.h"
#import "OrderDetailCellFive.h"
#import "Order.h"
#import "Constants.h"
#import "Toast+UIView.h"


@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
    
@property (weak, nonatomic) IBOutlet UITableView *orderDetail;


@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderDetail.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Order *order = [[Order alloc]initWithOrderId:@"11" orderNum:@"123" total_Price:@"100" prepay_Price:@"20" start_Date:@"2014-10-5" end_Date:@"2014-12-6" roomTitle:@"万达一号高层海景房" roomTitle2:@"天使一号房" tenantName:@"栋梁" room_Id:@"11234" rentNumber:@"2" sameRoom:@"俩人" rent_Type:@"整租" addDate:@"2014-12-12" canPayDate:@"2013-23-23" source:@"1" RoomPicUrl:nil status:@"1" ruzhu:@"1" refundType:@"协议十一：时间段开房间阿里上看到就发啦看见啥地方离开家阿里的开始爱上看见对方拉会计师对伐啦" moblie:@"18733107902" tenantPicUrl:nil detail_Price:@"120"];
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailViewCellIndentifierOne];
            OrderDetailCellOne *cellone = (OrderDetailCellOne *)cell;
//            cellone.delegate = self;
            cellone.order = order;
            [cellone CellRefresh];
            return cellone;
            
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailViewCellIndentifierTwo];
            OrderDetailCellTwo *celltwo = (OrderDetailCellTwo *)cell;
            celltwo.order = order;
            [celltwo CellRefresh];
            return celltwo;
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailViewCellIndentifierThree];
            OrderDetailCellThree *cellthree = (OrderDetailCellThree *)cell;
            cellthree.order = order;
            [cellthree cellRefresh];
            return cellthree;
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailViewCellIndentifierFour];
            OrderDetailCellFour *cellfour = (OrderDetailCellFour *)cell;
            cellfour.order = order;
            [cellfour cellRefresh];
            return cellfour;
        }
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailViewCellIndentifierFive];
            OrderDetailCellFive *cellfive = (OrderDetailCellFive *)cell;
            //            celltwo.MyOrdrer = order;
            return cellfive;
        }  
        default:{
            cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"数据加载出错";
        }
            break;
    }
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            return 83;
            
        }
            break;
        case 1:
        {
            return 140;
        }
            break;
        case 2:
        {
            return 27;
        }
            break;
        case 3:
        {
            return 83;
        }
        case 4:
        {
            return 49;
        }
        default:{
            return 0;
        }
            break;
    }
    
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
