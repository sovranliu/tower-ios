//
//  UINavigationItem+Margin.m
//  DzhIPhone
//
//  Created by Howard Dong on 14-2-16.
//
//

#import "UINavigationItem+Margin.h"
#import "CommonDefine.h"

@implementation UINavigationItem (Margin)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if (IOS_VERSION >= 5.0)
    {
        BOOL isIOS7Later    = ((floor(NSFoundationVersionNumber))>NSFoundationVersionNumber_iOS_6_1 && IOS_VERSION >= 7);
//        int offset = isIOS7Later ? -15 : -5;
        int offset = isIOS7Later ? -10 : 0;
        
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = offset;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:[NSArray arrayWithObjects:spaceButtonItem, _leftBarButtonItem, nil]];   //@[spaceButtonItem, _leftBarButtonItem]
        }
        else
        {
            [self setLeftBarButtonItems:[NSArray arrayWithObjects:spaceButtonItem, nil]]; // @[spaceButtonItem]
        }
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if (IOS_VERSION >= 5)
    {
        BOOL isIOS7Later    = ((floor(NSFoundationVersionNumber))>NSFoundationVersionNumber_iOS_6_1 && IOS_VERSION >= 7);
//        int offset = isIOS7Later ? -15 : -5;
        int offset = isIOS7Later ? -10 : 0;
        
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = offset;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:[NSArray arrayWithObjects:spaceButtonItem, _rightBarButtonItem, nil]];  // @[spaceButtonItem, _rightBarButtonItem]
        }
        else
        {
            [self setRightBarButtonItems:[NSArray arrayWithObjects:spaceButtonItem, nil]]; // @[spaceButtonItem]
        }
    }
}
#endif

@end
