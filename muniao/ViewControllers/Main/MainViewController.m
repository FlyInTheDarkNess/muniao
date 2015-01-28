//
//  MainViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//
#define MJCollectionViewCellIdentifier (@"muniao_main_cell")
#import "MainViewController.h"
#import "Constants.h"//接口文件
#import "Toast+UIView.h"
#import "ASIFormDataRequest.h"
#import "KVNProgress.h"
#import "OrderRemindViewController.h"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((MY_WIDTH - 20)/4-1,(MY_WIDTH - 20)/4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    UICollectionView *Collection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, _orderButton.bottom + 15 -44, MY_WIDTH - 20, (MY_WIDTH - 20)/4 * 3) collectionViewLayout:layout];
    Collection.layer.cornerRadius = 5.0f;
    Collection.bounces = NO;
    Collection.scrollEnabled = NO;
    Collection.delegate = self;
    Collection.dataSource = self;
    
    Collection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    Collection.alwaysBounceVertical = YES;
    [Collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
    [self.view addSubview:Collection];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (MY_WIDTH - 20)/4 -1, (MY_WIDTH - 20)/4)];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"Btn_BackGround_White"] forState:UIControlStateNormal];
   
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(((MY_WIDTH - 20)/4 - 30)/2, ((MY_WIDTH - 20)/4 - 30)/2 - 10, 30, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageV.bottom + 5, (MY_WIDTH - 20)/4, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:12];
    [cell addSubview:btn];
    [btn addSubviews:@[label,imageV]];
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            label.text = @"抢生意";
            imageV.image = [UIImage imageNamed:@"Main_Btn_BegForRent"];
            break;
        case 1:
            label.text = @"修改房态";
            imageV.image = [UIImage imageNamed:@"Main_Btn_ChangeStatus"];
            break;
        case 2:
            label.text = @"修改房价";
            imageV.image = [UIImage imageNamed:@"Main_Btn_ChangePrice"];
            break;
        case 3:
            label.text = @"增加销量";
            imageV.image = [UIImage imageNamed:@"Main_Btn_AddOrder"];
            break;
        case 4:
            label.text = @"我的评价";
            imageV.image = [UIImage imageNamed:@"Main_Btn_ReRaise"];
            break;
        case 5:
            label.text = @"收益管理";
            imageV.image = [UIImage imageNamed:@"Main_Btn_Earnings"];
            break;
        case 6:
            label.text = @"房源分析";
            imageV.image = [UIImage imageNamed:@"Main_Btn_RoomCount"];
            break;
        case 7:
            label.text = @"待客之道";
            imageV.image = [UIImage imageNamed:@"Main_Btn_Daike"];
            break;
        case 8:
            label.text = @"收款方式";
            imageV.image = [UIImage imageNamed:@"Main_Btn_WayForCash"];
            break;
        case 9:
            label.text = @"问题反馈";
            imageV.image = [UIImage imageNamed:@"Main_Btn_FeedBack"];
            break;
        case 10:
            label.text = @"客服电话";
            imageV.image = [UIImage imageNamed:@"Main_Btn_SPhone"];
            break;
        case 11:
            label.text = @"分享软件";
            imageV.image = [UIImage imageNamed:@"Main_Btn_Share"];
            break;

            
        default:
            break;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)orderRemind:(id)sender {
    NSLog(@"点击订单提醒");
    UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"OrderRemind"];
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
    
}

- (IBAction)messageRemind:(id)sender {
    NSLog(@"点击通知提醒");
    UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_MessageRemind"];
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
}


-(IBAction)clickMainBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 1:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 2:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 3:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 4:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 5:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 6:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 7:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 8:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 9:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 10:
        {
            NSString *phoneNum = @"400-056-0055";// 电话号码
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            if ( !phoneCallWebView ) {
                phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来
            }
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        }
            break;
        case 11:
        {
            UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"muniao_BegForRent"];
            next.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}
















@end
