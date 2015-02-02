//
//  iuiueChatListViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/2.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueChatListViewController.h"
#import <UIKit/UIKit.h>
#import "iuiueChatViewController.h"
#import "SRWebSocket.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"
#import "Toast+UIView.h"
#import "ASIFormDataRequest.h"


@interface iuiueChatListViewController ()<UITableViewDataSource,UITableViewDelegate,MessageChange,SRWebSocketDelegate>{
    
    UITableView *MyTableView;//聊天列表
    NSMutableArray *UserArr;//聊天用户列表
//    NSMutableDictionary *ChatDic;//聊天列表
    SRWebSocket *webscoket;//聊天的webscoket
    NSMutableArray *NewsList;
    NSMutableDictionary *ChatListDic;
    
    NSMutableDictionary *plistDic;//内存plist获取
    
    NSString *UserImageUrl;
    NSString *UserName;//我的昵称
    
    NSString *friendId;
//    NSString *FriendImageUrl;
//    UIActivityIndicatorView *Acti;//菊花
    
    //打开聊天参数
    NSString *ChatId;
    NSString *ChatZend;
    NSString *ChatType;
    NSString *ChatRnd;
    
}

@end
/**
 *  初始化
 */
@implementation iuiueChatListViewController


-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NO_WebSocketStatusChange object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, MY_HEIGHT/2 - 50, MY_WIDTH, 50)];
    label.font = [UIFont fontWithName:@"Helvetica" size:25];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"当前没有好友消息";
    [self.view addSubview:label];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = [NSString stringWithFormat:@"返回"];
    self.navigationItem.backBarButtonItem = item;
    
//    //设置push到下个页面时隐藏tabbar
//    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"好友列表";
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 64-44)];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    MyTableView.rowHeight = 60;
    MyTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:MyTableView];
//    Acti = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    Acti.tintColor = [UIColor redColor];
//    Acti.center = CGPointMake(30, 30);
//    [self.navigationController.navigationBar addSubview:Acti];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
    NSString *filename=[path stringByAppendingPathComponent:name];
    
    plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSArray *FriendsListArr = plistDic[@"friendlist"];
    //遍历好友列表的数组 获取房东的id 添加到数组
    UserArr = [NSMutableArray array];
   int min = 0;
    //                NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
    for (NSDictionary *dic in FriendsListArr) {
        //                    NSString *idid = dic[@"id"];
        NSInteger num = [dic[@"count"] integerValue];
        min += num;
        NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
        [UserArr addObject:dic];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = min;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0 &&[UIApplication sharedApplication].applicationIconBadgeNumber <100) {
        item.title = [NSString stringWithFormat:@"消息(%d)",[UIApplication sharedApplication].applicationIconBadgeNumber];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
    else if([UIApplication sharedApplication].applicationIconBadgeNumber >99){
        item.title = [NSString stringWithFormat:@"消息(99+)"];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"99+"];
    }
    else{
        item.title = [NSString stringWithFormat:@"返回"];
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    self.navigationItem.backBarButtonItem = item;
    //    [self ClearNumberOfAPNS:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
    if (UserArr.count >0) {
        MyTableView.hidden = NO;
    }else{
        MyTableView.hidden = YES;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (UserArr&&UserArr.count >0) {
        return UserArr.count;
    }
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedidentifi = @"muniao";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedidentifi];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedidentifi];
        cell.imageView.image = [UIImage imageNamed:@"touxiang"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 15, 15)];
        image.tag = 2;
        [cell.contentView addSubview:image];
     }
    
    NSDictionary *dic = UserArr[indexPath.row];
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
//    [cell addSubview:image];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    [imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25;
    
    UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:2];
//    [imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
    if ([dic[@"presence"] isEqualToString:@"online"]) {
        [imageV setImage:[UIImage imageNamed:@"On"]];
    }
    else{
        [imageV setImage:[UIImage imageNamed:@"Off"]];
    }
