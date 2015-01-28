//
//  AppDelegate.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "AppDelegate.h"
#import "iuiueCHKeychain.h"//钥匙串存储
#import "Constants.h"//接口文件
#import "Toast+UIView.h"
#import "ASIFormDataRequest.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //这里初始化声音震动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:UserDefaults_EverLaunch]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaults_EverLaunch];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaults_Sound];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaults_Shake];
    }else{
        NSLog(@"已运行过");
    }
    //开启网络状况监听
    [self AddWlanJiance];
    
    //发送统计数据
    [self PostStatistics];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/**********************************************************
 
 函数名称：-(void)showView
 
 函数描述：开启网络状况监听
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)AddWlanJiance{
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
    [self updateInterfaceWithReachability: hostReach];
    //.....

}


/**********************************************************
 
 函数名称：-(void)showView
 
 函数描述：监听到网络状态改变
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


/**********************************************************
 
 函数名称：- (void) updateInterfaceWithReachability: (Reachability*) curReach
 
 函数描述：网络状况发生变化时对应的操作
 
 输入参数：curReach ：当前网络状况：wifi，3g网络，无网络
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kReachableViaWWAN)
    {
        //        printf("\n3g/2G\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"4G/3G/2G蜂窝网络已连接"  duration:1.5 position:@"center"];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"open" forKey:@"status"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    }
    else if(status == kReachableViaWiFi)
    {
        //        printf("\nwifi\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"WIFI网络已连接" duration:1.5 position:@"center"];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"open" forKey:@"status"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_WebSocketStatusChange object:nil userInfo:dic];
    }else
    {
        //        printf("\n无网络\n");
        [[UIApplication sharedApplication].keyWindow makeToast:@"当前无网络连接" duration:1.5 position:@"center"];
    }
    
}

/**********************************************************
 
 函数名称：- (void)PostStatistics
 
 函数描述：发送统计数据：包括启动app，安装，分享
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
- (void)PostStatistics{
    //获取广告标识符
    NSString *udid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    
    // 当前应用软件版本  比如：1.0.1 Version
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    // 当前应用版本号码   int类型  Build
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    //获取当前设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSString* deviceNamea = [[UIDevice currentDevice] model];
    NSLog(@"设备名称: %@",deviceNamea );

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APP_LOG]];

    request.requestMethod = @"POST";
    [request addPostValue:udid forKey:@"imei"];
    [request addPostValue:deviceName forKey:@"phone_config"];
    [request addPostValue:@"0" forKey:@"type"];
    [request addPostValue:appCurVersionNum forKey:@"version"];
    [request addPostValue:@"0" forKey:@"channel"];
    [request addPostValue:@"4" forKey:@"os"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"status"] integerValue]) {
                case 0:
                    NSLog(@"发送统计成功");
                    break;
                default:
                {
                    NSLog(@"发送统计失败");
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        NSLog(@"发送统计失败");
    }];
    
    [request startAsynchronous];
}

/**********************************************************
 
 函数名称：-(void)Update
 
 函数描述：获得appstore中最新版本的版本号
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)Update{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APPSTORE_VERSION]];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            NSLog(@"%@",resultDict[@"results"]);
            NSArray *arr = resultDict[@"results"];
            NSDictionary *dic = arr.lastObject;
            
            NSString *NewVersion = dic[@"version"];
            NSLog(@"dic：%@",NewVersion);
            [self getUpdate:[NewVersion floatValue]];
        }
    }
     ];
    [request setFailedBlock:^{
        
        NSLog(@"检查更新失败");
    }];
    [request startAsynchronous];
}

/**********************************************************
 
 函数名称：-(void)getUpdate:(float)NewVersion
 
 函数描述：对比当前版本与最新版本，判断是否更新
 
 输入参数：NewVersion ： appstore 中得最新版本号
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)getUpdate:(float)NewVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    if (NewVersion <= [appCurVersion floatValue]) {
        //自动更新不提示，手动更新提示
        //        [[UIApplication sharedApplication].keyWindow makeToast:@"已是最新版本！"];
    }
    else{
        [self showView];
        
    }
}
/**********************************************************
 
 函数名称：-(void)showView
 
 函数描述：显示是否需要更新的提示
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

/**********************************************************
 
 函数名称：-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 
 函数描述：更新alertView的点击方法
 
 输入参数：alertView：当前显示的更新alertview 
 
 buttonIndex：点击button的tag
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL_UPDATE]];
    }
    else{
        
    }
}


@end
