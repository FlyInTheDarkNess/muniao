//
//  iuiueChatViewController.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/2.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueChatViewController.h"
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "MessageCellone.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件
#import "Toast+UIView.h"
#define kToolBarH 44
#define kTextFieldH 30

@interface iuiueChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>
{
    MJRefreshHeaderView *_header;
    NSMutableArray *_cellFrameDatas;
    UITableView *_chatView;
    UIImageView *_toolBar;
    NSString *timeStr;
    NSInteger index;
    UIView * MyView;
    NSMutableArray *_MyArray;
    NSInteger roomNum;
}

@end

@implementation iuiueChatViewController
@synthesize FriendId;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //添加键盘变化时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //添加聊天信息变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddOneMessage:) name:NO_ChatChangeMessages object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewRefresh) name:NO_CHatViewRefresh object:nil];
    
    //0.加载数据
//    [self loadData];
    
    //1.tableView
    [self addChatView];
    
    //2.工具栏
    [self addToolBar];
    
    _MyArray = [NSMutableArray array];
}

/**
 *  记载数据
 */
- (void)loadData
{
    _cellFrameDatas =[NSMutableArray array];
    NSURL *dataUrl = [[NSBundle mainBundle] URLForResource:@"messages.plist" withExtension:nil];
    NSArray *dataArray = [NSArray arrayWithContentsOfURL:dataUrl];
    for (NSDictionary *dict in dataArray) {
        MessageModel *message = [MessageModel messageModelWithDict:dict];
        CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
        cellFrame.message = message;
        [_cellFrameDatas addObject:cellFrame];
    }
}
/**
 *  添加TableView
 */
- (void)addChatView
{
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    UITableView *chatView = [[UITableView alloc] init];
    chatView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarH);
    chatView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    chatView.delegate = self;
    chatView.dataSource = self;
    chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatView.allowsSelection = NO;
    [chatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    _chatView = chatView;
    [self setFreshView];

    [self.view addSubview:chatView];
}
/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    UIButton *sendSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSoundBtn.frame = CGRectMake(0, 0, kToolBarH, kToolBarH);
    [sendSoundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [bgView addSubview:sendSoundBtn];
    
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH, 0, kToolBarH, kToolBarH);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [addMoreBtn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addMoreBtn];
    
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH * 2, 0, kToolBarH, kToolBarH);
    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressBtn];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(kToolBarH, (kToolBarH - kTextFieldH) * 0.5, self.view.frame.size.width - 3 * kToolBarH, kTextFieldH);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    [bgView addSubview:textField];
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _chatView;
    
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
        [self GetHistoryOfChat : YES];
    }
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_header endRefreshing];
    return _cellFrameDatas.count;
}

- (MessageCellone *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    MessageCellone *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCellone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {
        
    }else
    {
        
    [self.view endEditing:YES];
    if (MyView) {
        
        [UIView animateWithDuration:0.5f animations:^{
            //        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
            CGRect r = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
            [_toolBar setFrame:CGRectMake(0, r.origin.y, r.size.width, r.size.height)];
            [_chatView setFrame:CGRectMake(0, 0, MY_WIDTH,MY_HEIGHT - kToolBarH)];
            [MyView setFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
            //自动滚到最后一行
            if (_cellFrameDatas.count>0) {
                NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }];
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyView removeFromSuperview];
            _MyArray = [NSMutableArray array];
            MyView = nil;
            
        });

    }
    }
}


#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1.获得时间
//    NSDate *senddate=[NSDate date];
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *locationString=[NSString stringWithFormat:@"%llu",recordTime];
    NSString *thistime = [self returnUploadTime:locationString];
    //2.创建一个MessageModel类
    MessageModel *message = [[MessageModel alloc] init];
    //去掉空格
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (textField.text.length==0) {
//        [[UIApplication sharedApplication].keyWindow makeToast:@"没有任何文字信息，请重新输入"];
        return NO;
    }
    message.text = textField.text;
    message.time = thistime;
    message.type = 0;
    
    NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
    [MutableDic setObject:textField.text forKey:@"lastMessage"];
    [MutableDic setObject:locationString forKey:@"time"];
    if ([_delegate SendMessage:MutableDic]) {
    //3.创建一个CellFrameModel类
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //4.添加进去，并且刷新数据
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    textField.text = @"";
    }
    return YES;
}

