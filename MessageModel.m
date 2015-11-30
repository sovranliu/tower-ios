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

@implementation MessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel *message = [[self alloc] init];
    message.text = dict[@"content"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeInterval:[dict[@"time"] intValue]/1000 sinceDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
    
    message.time = destDateString;
    
    //message.type = [dict[@"type"] intValue];
    message.type = 0; // 0是客户端 1是医生
    return message;
}

+ (id)messageModelWithDict:(NSDictionary *)dict withTypeId:(int) type
{
    MessageModel *message = [[self alloc] init];
    message.text = dict[@"content"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeInterval:[dict[@"time"] intValue]/1000 sinceDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
    
    message.time = destDateString;
    message.type = type; // 0是客户端 1是医生
    return message;
}
@end