//        [cell.imageView setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
//        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.layer.cornerRadius = 15;

    cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"nick"]];
    if (dic[@"lastMessage"]) {
        cell.detailTextLabel.text = dic[@"lastMessage"];
        
    }else{
        cell.detailTextLabel.text = @"";
    }
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 50, 50)];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 10)];
    labe.textAlignment = NSTextAlignmentCenter;
    
    if (dic[@"time"]) {
       NSString *time =  [self returnUploadTime:dic[@"time"]];
        labe.text = time;
    }else{
        labe.text = @"";
    }
    labe.font = [UIFont systemFontOfSize:10];
    labe.textColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 30, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 10.0f;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    if (dic[@"count"]) {
        if ([dic[@"count"] integerValue]>99) {
            label.text = [NSString stringWithFormat:@"99+"];
        }else{
            label.text = [NSString stringWithFormat:@"%@",dic[@"count"]];
        }
        
    }

    [view addSubviews:@[labe,label]];
    if ([dic[@"count"] integerValue] > 0) {
        cell.accessoryView = view;
    }else  if(dic[@"time"]){
        cell.accessoryView = labe;
    }else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle == UITableViewCellEditingStyleDelete){
//        [self DeleteSomeOne:indexPath];
//    }
//}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    iuiueChatViewController *chat = [[iuiueChatViewController alloc]init];
    NSDictionary *dic = UserArr[indexPath.row];
    chat.FriendId = dic[@"id"];
    friendId = dic[@"id"];
    chat.FriendImageUrl = dic[@"avatar"];
    chat.UserImageUrl = UserImageUrl;
    chat.FriendDic = dic;
    chat.delegate = self;
    chat.title = [NSString stringWithFormat:@"%@",dic[@"nick"]];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}


- (void)_reconnect;
{
    webscoket.delegate = nil;
    [webscoket close];
    
    webscoket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://webim.muniao.com:7272"]]];
    webscoket.delegate = self;
    
    self.navigationItem.title = @"接收中";
    [webscoket open];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    friendId = @"";
    [self ChatOnline];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)reconnect:(id)sender;
{
    [self _reconnect];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    webscoket.delegate = nil;
//    [webscoket close];
//    webscoket = nil;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.navigationItem.title = @"好友列表";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ChatId,@"Customer_uid",ChatType,@"Customer_type",ChatRnd,@"Customer_rnd",ChatZend,@"Customer_zend",@"login",@"type", nil];
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSString *stringl = [self dictionaryToJson:dic];
        [webscoket send:stringl];
        NSLog(@"%@",stringl);
        _isConnet = YES;
    }else{
        [self.view makeToast:@"聊天登陆信息格式转换错误"];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.navigationItem.title = @"连接失败";
    [[UIApplication sharedApplication].keyWindow makeToast:@"连接网络错误，请检查网络设置" duration:1 position:@"center"];
    
    webscoket = nil;
    _isConnet = NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    NSError *err;
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if ([dic[@"type"] isEqualToString:@"ping"]) {
        [webscoket send:@"{\"type\":\"pong\"}"];
        [MyTableView reloadData];
    }else if([dic[@"type"] isEqualToString:@"messages"]){
        //声音和震动
        
        [self SoundAndZhendong];
        
        //未处理发送房间问题
        NSArray *messages = dic[@"messages"];
        NSDictionary *mess = messages[0];
        NSString *fromId = [NSString stringWithFormat:@"%@",mess[@"from"]];
        if ([fromId isEqualToString:friendId]) {
            //            [chat AddOneMessage:mess];
            [[NSNotificationCenter defaultCenter] postNotificationName:NO_ChatChangeMessages object:nil userInfo:mess];
            
        }else{
            [self SaveOtherMessage:mess];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
            if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
                item.title = [NSString stringWithFormat:@"消息(%d)",[UIApplication sharedApplication].applicationIconBadgeNumber];
            }else{
                item.title = [NSString stringWithFormat:@"返回"];
            }
            
            self.navigationItem.backBarButtonItem = item;
        }
        
    }
    
    _isConnet = YES;

//    [MyTableView scrollRectToVisible:CGRectMake(0, 100, 100, 100) animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.navigationItem.title = @"连接关闭";
//    [[UIApplication sharedApplication].keyWindow makeToast:@"连接网络失败，请检查网络设置" duration:1 position:@"center"];
    webscoket = nil;
    _isConnet = NO;
}

