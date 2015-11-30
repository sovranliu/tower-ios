//
//  Utils.m
//  HDMedical
//
//  Created by 曹根 on 15/1/13.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import "Utils.h"
@implementation Utils

// 校验手机号格式是否合法，手机号13，14，15，18开头
+ (BOOL)checkPhoneNumInput:(NSString *)_text{
    //    NSString *Regex =@"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
    NSString *Regex =@"1\\d{10}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:_text];
}

// 校验邮箱格式是否合法
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断是否是gif图片
+ (BOOL)isGifImage:(NSData*)imageData {
    const char* buf = (const char*)[imageData bytes];
    if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
        return YES;
    }
    return NO;
}

// 计算字符串长度，长度为英文＋中文*2
+ (NSInteger)getNSStringLength:(NSString *)str
{
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (NSString *)getSystemName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    UIDevice * dev = [UIDevice currentDevice];
    //机器系统版本
    NSString *deviceSystemVersion = [NSString stringWithFormat:@"ios%@",dev.systemVersion];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return [NSString stringWithFormat:@"iPhone 1G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone1,2"])    return [NSString stringWithFormat:@"iPhone 3G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone2,1"])    return [NSString stringWithFormat:@"iPhone 3GS+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone3,1"])    return [NSString stringWithFormat:@"iPhone 4+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPod1,1"])      return [NSString stringWithFormat:@"iTouch 1G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPod2,1"])      return [NSString stringWithFormat:@"iTouch 2G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPod3,1"])      return [NSString stringWithFormat:@"iTouch 3G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPod4,1"])      return [NSString stringWithFormat:@"iTouch 4G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPod5,3"])      return [NSString stringWithFormat:@"iTouch 5G+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPad1,1"])      return [NSString stringWithFormat:@"iPad+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"i386"])         return [NSString stringWithFormat:@"Simulator+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone5,2"])    return [NSString stringWithFormat:@"iPhone5+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone4,1"])    return [NSString stringWithFormat:@"iPhone4S+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone5,3"])    return [NSString stringWithFormat:@"iPhone5C+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone5,4"])    return [NSString stringWithFormat:@"iPhone5C+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone6,1"])    return [NSString stringWithFormat:@"iPhone5S+%@",deviceSystemVersion];
    
    else if ([platform isEqualToString:@"iPhone6,2"])    return [NSString stringWithFormat:@"iPhone5S+%@",deviceSystemVersion];
    
    else return [NSString stringWithFormat:@"%@+%@", platform, deviceSystemVersion];
    
}


+ (NSString *)getMacAddress
{
    int                    mib[6];
    size_t					len;
    char					*buf;
    unsigned char			*ptr;
    struct if_msghdr		*ifm;
    struct sockaddr_dl		*sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *macAddStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [macAddStr uppercaseString];
}

+ (NSString *)getCurDate
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *sdate = [formatter stringFromDate:curDate];
    return sdate;
    
}

+ (NSString *)getCurTimeStr
{
    unsigned units		= NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *mycal	= [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now			= [NSDate date];
    
    NSDateComponents *comp = [mycal components:units fromDate:now];
    
    NSInteger month		= [comp month];
    NSInteger year		= [comp year];
    NSInteger day		= [comp day];
    NSInteger hour		= [comp hour];
    NSInteger minute	= [comp minute];
    NSInteger second	= [comp second];
    NSString *strDay	= day < 10 ? [NSString stringWithFormat:@"0%ld", day] : [NSString stringWithFormat:@"%ld", day];
    NSString *strMonth	= month < 10 ? [NSString stringWithFormat:@"0%ld", month] : [NSString stringWithFormat:@"%ld", month];
    NSString *strHour	= hour < 10 ? [NSString stringWithFormat:@"0%ld", hour] : [NSString stringWithFormat:@"%ld", hour];
    NSString *strMinute	= minute < 10 ? [NSString stringWithFormat:@"0%ld", minute] : [NSString stringWithFormat:@"%ld", minute];
    NSString *strSecond	= second < 10 ? [NSString stringWithFormat:@"0%ld", second] : [NSString stringWithFormat:@"%ld", second];
    NSString *strDate	= [NSString stringWithFormat:@"%ld-%@-%@ %@%@%@", year, strMonth, strDay, strHour, strMinute, strSecond];
    
    return strDate;
}

// 取当前时间 格式DDHHmmss 返回多少秒
+ (unsigned long)getSecondsValInCurTime
{
    unsigned long curVal;
    unsigned units		= NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSCalendar *mycal	= [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now			= [NSDate date];
    
    NSDateComponents *comp = [mycal components:units fromDate:now];
    NSInteger day		= [comp day];
    NSInteger hour		= [comp hour];
    NSInteger minute	= [comp minute];
    NSInteger second	= [comp second];
    
    curVal = day * 24 * 60 * 60 + hour * 60 * 60 + minute * 60 + second;
    
    return curVal;
}

+ (int)getCurTimeVal
{
    unsigned units		= NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSCalendar *mycal	= [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now			= [NSDate date];
    
    NSDateComponents *comp = [mycal components:units fromDate:now];
    
    NSInteger hour		= [comp hour];
    NSInteger minute	= [comp minute];
    NSInteger second	= [comp second];
    long retVal          = hour * 10000 + minute * 10 + second;
    return (int)retVal;
}


+ (NSString *) getFilePath:(NSString *)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString * filepath = [NSMutableString stringWithCapacity:10];
    [filepath appendString:documentsDirectory];
    [filepath appendString:@"/"];
    [filepath appendString:file];
    
    return filepath;
}


@end
