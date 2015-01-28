//
//  OrderViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "OrderViewController.h"
#import "Toast+UIView.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _orderTableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentity = @"muniao_order_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentity];
    }
//    cell.imageView.image = [UIImage imageNamed:@"demo_touxiang"];
//    cell.textLabel.text = @"高档公寓高层海景蜜月套房";
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.detailTextLabel.text = @"我想住在面朝大海春暖花开4m宽带能叫外卖的房子，最好是有空调的";
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    cell.detailTextLabel.numberOfLines = 0;
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
//    
//    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Order_Cell_Ace"]];
//    [imageV setFrame:CGRectMake(0, 0, 60, 60)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
//    label.text = @"待付款";
//    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    UILabel *labelone = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 20)];
//    labelone.textAlignment = NSTextAlignmentCenter;
//    labelone.text = @"住 12.12";
//    labelone.font = [UIFont systemFontOfSize:10];
//    UILabel *labeltwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
//    labeltwo.text = @"住 12.13";
//    labeltwo.textAlignment = NSTextAlignmentCenter;
//    labeltwo.font = [UIFont systemFontOfSize:10];
//    
//    [imageV addSubview:label];
//    [imageV addSubviews:@[labelone,labeltwo]];
//    cell.accessoryView = imageV;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
