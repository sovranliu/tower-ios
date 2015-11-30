//
//  Utils.h
//  HDMedical
//
//  Created by 曹根 on 15/1/13.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"
#import "sys/utsname.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface Utils : NSObject
// 校验手机号格式是否合法，手机号13，14，15，18开头
+ (BOOL)checkPhoneNumInput:(NSString *)_text;
// 校验邮箱格式是否合法
+ (BOOL)validateEmail:(NSString *)email;
// 判断是否是gif图片
+ (BOOL)isGifImage:(NSData*)imageData ;
// 计算字符串长度，长度为英文＋中文*2
+ (NSInteger)getNSStringLength:(NSString *)str;

//获取设备类型
+ (NSString *)getSystemName;

+ (NSString *)getMacAddress;

// 取当日期 格式YYYY-MM-DD
+ (NSString *)getCurDate;

// 取当前时间 格式YYYY-MM-DD HHmmss
+ (NSString *)getCurTimeStr;

// 取当前时间 格式DDHHmmss 返回多少秒
+ (unsigned long)getSecondsValInCurTime;

// 获取当前时间 格式hhmmss
+ (int)getCurTimeVal;

+ (NSString *) getFilePath:(NSString *)file;
@end
