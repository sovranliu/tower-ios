//
//  CommonGetPlistFunc.m
//  LeCakeIphone
//
//  Created by David on 14-10-22.
//  Copyright (c) 2014年 NX. All rights reserved.
//

#import "CommonGetPlistFunc.h"
#import "CMViewController.h"
#import "UINavigationBar+Customizer.h"

@implementation CommonGetPlistFunc

+ (NSArray *)getTabBarViewControllers
{
    NSMutableArray *array   = [NSMutableArray array];
    NSArray * menuArray     = [self getLeftMenuItems];
    
    for (NSDictionary *dic in menuArray)
    {
        @autoreleasepool
        {
            NSInteger tabBarIdx = [[dic objectForKey:@"selTabBarIndex"] integerValue];
            if (tabBarIdx >= 0)
            {
                NSString *className = [dic objectForKey:@"ViewName"];
                
                NSLog(@"TabBarClassName:%@",className);
                
                id obj   = [[NSClassFromString(className) alloc] init];
                
                if ([obj isKindOfClass:[UIViewController class]])
                {
                    BOOL showNav = [[dic objectForKey:@"IsShowNav"] boolValue];
                    [(CMViewController *)obj setResident:YES];
                    [(CMViewController *)obj setShowNav:showNav];
                    [(CMViewController *)obj setTabBarIndex:tabBarIdx];
                    UIViewController *tmpVC = (UIViewController *)obj;
                    
                    if (showNav)
                    {
                        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:tmpVC];
                        tmpVC = navVC;
                    }
                    
                    [array addObject:tmpVC];
                }
            }
            
        }
    }
    
    return array;
}

+ (NSArray *)getLeftMenuItems
{
    NSString * menuConfigPath       = [[NSBundle mainBundle] pathForResource:@"MenuConfig" ofType:@"plist"];
    NSDictionary * menuConfigDict   = [NSDictionary dictionaryWithContentsOfFile:menuConfigPath];
    NSArray * menuArray             = [menuConfigDict objectForKey:@"LeftMenuItems"];
    NSMutableArray *menuTree        = [NSMutableArray arrayWithCapacity:[menuArray count]];
    
    for (NSDictionary *dic in menuArray)
    {
        NSInteger dspId = [[dic objectForKey:@"dspInLeftViewId"] integerValue];
        if (dspId >= 0) [menuTree addObject:dic];
    }
    
    [menuTree sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger dspId1 = [[(NSDictionary *)obj1 objectForKey:@"dspInLeftViewId"] integerValue];
        NSInteger dspId2 = [[(NSDictionary *)obj2 objectForKey:@"dspInLeftViewId"] integerValue];
        if (dspId1 > dspId2) {
            return NSOrderedDescending;
        }
        if (dspId1 < dspId2) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    return menuTree;
}
@end
