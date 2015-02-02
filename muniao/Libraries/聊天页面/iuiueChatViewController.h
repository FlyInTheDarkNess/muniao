//
//  iuiueChatViewController.h
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/2.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageChange <NSObject>

-(BOOL)SaveFriendHistory:(NSDictionary *)ChatDic IsWlan:(BOOL)iswlan;//

-(BOOL)SendMessage:(NSDictionary *)ChatDic;//发送Message

@end

@interface iuiueChatViewController : UIViewController

@property (nonatomic,strong) NSString *FriendId;//聊天id
@property (nonatomic,strong) NSString *UserImageUrl;
@property (nonatomic,strong) NSString *FriendImageUrl;
@property (nonatomic,strong) NSDictionary *FriendDic;

@property(nonatomic,weak)id<MessageChange>delegate;



//-(BOOL)AddOneMessage:(NSDictionary *)Message;



@end
