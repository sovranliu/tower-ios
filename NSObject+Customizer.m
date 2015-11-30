//
//  NSObject+Customizer.m
//  LeCakeIphone
//
//  Created by David on 14-10-21.
//  Copyright (c) 2014年 NX. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+Customizer.h"
static const char *ObjectTagKey = "ObjectTag";

@implementation NSObject (Customizer)
@dynamic objectTag;

- (NSString *)objectTag
{
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setObjectTag:(NSString *)newObjectTag
{
    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)uuidString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid) ;
    CFRelease(uuid);
    
    return uuidString;
}
@end
