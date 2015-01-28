//
//  SetTableViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/20.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "SetTableViewController.h"
#import "Toast+UIView.h"
#import "Constants.h"
@interface SetTableViewController ()<UIActionSheetDelegate>

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        if (indexPath.section == 0) {
            
        }else if(indexPath.section == 1){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 44)];
            label.text = @"退出当前账号";
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"是否进行以下操作"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"注销"
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //    [actionSheet showInView:self.view];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow ];
//        [self.view makeToast:@"点击退出"];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//Actionsheet实现点击方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"点击第一个");
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//            [self JieBangTokenOfAPNS];
            //房东uid存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_UID];
            //房东zend存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_ZEND];
            //房东手机号存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_MOBILE];
            //房东店铺名称存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_OWNERNAME];
            //房东聊天Urnd存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_URND];
            //房东聊天Uzend存储
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UDKEY_UZEND];
            [self dismissViewControllerAnimated:YES completion:nil];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"close" forKey:@"status"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow makeToast:@"已注销"];
            });
        }
            break;
        case 1:
            NSLog(@"点击第二个");
            break;
        case 2:
            NSLog(@"点击第三个");
            break;
        case 3:
            NSLog(@"点击第四个");
            break;
            
        default:
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
