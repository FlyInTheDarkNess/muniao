//
//  OrderViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderViewController.h"
#import "Toast+UIView.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "KVNProgress.h"
#import "Order.h"
#import "MJRefresh.h"
#import "OrderCellOne.h"
#import "OrderCellTwo.h"
#import "OrderCellThree.h"
#import "OrderCellFour.h"
#import "OrderCellFive.h"
#import "OrderDetailViewController.h"




@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    NSMutableArray *orderArr;//订单列表
    NSInteger pageOfOrder;//当前订单列表页码
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderArr = [NSMutableArray array];
    
    _orderTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _orderTableView.tableFooterView = [[UIView alloc]init];
    
    
    [self setFreshView];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_footer endRefreshing];
    [_header endRefreshing];
    return orderArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    Order *order = (Order *)orderArr[indexPath.section];
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderOne"];
            OrderCellOne *cellOne = (OrderCellOne *)cell;
            cellOne.cellOrder = order;
        }
            
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderTwo"];
            OrderCellTwo *cellOne = (OrderCellTwo *)cell;
            cellOne.cellOrder = order;
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderThree"];
            OrderCellThree *cellOne = (OrderCellThree *)cell;
            cellOne.cellOrder = order;
        }
            
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderFour"];
            OrderCellFour *cellOne = (OrderCellFour *)cell;
            cellOne.cellOrder = order;
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderFive"];
            OrderCellFive *cellOne = (OrderCellFive *)cell;
            cellOne.cellOrder = order;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 30;
        case 1:
            return 30;
        case 2:
            return 90;
        case 3:
            return 70;
        case 4:
            return 30;
            
        default:

            break;
    }

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击订单提醒");
    Order *order = (Order *)orderArr[indexPath.section];
    OrderDetailViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_OrderDetail"];
    next.orderId = order.orderId;
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}



/**********************************************************
 
 函数名称：- (void)getOrderList:(BOOL) UpDown
 
 函数描述：获取订单列表
 
 输入参数：UpDown
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
- (void)getOrderList:(BOOL) UpDown{
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_LIST]];
    
    
    NSString *page = [NSString stringWithFormat:@"%d",pageOfOrder];
    
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:page forKey:@"page"];
    
    request.requestMethod = @"POST";
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        [KVNProgress dismiss];
        if (!error) {
            
            if([resultDict[@"status"]intValue] == 0){
                
                NSArray *arr = resultDict[@"list"];
                
                if (UpDown) {
                    
                }else{
                    [orderArr removeAllObjects];
                }
                
                for (NSDictionary *dic in arr) {
                    NSString *prepay = [NSString stringWithFormat:@"%.2f",[dic[@"amount"] floatValue] + [dic[@"accounts"] floatValue]];
                    NSString *orderid = [NSString stringWithFormat:@"%@",dic[@"orderid"]];
                    NSString *ordernum = [NSString stringWithFormat:@"%@",dic[@"ordernum"]];
                    NSString *total_Price = [NSString stringWithFormat:@"%@",dic[@"total_price"]];
                    NSString *start_Date = [NSString stringWithFormat:@"%@",dic[@"start_date"]];
                    NSString *end_Date = [NSString stringWithFormat:@"%@",dic[@"end_date"]];
                    NSString *roomTitle = [NSString stringWithFormat:@"%@",dic[@"title"]];
                    NSString *roomTitle2 = [NSString stringWithFormat:@"%@",dic[@"title2"]];
                    NSString *tenantName = [NSString stringWithFormat:@"%@",dic[@"username"]];
                    NSString *room_Id = [NSString stringWithFormat:@"无"];
                    NSString *rentNumber = [NSString stringWithFormat:@"%@",dic[@"rentnumber"]];
                    NSString *sameRoom = [NSString stringWithFormat:@"%@",dic[@"sameroom"]];
                    NSString *rent_Type = [NSString stringWithFormat:@"无"];
                    NSString *addDate = [NSString stringWithFormat:@"无"];
                    NSString *canPayDate = [NSString stringWithFormat:@"无"];
                    NSString *source = [NSString stringWithFormat:@"无"];
                    NSString *RoomPicUrl = [NSString stringWithFormat:@"%@",dic[@"picurl"]];
                    NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    NSString *ruzhu = [NSString stringWithFormat:@"无"];
                    NSString *refundType = [NSString stringWithFormat:@"无"];
                    NSString *moblie = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
                    NSString *tenantPicUrl = [NSString stringWithFormat:@"%@",dic[@"headpic"]];
                    
                    Order *order = [[Order alloc]initWithOrderId:orderid orderNum:ordernum total_Price:total_Price prepay_Price:prepay start_Date:start_Date end_Date:end_Date roomTitle:roomTitle roomTitle2:roomTitle2 tenantName:tenantName room_Id:room_Id rentNumber:rentNumber sameRoom:sameRoom rent_Type:rent_Type addDate:addDate canPayDate:canPayDate source:source RoomPicUrl:RoomPicUrl status:status ruzhu:ruzhu refundType:refundType moblie:moblie tenantPicUrl:tenantPicUrl detail_Price:@""];
                    [orderArr addObject:order];
                }
                
                
                
                [_orderTableView reloadData];
                pageOfOrder++;
                
            }else{
                NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                [[UIApplication sharedApplication].keyWindow makeToast:srr];
            }
            
        }else{
            NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
            [[UIApplication sharedApplication].keyWindow makeToast:srr];
        }
    }
     ];
    [request setFailedBlock:^{
        [KVNProgress showErrorWithStatus:@"Error"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    
    [KVNProgress show];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageOfOrder = 1;
    [self getOrderList:NO];
}


#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _orderTableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _orderTableView;
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        
        pageOfOrder = 1;
        [self getOrderList:NO];
        
    } else {
        
        [self getOrderList:YES];
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
