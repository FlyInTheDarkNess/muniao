//
//  iuiueCHKeychain.h
//  iuiue
//
//  Created by 赵中良 on 14-5-26.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iuiueCHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
