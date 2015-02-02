//
//  MessageModel.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessageModel.h"
#import "Constants.h"

@implementation MessageModel
@synthesize UserImageUrl,FriendImageUrl;
+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel *message = [[self alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@",dict[@"body"]];
    NSString *from = [NSString stringWithFormat:@"%@",dict[@"from"]];
    NSString *uid  = [NSString stringWithFormat:@"%@",MY_UID];
    if ([from isEqualToString:uid]) {
        message.type = 0;
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
            urlString = [NSString stringWithFormat:@"推荐房间:%@",urlStr4];
        }
        message.text = urlString;
        NSString *time = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
        message.time = [self returnUploadTime:time];
    }else{
        message.type = 1;
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
        
        
        message.text = urlString;
        NSString *time = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
        message.time = [self returnUploadTime:time];
    }
//    message.type = [dict[@"type"] intValue];
return message;
}

/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString *)timeSS
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


@end