- (void)endEdit
{
    [self.view endEditing:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    timeStr = @"";
    NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
    [MutableDic setObject:@"0" forKey:@"count"];
    [_delegate SaveFriendHistory:MutableDic IsWlan:YES];
    _cellFrameDatas =[NSMutableArray array];
    [self GetHistoryOfChat: NO];
}



/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    if (MyView) {
//        [UIView animateWithDuration:0.5f animations:^{
//            //        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
//            CGRect r = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
//            [_toolBar setFrame:CGRectMake(0, r.origin.y, r.size.width, r.size.height)];
//            [_chatView setFrame:CGRectMake(0, 0, MY_WIDTH,MY_HEIGHT - kToolBarH)];
//            [MyView setFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
//            //自动滚到最后一行
//            //            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
//            //            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            
//        }];
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyView removeFromSuperview];
            _MyArray = [NSMutableArray array];
            MyView = nil;
            
        });
    }
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
        CGRect r = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
        [_toolBar setFrame:CGRectMake(0, r.origin.y + moveY, r.size.width, r.size.height)];
        [_chatView setFrame:CGRectMake(0, 0, MY_WIDTH,MY_HEIGHT + moveY - kToolBarH)];
        //自动滚到最后一行
        if (_cellFrameDatas.count == 0) {
            
        }else{
            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        

    }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"iuiueChatViewController dealloc");
    [_header free];
}

-(void)GetHistoryOfChat:(BOOL) UpDate{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_WEBSOCKET_HISTORY]];

    request.requestMethod = @"POST";
    [request addPostValue:@"chat" forKey:@"type"];
    [request addPostValue:FriendId forKey:@"id"];
    [request addPostValue:@"10" forKey:@"pagesize"];
//    [request addPostValue:@"1" forKey:@"page"];
    [request addPostValue:@"2" forKey:@"pageflag"];
    if (timeStr) {
        [request addPostValue:timeStr forKey:@"pagetime"];
    }
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:@"1" forKey:@"utype"];
    [request addPostValue:MY_UUID forKey:@"urnd"];
    [request addPostValue:MY_UZEND forKey:@"uzend"];
    
    [request setCompletionBlock:^{
//        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([resultDict[@"success"] boolValue]) {
                
                NSArray *dataArray = resultDict[@"list"];
                for (int num = dataArray.count - 1; num >= 0; num--) {
                    NSDictionary *dict = dataArray[num];
                    MessageModel *message = [MessageModel messageModelWithDict:dict];
                    message.UserImageUrl = self.UserImageUrl;
                    message.FriendImageUrl = self.FriendImageUrl;
                    CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
                    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
                    message.showTime = ![message.time isEqualToString:lastFrame.message.time];
                    cellFrame.message = message;
                    [_cellFrameDatas insertObject:cellFrame atIndex:0];
                }
                [_chatView reloadData];
                
                
                if (dataArray.count > 0) {
                    
                    NSDictionary *d = dataArray.firstObject;
                    timeStr = [NSString stringWithFormat:@"%@",d[@"timestamp"]];
                    index = dataArray.count;
                    
                    if (UpDate) {
                        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:index inSection:0];
                        [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }else{
                        
                        NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
                        NSDictionary *dict = dataArray.lastObject;
                        [MutableDic setObject:@"0" forKey:@"count"];
                        if ([dict[@"from"] isEqualToString:self.FriendId] ) {
                            //组装一个字符串，把里面的网址解析出来
                            NSString *urlString = [NSString stringWithFormat:@"%@",dict[@"body"]];
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
                            [MutableDic setObject:urlString forKey:@"lastMessage"];
                            [MutableDic setObject:dict[@"timestamp"] forKey:@"time"];
                            [_delegate SaveFriendHistory:MutableDic IsWlan:NO];
                            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        }else{
                            //组装一个字符串，把里面的网址解析出来
                            NSString *urlString = [NSString stringWithFormat:@"%@",dict[@"body"]];
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
                                urlString = [NSString stringWithFormat:@"推荐房间:%@",urlStr4];
                            }
                            [MutableDic setObject:urlString forKey:@"lastMessage"];
                            [MutableDic setObject:dict[@"timestamp"] forKey:@"time"];
                            [_delegate SaveFriendHistory:MutableDic IsWlan:NO];
                            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        }
                        
                    }
                }
                
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
//        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
//    hud =
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
}

