//
//  NSObject+Customizer.h
//  LeCakeIphone
//
//  Created by David on 14-10-21.
//  Copyright (c) 2014年 NX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Customizer)
@property (nonatomic, copy) NSString *objectTag;
/**************************************************************************
 FunctionName:  uuidString
 FunctionDesc:  为对象生成一个UUID标记值
 Parameters:    NONE
 ReturnVal:     NSString
 **************************************************************************/
- (NSString *)uuidString;
@end
