//
//  ChatViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "ChatViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Toast+UIView.h"
@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self soundPlay];
    
    _chatTableView.tableFooterView = [[UIView alloc]init];
    _chatTableView.rowHeight = 60;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)soundPlay{
    BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
    BOOL zhendong = [[NSUserDefaults standardUserDefaults] boolForKey:@"zhendong"];
    if (zhendong) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (sound) {
        
        
        //第一步创建一个声音的路径
        NSURL *system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dingdong" ofType:@"wav"]];
        //第二步：申明一个sound id对象
        SystemSoundID system_sound_id;
        //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
        AudioServicesCreateSystemSoundID((__bridge  CFURLRef)system_sound_url, &system_sound_id);
        AudioServicesPlaySystemSound(system_sound_id);
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *path=[paths objectAtIndex:0];
//    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
//    NSString *filename=[path stringByAppendingPathComponent:name];
//    
//    plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
//    NSArray *FriendsListArr = plistDic[@"friendlist"];
//    //遍历好友列表的数组 获取房东的id 添加到数组
//    UserArr = [NSMutableArray array];
//    int min = 0;
//    //                NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
//    for (NSDictionary *dic in FriendsListArr) {
//        //                    NSString *idid = dic[@"id"];
//        NSInteger num = [dic[@"count"] integerValue];
//        min += num;
//        NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
//        [UserArr addObject:dic];
//    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = min;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
//    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0 &&[UIApplication sharedApplication].applicationIconBadgeNumber <100) {
//        item.title = [NSString stringWithFormat:@"消息(%d)",[UIApplication sharedApplication].applicationIconBadgeNumber];
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
//    }
//    else if([UIApplication sharedApplication].applicationIconBadgeNumber >99){
//        item.title = [NSString stringWithFormat:@"消息(99+)"];
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"99+"];
//    }
//    else{
//        item.title = [NSString stringWithFormat:@"返回"];
//        self.navigationController.tabBarItem.badgeValue = nil;
//    }
//    
//    self.navigationItem.backBarButtonItem = item;
//    //    [self ClearNumberOfAPNS:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
//    if (UserArr.count >0) {
//        MyTableView.hidden = NO;
//    }else{
//        MyTableView.hidden = YES;
//    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (UserArr&&UserArr.count >0) {
//        return UserArr.count;
//    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedidentifi = @"muniao";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedidentifi];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedidentifi];
        cell.imageView.image = [UIImage imageNamed:@"demo_touxiang"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 15, 15)];
        image.tag = 2;
        [cell.contentView addSubview:image];
    }
    
//    NSDictionary *dic = UserArr[indexPath.row];
    
    //    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    //    [cell addSubview:image];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = [UIImage imageNamed:@"demo_touxiang"];
//    [imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25;
    
    UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:2];
    //    [imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
//    if ([dic[@"presence"] isEqualToString:@"online"]) {
//        [imageV setImage:[UIImage imageNamed:@"On"]];
//    }
//    else{
        [imageV setImage:[UIImage imageNamed:@"Off"]];
//    }
    //        [cell.imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
    //        cell.imageView.layer.masksToBounds = YES;
    //        cell.imageView.layer.cornerRadius = 15;
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"nick"]];
//    if (dic[@"lastMessage"]) {
//        cell.detailTextLabel.text = dic[@"lastMessage"];
//        
//    }else{
//        cell.detailTextLabel.text = @"";
//    }
    cell.textLabel.text = @"天使的翅膀";
    cell.detailTextLabel.text = @"我想住在面朝大海春暖花开4m宽带能叫外卖的";
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 50, 60)];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 10)];
    labe.textAlignment = NSTextAlignmentCenter;
    
//    if (dic[@"time"]) {
//        NSString *time =  [self returnUploadTime:dic[@"time"]];
//        labe.text = time;
//    }else{
//        labe.text = @"";
//    }
    labe.text = @"今天 16:00";
    labe.font = [UIFont systemFontOfSize:10];
    labe.textColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 30, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 10.0f;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
//    if (dic[@"count"]) {
//        if ([dic[@"count"] integerValue]>99) {
//            label.text = [NSString stringWithFormat:@"99+"];
//        }else{
//            label.text = [NSString stringWithFormat:@"%@",dic[@"count"]];
//        }
//    }
    label.text = @"99+";
    
    [view addSubviews:@[labe,label]];
//    if ([dic[@"count"] integerValue] > 0) {
//        cell.accessoryView = view;
//    }else  if(dic[@"time"]){
//        cell.accessoryView = labe;
//    }else{
//        cell.accessoryView = nil;
//    }
    cell.accessoryView = view;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //    [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    iuiueChatViewController *chat = [[iuiueChatViewController alloc]init];
//    NSDictionary *dic = UserArr[indexPath.row];
//    chat.FriendId = dic[@"id"];
//    friendId = dic[@"id"];
//    chat.FriendImageUrl = dic[@"avatar"];
//    chat.UserImageUrl = UserImageUrl;
//    chat.FriendDic = dic;
//    chat.delegate = self;
//    chat.title = [NSString stringWithFormat:@"%@",dic[@"nick"]];
//    chat.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chat animated:YES];
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