//调用online接口
-(void)ChatOnline{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_WEBSOCKET_ONLINE]];
//    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
//    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    [request addPostValue:@"online" forKey:@"action"];
    [request addPostValue:@"available" forKey:@"show"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue]) {
                if (self.navigationController.viewControllers.count==2) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:NO_CHatViewRefresh object:nil];
                }
                //1. 创建一个plist文件
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths objectAtIndex:0];
                NSLog(@"path = %@",path);
                NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
                NSString *filename=[path stringByAppendingPathComponent:name];
                
                plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
                //获取好友列表
                if (!plistDic) {
                    NSFileManager* fm = [NSFileManager defaultManager];
                    [fm createFileAtPath:filename contents:nil attributes:nil];
                    NSMutableArray *friendList = [NSMutableArray arrayWithArray:resultDict[@"buddies"]];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:resultDict[@"user"] forKey:@"user"];
                    
                    
                    for (int num = 0; num < friendList.count; num++) {
                        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendList[num]];
                        for (NSDictionary *newDic in resultDict[@"new_messages"]){
                            if ([newDic[@"from"]isEqualToString:friendDic[@"id"]]) {
                                [friendDic setObject:newDic[@"body"] forKey:@"lastMessage"];
                                [friendDic setObject:newDic[@"timestamp"] forKey:@"time"];
                                if (!friendDic[@"count"]) {
                                    [friendDic setObject:@"1" forKey:@"count"];
                                }else{
                                    NSString *count = [NSString stringWithFormat:@"%d",[friendDic[@"count"] integerValue]+1];
                                    [friendDic setObject: count forKey:@"count"];
                                }
                                [friendList setObject:friendDic atIndexedSubscript:num];
                            }
                        }
                        
                    }
                    [dic setObject:friendList forKey:@"friendlist"];
                    [dic writeToFile:filename atomically:YES];
                    //                [dic1 writeToFile:filename atomically:YES];
                    //NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                    
                    //                    //创建一个dic，写到plist文件里
                    //                    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"1",@"163",@"2",nil];
                    //                    [dic writeToFile:filename atomically:YES];
                    //                    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"tian",@"1",nil];
                    //                    [dic1 writeToFile:filename atomically:YES];
                }
                else {
                    
                    NSMutableDictionary *plistD = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
                    NSMutableArray *friendPlist = [[NSMutableArray alloc]initWithArray:plistD[@"friendlist"]];
                    NSMutableArray *friendList = [NSMutableArray array];
                    [friendList addObjectsFromArray:resultDict[@"buddies"]];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:resultDict[@"user"] forKey:@"user"];
                    
                    
                    for (int num = 0; num < friendList.count; num ++) {
                        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendList[num]];
                        for (NSDictionary *friendDic1 in friendPlist) {
                            if ([friendDic[@"id"] isEqualToString:friendDic1[@"id"]]) {
                                if (friendDic1[@"count"]) {
                                    [friendDic setObject:friendDic1[@"count"] forKey:@"count"];
                                }
                                if (friendDic1[@"lastMessage"]) {
                                    [friendDic setObject:friendDic1[@"lastMessage"] forKey:@"lastMessage"];
                                }
                                if (friendDic1[@"time"]) {
                                    [friendDic setObject:friendDic1[@"time"] forKey:@"time"];
                                }
                            }
                        }
                        [friendList setObject:friendDic atIndexedSubscript:num];
                    }

                    
                    
                    for (int num = 0; num < friendList.count; num++) {
                        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendList[num]];
                        for (NSDictionary *newDic in resultDict[@"new_messages"]){
                            if ([newDic[@"from"]isEqualToString:friendDic[@"id"]]) {
                                [friendDic setObject:newDic[@"body"] forKey:@"lastMessage"];
                                [friendDic setObject:newDic[@"timestamp"] forKey:@"time"];
                                if (!friendDic[@"count"]) {
                                    [friendDic setObject:@"1" forKey:@"count"];
                                }else{
                                    NSString *count = [NSString stringWithFormat:@"%d",[friendDic[@"count"] integerValue]+1];
                                    [friendDic setObject: count forKey:@"count"];
                                }
                                [friendList setObject:friendDic atIndexedSubscript:num];
                            }
                        }
                        
                    }
                    [dic setObject:friendList forKey:@"friendlist"];
                    [dic writeToFile:filename atomically:YES];
                }

                
                
                
                NewsList = resultDict[@"new_messages"];
                //声音和震动
                if (NewsList.count>0) {
                    [self SoundAndZhendong];
                }
                NSDictionary *UserDic = resultDict[@"user"];
                UserImageUrl = UserDic[@"avatar"];
                UserName = UserDic[@"nick"];
                ChatType = UserDic[@"type"];
                ChatRnd = UserDic[@"rnd"];
                ChatZend = UserDic[@"zend"];
                ChatId = UserDic[@"id"];
                [self _reconnect];
                [self NumberRefresh];
                [MyTableView reloadData];
            
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        [[UIApplication sharedApplication].keyWindow makeToast:@"获取好友列表失败，请检查网络设置" duration:1.0f position:@"center"];
        self.navigationItem.title = @"连接失败";
        
    }];
    [request startAsynchronous];
}

