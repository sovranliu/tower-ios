//
//  CMView.m
//  TestMyFramework
//
//  Created by Glen Lau on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CMView.h"
//#import "CMBaseFramework.h"


@implementation CMView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.objectTag = [self uuidString];
        
//        [[CMNotificationCenter defaultCenter] addObserver:self selector:@selector(vcMsgThemeChange:) name:kThemeChangeNotification object:nil];
//        [[CMNetLayerNotificationCenter defaultCenter] addObserver:self selector:@selector(vcMsgCenterProcess:) name:self.objectTag object:nil];
//        [[CMNotificationCenter defaultCenter] addObserver:self selector:@selector(vcMsgCenterRequestProcess:) name:[NSString stringWithFormat:@"%@request", self.objectTag] object:nil];
        [self setClearsContextBeforeDrawing:YES];
    }
    return self;
}

- (void)dealloc
{
//    [[CMNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
//    [[CMNetLayerNotificationCenter defaultCenter] removeObserver:self name:self.objectTag object:nil];
//    [[CMNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@request", self.objectTag] object:nil];
    
//    [super dealloc];
}

- (void)vcMsgCenterProcessInMainThread:(NSNotification *)notification
{
    [self performSelectorInBackground:@selector(tmpResponseProcessThreadAction:) withObject:notification];
}
- (void)vcMsgCenterRequestProcessThread:(NSNotification *)notification
{
    [self performSelectorInBackground:@selector(tmpRequestProcessThreadAction:) withObject:notification];
}

- (void)tmpResponseProcessThreadAction:(NSNotification *)notification
{
    @autoreleasepool {
        [self performSelector:@selector(vcMsgCenterProcess:) withObject:notification];
    }
}

- (void)tmpRequestProcessThreadAction:(NSNotification *)notification
{
    @autoreleasepool {
        [self performSelector:@selector(vcMsgCenterRequestProcess:) withObject:notification];
    }
}

- (void)vcMsgThemeChange:(NSNotification *)notification {}
- (void)vcMsgCenterProcess:(NSNotification *)notification {}
- (void)vcMsgCenterRequestProcess:(NSNotification *)notification {}

@end



@implementation UIView (GetViewController)

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
