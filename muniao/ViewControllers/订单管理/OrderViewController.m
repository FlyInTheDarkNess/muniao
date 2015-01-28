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


@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *orderArr;//订单列表
}

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderArr = [NSMutableArray array];
    
    _orderTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _orderTableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orderArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderOne"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderTwo"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderThree"];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderFour"];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"muniao_OrderFive"];
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
    UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_OrderDetail"];
    next.hidesBottomBarWhenPushed = YES;
    //    [self presentModalViewController:next animated:NO];
    //    OrderRemindViewController *orderRemind = [[OrderRemindViewController alloc]initWithNibName:@"OrderRemindViewController" bundle:nil];
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
    
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:@"1" forKey:@"page"];
    
    request.requestMethod = @"POST";
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        [KVNProgress dismiss];
        if (!error) {
            
            if([resultDict[@"status"]intValue] == 0){
                
                NSArray *arr = resultDict[@"list"];
                
                for (NSDictionary *dic in arr) {
                    NSString *prepay = [NSString stringWithFormat:@"%.2f",[dic[@"amount"] floatValue] + [dic[@"accounts"] floatValue]];
                    
                    Order *order = [[Order alloc]initWithOrderId:dic[@"orderid"] orderNum:dic[@"ordernum"] total_Price:dic[@"total_price"] prepay_Price:prepay start_Date:dic[@"start_date"] end_Date:dic[@"end_date"] roomTitle:dic[@"title"] roomTitle2:dic[@"title2"] tenantName:dic[@"username"] room_Id:@"无" rentNumber:dic[@"rentnumber"] sameRoom:dic[@"sameroom"] rent_Type:@"" addDate:@"" canPayDate:@"" source:@"" RoomPicUrl:dic[@"picurl"] status:dic[@"status"] ruzhu:@"" refundType:@"" moblie:dic[@"mobile"] tenantPicUrl:dic[@"headpic"] detail_Price:@""];
                    [orderArr addObject:order];
                }
                
                
                
                [_orderTableView reloadData];
                
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
    
    [self getOrderList:YES];
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