//调用删除接口
//-(void)DeleteSomeOne:(NSIndexPath *)index{
//    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_WEBSOCKET_ONLINE]];
//    //    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
//    //    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
//    
//    NSDictionary *dic = UserArr[index.row];
//
//    
//    request.requestMethod = @"POST";
//    [request addPostValue:MY_UID forKey:@"uid"];
//    [request addPostValue:@"1" forKey:@"utype"];
//    [request addPostValue:MY_UUID forKey:@"urnd"];
//    [request addPostValue:MY_UZEND forKey:@"uzend"];
//    [request addPostValue:dic[@"id"] forKey:@"id"];
//    [request addPostValue:@"chat" forKey:@"type"];
//    
//    [request setCompletionBlock:^{
//        NSLog(@"%@",request.responseString);
//        NSError *error;
//        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
//        if (!error) {
//            if ([resultDict[@"success"] boolValue]) {
//                [UserArr removeObjectAtIndex:index.row];
//                [MyTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//        }
//    }];
//    
//    [request setFailedBlock:^{
//        [[UIApplication sharedApplication].keyWindow makeToast:@"删除聊天记录失败" duration:1.0f position:@"center"];
//        self.navigationItem.title = @"连接失败";
//        
//    }];
//    [request startAsynchronous];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 *转换json语句为NSString
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/*处理返回应该显示的时间*/
- (NSString *) returnUploadTime:(NSString *)timeStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000];
    
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    
    NSDateFormatter *yourformatter = [[NSDateFormatter alloc]init];
    
//    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚..."];
            
        }else{
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"今天 %@",[yourformatter stringFromDate:date]];
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        [yourformatter setDateFormat:@"HH:mm"];
        
        timeString = [NSString stringWithFormat:@"今天 %@",[yourformatter stringFromDate:date]];
        
        NSTimeInterval secondPerDay = 24*60*60;
        
        NSDate * yesterDay = [NSDate dateWithTimeIntervalSinceNow:-secondPerDay];
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        
        unsigned uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents * souretime = [calendar components:uintFlags fromDate:date];
        
        NSDateComponents * yesterday = [calendar components:uintFlags fromDate:yesterDay];
        
        if (souretime.year == yesterday.year && souretime.month == yesterday.month && souretime.day == yesterday.day){
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"昨天 %@",[yourformatter stringFromDate:date]];
        }
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"昨天 %@",[yourformatter stringFromDate:date]];
            
        }else if(num == 2){
            
            [yourformatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"前天 %@",[yourformatter stringFromDate:date]];
            
        }else if (num > 2 && num <7){
            
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
//            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }else if (num >= 7 && num <= 10) {
            
//            timeString = [NSString stringWithFormat:@"1周前"];
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }else if(num > 10){
            
            [yourformatter setDateFormat:@"MM-dd"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }
        
    }
    

    return timeString;
}

-(void)ClearNumberOfAPNS:(NSString *)number{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_BANGDING_TOKEN]];
    
    request.requestMethod = @"POST";
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    [request addPostValue:MY_TOKEN forKey:@"devicetoken"];
    [request addPostValue:number forKey:@"msgcount"];
    [request addPostValue:@"0" forKey:@"os"];
    
//    NSLog(@"%@",MY_TOKEN);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue] ) {
                NSLog(@"修改推送数量成功");
                [UIApplication sharedApplication].applicationIconBadgeNumber = [number integerValue];
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:resultDict[@"error_msg"] duration:1.5 position:@"center"];
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
//        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
//        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    [request startAsynchronous];
}