/*处理返回应该显示的时间*/
- (NSString *) returnUploadTime:(NSString *)timeSS
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeSS doubleValue]/1000];
    
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
            
            [yourformatter setDateFormat:@"MM-dd HH:mm"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            //            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }else if (num >= 7 && num <= 10) {
            
            //            timeString = [NSString stringWithFormat:@"1周前"];
            [yourformatter setDateFormat:@"MM-dd HH:mm"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }else if(num > 10){
            
            [yourformatter setDateFormat:@"MM-dd HH:mm"];
            
            timeString = [NSString stringWithFormat:@"%@",[yourformatter stringFromDate:date]];
            
        }
        
    }
    

    
    return timeString;
}

-(void)AddOneMessage:(NSNotification *)Notification{
    NSDictionary *Message = [Notification userInfo];

    //更新本地存储信息
    NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
    [MutableDic setObject:Message[@"body"] forKey:@"lastMessage"];
    [MutableDic setObject:Message[@"timestamp"] forKey:@"time"];
    [_delegate SaveFriendHistory:MutableDic IsWlan:NO];
    
    //界面添加新信息
    MessageModel *message = [MessageModel messageModelWithDict:Message];
    message.UserImageUrl = self.UserImageUrl;
    message.FriendImageUrl = self.FriendImageUrl;
    CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    message.showTime = ![message.time isEqualToString:lastFrame.message.time];
    cellFrame.message = message;
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


//显示pickerview
-(IBAction)ShowPickerView:(id)sender{
    [self.view endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    if (!MyView) {
        MyView = [[UIView alloc]initWithFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
        MyView.backgroundColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 44)];
        label.tag = 2;
        label.textColor = [UIColor whiteColor];
        label.text = @"我的房间：共有0间，第0间";
        [MyView addSubview:label];
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, MY_WIDTH, 200)];
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        scroll.tag = 1;
        scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [act setCenter:CGPointMake(scroll.width/2, scroll.height/2)];
//        [MyView addSubview:act];
//        [act startAnimating];
        [MyView addSubview:scroll];
        [self.view addSubview:MyView];
        [self getOrderArray:YES Page:0];
        
        [UIView animateWithDuration:0.5f animations:^{
            //        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
            CGRect r = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
            [_toolBar setFrame:CGRectMake(0, r.origin.y - 260.0f, r.size.width, r.size.height)];
            [_chatView setFrame:CGRectMake(0, 0, MY_WIDTH,MY_HEIGHT - 260.0f - kToolBarH)];
            //自动滚到最后一行
            if (_cellFrameDatas.count>0) {
                NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [MyView setFrame:CGRectMake(0, MY_HEIGHT - 260, MY_WIDTH, 260)];
            
//            [self.view setBackgroundColor:[UIColor redColor]];
        }];
    }
    else{
        
        [UIView animateWithDuration:0.5f animations:^{
            //        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
            CGRect r = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
            [_toolBar setFrame:CGRectMake(0, r.origin.y, r.size.width, r.size.height)];
            [_chatView setFrame:CGRectMake(0, 0, MY_WIDTH,MY_HEIGHT - kToolBarH)];
            [MyView setFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
            //自动滚到最后一行
//            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
//            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }];
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyView removeFromSuperview];
            _MyArray = [NSMutableArray array];
            MyView = nil;
            
        });
    }
    
}


