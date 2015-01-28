//
//  AppDelegate.h
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
@private
    Reachability *hostReach;

}

@property (strong, nonatomic) UIWindow *window;

- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况

@end