-(BOOL)SaveFriendHistory:(NSDictionary *)ChatDic IsWlan:(BOOL)iswlan{
    BOOL flag = NO;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
    NSString *filename=[path stringByAppendingPathComponent:name];
    
    NSDictionary *plistD = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSMutableArray *friendPlist = [[NSMutableArray alloc]initWithArray:plistD[@"friendlist"]];
//    NSMutableArray *friendList = [NSMutableArray array];
//    [friendList addObjectsFromArray:resultDict[@"buddies"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:plistD];
//    [dic setObject:resultDict[@"user"] forKey:@"user"];
    
    
    for (int num = 0; num < friendPlist.count; num ++) {
        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendPlist[num]];
        //        for (NSDictionary *friendDic1 in friendPlist) {
        if ([ChatDic[@"id"] isEqualToString:friendDic[@"id"]]) {
            [friendPlist setObject:ChatDic atIndexedSubscript:num];
        }
    }
    [dic setObject:friendPlist forKey:@"friendlist"];
    
    [dic writeToFile:filename atomically:YES];
    
    if (iswlan) {
        NSArray *FriendsListArr = dic[@"friendlist"];
        //遍历好友列表的数组 获取房东的id 添加到数组
        //    UserArr = [NSMutableArray array];
        int min = 0;
        //                NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
        for (NSDictionary *dic in FriendsListArr) {
            //                    NSString *idid = dic[@"id"];
            NSInteger num = [dic[@"count"] integerValue];
           min += num;
            NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
            //        [UserArr addObject:dic];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = min;
        if([UIApplication sharedApplication].applicationIconBadgeNumber > 0){
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
        }else{
            self.navigationController.tabBarItem.badgeValue = nil;
        }
        
        //                NSLog(@"%@",self.navigationController.tabBarItem.badgeValue);
        [self ClearNumberOfAPNS:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];

    }
    
    
    return flag;
}

-(BOOL)SendMessage:(NSDictionary *)ChatDic{
    BOOL flag = NO;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
    NSString *filename=[path stringByAppendingPathComponent:name];
    
    NSDictionary *plistD = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSMutableArray *friendPlist = [[NSMutableArray alloc]initWithArray:plistD[@"friendlist"]];
    //    NSMutableArray *friendList = [NSMutableArray array];
    //    [friendList addObjectsFromArray:resultDict[@"buddies"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:plistD];
    //    [dic setObject:resultDict[@"user"] forKey:@"user"];
    
    
    for (int num = 0; num < friendPlist.count; num ++) {
        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendPlist[num]];
        //        for (NSDictionary *friendDic1 in friendPlist) {
        if ([ChatDic[@"id"] isEqualToString:friendDic[@"id"]]) {
            [friendPlist setObject:ChatDic atIndexedSubscript:num];
        }
    }
    [dic setObject:friendPlist forKey:@"friendlist"];
    
    [dic writeToFile:filename atomically:YES];
    if (webscoket) {
        flag = YES;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"send",@"chat",@"type",friendId,@"to",MY_UID,@"from",UserName,@"nick",ChatDic[@"lastMessage"],@"body", nil];
        if ([NSJSONSerialization isValidJSONObject:dic])
        {
            NSString *stringl = [self dictionaryToJson:dic];
            [webscoket send:stringl];
            NSLog(@"%@",stringl);
            
        }else{
            [self.view makeToast:@"聊天登陆信息格式转换错误"];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络状况不佳，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    }

    return flag;
}

