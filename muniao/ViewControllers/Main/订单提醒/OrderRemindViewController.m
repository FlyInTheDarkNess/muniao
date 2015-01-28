//
//  OrderRemindViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/15.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//
#define OrderRemindCellIdentifier_one (@"muniao_OrderRemind_First")
#define OrderRemindCellIdentifier_two (@"muniao_OrderRemind_Second")
#define OrderRemindCellIdentifier_three (@"muniao_OrderRemind_Third")
#import "OrderRemindViewController.h"
#import "MainViewController.h"
#import "Constants.h"//接口文件
#import "Toast+UIView.h"
#import "ASIFormDataRequest.h"
#import "KVNProgress.h"
#import "OrderRemindCellOne.h"
#import "OrderRemindCellTwo.h"
#import "OrderRemindCellThree.h"
#import "Order.h"

@interface OrderRemindViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailDelegate,OrderManageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderRemindTableView;

@end

@implementation OrderRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderRemindTableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Order *order = [[Order alloc]initWithOrderId:@"11" orderNum:@"123" total_Price:@"100" prepay_Price:@"20" start_Date:@"2014-10-5" end_Date:@"2014-12-6" roomTitle:@"万达一号高层海景房" roomTitle2:@"天使一号房" tenantName:@"栋梁" room_Id:@"11234" rentNumber:@"2" sameRoom:@"俩人" rent_Type:@"整租" addDate:@"2014-12-12" canPayDate:@"2013-23-23" source:@"1" RoomPicUrl:nil status:@"1" ruzhu:@"1" refundType:@"协议十一：时间段开房间阿里上看到就发啦看见啥地方离开家阿里的开始爱上看见对方拉会计师对伐啦" moblie:@"18733107902" tenantPicUrl:nil detail_Price:@"120"];
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderRemindCellIdentifier_one];
//            cell.textLabel.text = @"张三";
            OrderRemindCellOne *cellone = (OrderRemindCellOne *)cell;
            cellone.delegate = self;
            cellone.MyOrdrer = order;
            [cellone CellRefresh];
            return cellone;
            
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderRemindCellIdentifier_two];
            OrderRemindCellTwo *celltwo = (OrderRemindCellTwo *)cell;
            celltwo.MyOrdrer = order;
            [celltwo CellRefresh];
            return celltwo;
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:OrderRemindCellIdentifier_three];
            OrderRemindCellThree *cellthree = (OrderRemindCellThree *)cell;
            cellthree.delegate = self;
            cellthree.MyOrdrer = order;
            [cellthree CellRefresh];
            return cellthree;
        }
            break;
            
        default:{
            cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"数据加载出错";
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 30;
            break;
        case 1:
            return 72;
            break;
        case 2:
            return 115;
            break;
        default:
            [[UIApplication sharedApplication].keyWindow makeToast:@"单元格行高加载错误"];
            return 10;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark OrderDetailDelegate

-(void)checkOrderDetail:(Order *)Cellorder{
    NSLog(@"订单提醒：点击订单详情");
}

#pragma mark OrderManageDelegate

-(void)orderManage:(Order *)Cellorder Type:(NSInteger)type{
    switch (type) {
        case 1:
            NSLog(@"订单提醒：点击接受订单");
            break;
        case 2:
            NSLog(@"订单提醒：点击拒绝订单");
            break;
        case 3:
            NSLog(@"订单提醒：点击联系房客");
            break;
            
            
        default:
        {
            NSLog(@"订单提醒：点击错误按钮");
        }
            break;
    }
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
