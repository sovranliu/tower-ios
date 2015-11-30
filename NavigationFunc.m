//
//  NavigationFunc.m
//  Video
//
//  Created by Howard on 13-5-14.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "NavigationFunc.h"
#import "UINavigationBar+Customizer.h"


@implementation NavigationFunc

+ (void)setNavigationFlexibleSpaceItem:(UIViewController *)controller navItemType:(NavBarItemType)itemType
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    switch (itemType)
    {
        case NavBarLeftItemType:
            [controller.navigationItem setLeftBarButtonItem:item];
            break;
        case NavBarRightItemType:
            [controller.navigationItem setRightBarButtonItem:item];
            break;
        default:
            break;
    }
//    [item release];
}

+ (void)setNavigationImageItem:(UIViewController *)controller image:(UIImage *)image highlightImg:(UIImage *)highlightImage bgImage:(UIImage *)bgImg highlightBGImage:(UIImage *)highlightBGImg action:(SEL)action navItemType:(NavBarItemType)itemType itemTag:(int)itemTag
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, bgImg.size.width, bgImg.size.height)];
    [button setTag:itemTag];
    [button addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:bgImg forState:UIControlStateNormal];
    [button setBackgroundImage:highlightBGImg forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    switch (itemType)
    {
        case NavBarLeftItemType:
            [controller.navigationItem setLeftBarButtonItem:btnItem];
            break;
        case NavBarRightItemType:
            [controller.navigationItem setRightBarButtonItem:btnItem];
            break;
        case NavBarTitleItemType:
            [controller.navigationItem setTitleView:button];
            break;
        default:
            break;
    }
}

+ (void)setNavigationTitleItem:(UIViewController *)controller title:(NSString *)title titleClr:(UIColor *)titleClr highlightClr:(UIColor *)hightlightClr bgImage:(UIImage *)bgImg highlightBGImage:(UIImage *)highlightBGImg font:(UIFont *)font action:(SEL)action navItemType:(NavBarItemType)itemType itemTag:(int)itemTag
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, bgImg.size.width, bgImg.size.height)];
    [button setTag:itemTag];
    [button addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:bgImg forState:UIControlStateNormal];
    [button setBackgroundImage:highlightBGImg forState:UIControlStateHighlighted];
    [button setTitleColor:titleClr forState:UIControlStateNormal];
    [button setTitleColor:hightlightClr forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setText:title];
    [button.titleLabel setFont:font];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    switch (itemType)
    {
        case NavBarLeftItemType:
            [controller.navigationItem setLeftBarButtonItem:btnItem];
            break;
        case NavBarRightItemType:
            [controller.navigationItem setRightBarButtonItem:btnItem];
            break;
        case NavBarTitleItemType:
            [controller.navigationItem setTitleView:button];
            break;
        default:
            break;
    }
}

+ (void)setNavigationBarBackgrounImage:(UIViewController *)controler image:(UIImage *)image
{
    [controler.navigationController.navigationBar customNavigationBar:image cornerRadii:CGSizeZero roundingCorners:0 shadowOffset:CGSizeZero shadowOpacity:1.0];
}

+ (void)setNavigationBarBackgrounImage:(UIViewController *)controler image:(UIImage *)image cornerRadii:(CGSize)cornerSize roundingCorners:(UIRectCorner)roundingCorners shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity
{
    [controler.navigationController.navigationBar customNavigationBar:image cornerRadii:cornerSize roundingCorners:roundingCorners shadowOffset:shadowOffset shadowOpacity:shadowOpacity];
}

+ (void)setNavigationBarBackgrounImageWith:(UINavigationBar *)navigationBar image:(UIImage *)image
{
    [navigationBar customNavigationBar:image cornerRadii:CGSizeZero roundingCorners:0 shadowOffset:CGSizeZero shadowOpacity:1.0];

}

@end