-(BOOL)SaveOtherMessage:(NSDictionary *)Message{
    BOOL flag = NO;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
    NSString *filename=[path stringByAppendingPathComponent:name];
    
    NSDictionary *plistD = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSMutableArray *friendPlist = [[NSMutableArray alloc]initWithArray:plistD[@"friendlist"]];
    //    NSMutableArray *friendList = [NSMutableArray array];
    //    [friendList addObjectsFromArray:resultDict[@"buddies"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:plistD];
    //    [dic setObject:resultDict[@"user"] forKey:@"user"];
    
    
    for (int num = 0; num < friendPlist.count; num ++) {
        NSMutableDictionary *friendDic = [NSMutableDictionary dictionaryWithDictionary:friendPlist[num]];
        //        for (NSDictionary *friendDic1 in friendPlist) {
        NSString *from = [NSString stringWithFormat:@"%@",Message[@"from"]];
        if ([from isEqualToString:friendDic[@"id"]]) {
            NSString *urlString = [NSString stringWithFormat:@"%@",Message[@"body"]];
            //组装一个字符串，把里面的网址解析出来
            NSError *error;
            NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\\[roomid\\=([0-9]+) image\\=http://([\\w-_./?%&=]*)\\](.+)\\[\\/roomid\\]" options:0 error:&error];
            //    if (regex1 != nil)
            //    {
            NSTextCheckingResult *firstMatch1 = [regex1 firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
            if (firstMatch1)
            {
                
                NSRange resultRange1 = [firstMatch1 rangeAtIndex:0];
                NSRange resultRange2 = [firstMatch1 rangeAtIndex:1];
                NSRange resultRange3 = [firstMatch1 rangeAtIndex:2];
                NSRange resultRange4 = [firstMatch1 rangeAtIndex:3];
                
                NSString *urlStr1 = [urlString substringWithRange:resultRange1];
                NSString *urlStr2 = [urlString substringWithRange:resultRange2];
                NSString *urlStr3 = [urlString substringWithRange:resultRange3];
                NSString *urlStr4 = [urlString substringWithRange:resultRange4];
                
                NSLog(@"%@,%@,%@,%@",urlStr1,urlStr2,urlStr3,urlStr4);
                urlString = [NSString stringWithFormat:@"房客查看了房间:【%@】",urlStr4];
            }

            [friendDic setObject:urlString forKey:@"lastMessage"];
            [friendDic setObject:Message[@"timestamp"] forKey:@"time"];
            NSString *number = [NSString stringWithFormat:@"%d",[friendDic[@"count"] integerValue] + 1];
            [friendDic setObject:number forKey:@"count"];
            [friendPlist  setObject:friendDic atIndexedSubscript:num];
            flag = YES;
        }
    }
    if (flag==NO) {
        NSMutableDictionary *doc = [NSMutableDictionary dictionary];
        [doc setObject:Message[@"from"] forKey:@"id"];
        [doc setObject:Message[@"timestamp"] forKey:@"time"];
        [doc setObject:Message[@"body"] forKey:@"lastMessage"];
        [doc setObject:@"1" forKey:@"count"];
        [friendPlist addObject:doc];
        [dic setObject:friendPlist forKey:@"friendlist"];
        
        [dic writeToFile:filename atomically:YES];
        [self ChatOnline];
        return flag;
    }
    [dic setObject:friendPlist forKey:@"friendlist"];
    
    [dic writeToFile:filename atomically:YES];
    [self NumberRefresh];
    
    [MyTableView reloadData];
    
    return flag;
}


-(void)WebSocketStatusChange:(NSNotification *) NSNotification{
    NSDictionary *dic = [NSNotification userInfo];
    if ([dic[@"status"] isEqualToString:@"open"]) {
        NSLog(@"开启websocket");
        [self ChatOnline];
    }else if([dic[@"status"] isEqualToString:@"close"]){
        
        NSLog(@"关闭websocket");
        [webscoket close];
    }
}

-(void)BeginWeb{
    [self ChatOnline];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebSocketStatusChange:) name:NO_WebSocketStatusChange object: nil];
    

}

-(void)SoundAndZhendong{
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

-(void)NumberRefresh{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *name = [NSString stringWithFormat:@"%@.plist",MY_UID];
    NSString *filename=[path stringByAppendingPathComponent:name];
    
    plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    NSArray *FriendsListArr = plistDic[@"friendlist"];
    //遍历好友列表的数组 获取房东的id 添加到数组
    UserArr = [NSMutableArray array];
    int min = 0;
    //                NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
    for (NSDictionary *dic in FriendsListArr) {
        //                    NSString *idid = dic[@"id"];
        NSInteger num = [dic[@"count"] integerValue];
        min += num;
        NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
        [UserArr addObject:dic];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = min;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0 &&[UIApplication sharedApplication].applicationIconBadgeNumber <100) {
        item.title = [NSString stringWithFormat:@"消息(%d)",[UIApplication sharedApplication].applicationIconBadgeNumber];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
    else if([UIApplication sharedApplication].applicationIconBadgeNumber >99){
        item.title = [NSString stringWithFormat:@"消息(99+)"];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"99+"];
    }
    else{
        item.title = [NSString stringWithFormat:@"返回"];
        self.navigationController.tabBarItem.badgeValue = nil;
    }

}

@end
