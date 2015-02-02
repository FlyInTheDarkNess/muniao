//
//  iuiueChatListViewController.h
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/2.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageDelegate <NSObject>

-(BOOL)AddOneMessage:(NSDictionary *)Message;



@end

@interface iuiueChatListViewController : UIViewController

@property (nonatomic,assign) BOOL isConnet;//websocket连接状态


-(void)BeginWeb;


@end