//获取数据
-(void)getOrderArray:(BOOL) UpDown Page:(NSInteger) page{
    
    __weak ASIFormDataRequest *request;
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_ROOMS_MIN]];
    
    request.requestMethod = @"POST";
    
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    [request addPostValue:pageStr forKey:@"page"];
    [request addPostValue:MY_UID forKey:@"uid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    //全部房源
    [request addPostValue:@"1" forKey:@"status"];
    
    
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:{
//                    [hud hide:YES];
                    NSArray *ListArray = resultDict[@"list"];
                    if (UpDown) {
                        [_MyArray addObjectsFromArray:ListArray];
                        UILabel *la = (UILabel *)[MyView viewWithTag:2];
                        roomNum = 0;
                        la.text = [NSString stringWithFormat:@"我的房间：共有%d间，第1间",_MyArray.count];
                        UIScrollView *scroll = (UIScrollView *)[MyView viewWithTag:1];
                        [scroll setContentSize:CGSizeMake(MY_WIDTH *[resultDict[@"count"] integerValue], 200)];
                        [scroll removeAllSubviews];
                        for (int num = 0 ; num < _MyArray.count; num ++) {
                            NSDictionary *dic = _MyArray[num];
                            UIView *OV = [[UIView alloc]initWithFrame:CGRectMake(10 + num * MY_WIDTH, 5,300 , 190)];
                            OV.layer.cornerRadius = 20;
                            OV.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:231.0/255.0 alpha:1];
                            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
                            [image setImageWithURL:[NSURL URLWithString:dic[@"picurl"]] placeholderImage:[UIImage imageNamed:@"backgroud"]];
                            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(image.right + 20, image.top, 260 - image.right - 40, 20)];
                            name.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
                            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(image.right + 20, name.bottom+10, 60, 20)];
                            price.text = [NSString stringWithFormat:@"$%@",dic[@"priceday"]];
                            
                            UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(image.right + 20, price.bottom,  260 - image.right - 20, 50)];
                            address.numberOfLines = 2;
                            address.text = [NSString stringWithFormat:@"%@",dic[@"address"]];
                            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, image.bottom +20, 120, 50)];
                            [btn setTitle:@"推荐给ta" forState:UIControlStateNormal];
                            [btn addTarget:self action:@selector(sendRoom:) forControlEvents:UIControlEventTouchUpInside];
                            [btn setBackgroundColor:[UIColor redColor]];
                            btn.layer.cornerRadius = 10.0f;
                            
                            [OV addSubview:btn];
                            [OV addSubview:address];
                            [OV addSubview:price];
                            [OV addSubview:name];
                            [OV addSubview:image];
                            [scroll addSubview:OV];
                        }
                    }
                    else{
                        [_MyArray removeAllObjects];
                        [_MyArray addObjectsFromArray:ListArray];
                        UIScrollView *scroll = (UIScrollView *)[MyView viewWithTag:1];
                        [scroll removeAllSubviews];
                        for (int num = 0 ; num < _MyArray.count; num ++) {
                            UIView *OV = [[UIView alloc]initWithFrame:CGRectMake(0 + num * 300, 0, 260, 200)];
                            OV.backgroundColor = [UIColor redColor];
                            [scroll addSubview:OV];
                        }

                    }
//                    pages++;
                }
                    break;
                case 90:{
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
                    [[NSNotificationCenter defaultCenter]postNotificationName:NO_APNS_JB object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication].keyWindow makeToast:@"距上次登录时间过长，请重新登录！"];
                    });
                }
                    break;
                    
                    
                default:
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    //获取数据失败处理
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
//        hud.labelText = @"加载失败。。";
        
    }];
    
    //异步加载
    [request startAsynchronous];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag==1) {
        NSInteger all = scrollView.contentSize.width/MY_WIDTH;
        NSInteger inde = scrollView.contentOffset.x/MY_WIDTH;
        roomNum = inde;
        UILabel *label = (UILabel *)[MyView viewWithTag:2];
        label.text = [NSString stringWithFormat:@"我的房间：共有%d间，第%d间",all,inde + 1];
        if (_MyArray.count < all) {
            [self getOrderArray:YES Page:(_MyArray.count/10 + 1)];
        }
    }

}

-(IBAction)sendRoom:(id)sender{
    NSDictionary *dic = _MyArray[roomNum];
    NSString *str = [NSString stringWithFormat:@"[roomid=%@ image=%@]%@[/roomid]",dic[@"roomid"],dic[@"picurl"],dic[@"title"]];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *locationString=[NSString stringWithFormat:@"%llu",recordTime];
    NSString *thistime = [self returnUploadTime:locationString];
    
    //组装一个字符串，把里面的网址解析出来
    NSString *urlString = str;
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
        urlString = [NSString stringWithFormat:@"推荐房间:%@",urlStr4];
    }
    //2.创建一个MessageModel类
    MessageModel *message = [[MessageModel alloc] init];
    message.text = urlString;
    message.time = thistime;
    message.type = 0;
    
    NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
    [MutableDic setObject:str forKey:@"lastMessage"];
    [MutableDic setObject:locationString forKey:@"time"];
    if ([_delegate SendMessage:MutableDic]) {
        
    
    //3.创建一个CellFrameModel类
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //4.添加进去，并且刷新数据
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else{
        return;
    }
}

-(void)tableViewRefresh{
    timeStr = @"";
    NSMutableDictionary *MutableDic = [NSMutableDictionary dictionaryWithDictionary:self.FriendDic];
    [MutableDic setObject:@"0" forKey:@"count"];
    [_delegate SaveFriendHistory:MutableDic IsWlan:YES];
    _cellFrameDatas =[NSMutableArray array];
    [self GetHistoryOfChat: NO];
}

@end
