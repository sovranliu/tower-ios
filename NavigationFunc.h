//
//  NavigationFunc.h
//  Video
//
//  Created by Howard on 13-5-14.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    NavBarLeftItemType      = 0,
    NavBarRightItemType     = 1,
    NavBarTitleItemType     = 2,
}NavBarItemType;

@interface NavigationFunc : NSObject

+ (void)setNavigationFlexibleSpaceItem:(UIViewController *)controller navItemType:(NavBarItemType)itemType;

+ (void)setNavigationImageItem:(UIViewController *)controller image:(UIImage *)image highlightImg:(UIImage *)highlightImage bgImage:(UIImage *)bgImg highlightBGImage:(UIImage *)highlightBGImg action:(SEL)action navItemType:(NavBarItemType)itemType itemTag:(int)itemTag;

+ (void)setNavigationTitleItem:(UIViewController *)controller title:(NSString *)title titleClr:(UIColor *)titleClr highlightClr:(UIColor *)hightlightClr bgImage:(UIImage *)bgImg highlightBGImage:(UIImage *)highlightBGImg font:(UIFont *)font action:(SEL)action navItemType:(NavBarItemType)itemType itemTag:(int)itemTag;

+ (void)setNavigationBarBackgrounImage:(UIViewController *)controler image:(UIImage *)image;

+ (void)setNavigationBarBackgrounImage:(UIViewController *)controler image:(UIImage *)image cornerRadii:(CGSize)cornerSize roundingCorners:(UIRectCorner)roundingCorners shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

+ (void)setNavigationBarBackgrounImageWith:(UINavigationBar *)navigationBar image:(UIImage *)image;
@end
