//
//  CMTabBar.h
//  Video
//
//  Created by Howard on 13-5-2.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "CMView.h"
#import "CustomBadgeView.h"


typedef enum _BadgeViewAlignType
{
    BadgeViewAlignLeft     = 0,
    BadgeViewAlignCenter   = 1,
    BadgeViewAlignRight    = 2,
}BadgeViewAlignType;


@protocol CMTabBarDelegate;

@interface TabBarItem : UIControl
@property (nonatomic, copy, setter = setBadgeValue:) NSString *badgeValue;
@property (nonatomic, strong, setter = setTitleFont:) UIFont *titleFont;
@property (nonatomic, copy, setter = setTitle:) NSString *title;
@property (nonatomic, strong) UIImage *coatBgImage;
@property (nonatomic, strong) UIImage *normalBgImage;
@property (nonatomic, strong) UIImage *selectedBgImage;
@property (nonatomic, strong) UIImage *normalIconImage;
@property (nonatomic, strong) UIImage *selectedIconImage;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, setter = setIsCoated:) BOOL isCoated;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, assign) BadgeViewAlignType alignType;
@property (nonatomic, strong) CustomBadgeView *badgeView;

- (void)setSelected:(BOOL)isSelected;
- (void)setTitleShadowColor:(UIColor *)color;
- (void)setTitleShadowOffset:(CGSize)shadowOffset;

@end


@interface CMTabBar : CMView
@property (nonatomic, assign) int currentHighlightedIndex;
@property (nonatomic, assign) id<CMTabBarDelegate> delegate;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImage *coatBgImage;
@property (nonatomic, strong, setter = setTabBarItems:) NSMutableArray *tabBarItems;

- (void)removeHighlightMenuItem;
- (void)addHighlightMenuItemAtIndex;
- (void)removeHighlightMenuItemAtIndex;
- (void)highlightMenuItemAtIndex:(int)index;

- (void)selectedAtIndex:(NSUInteger)index;

@end


@protocol CMTabBarDelegate <NSObject>
- (BOOL)tabBarShouldSelectedItem:(CMTabBar *)tabBar curItemTag:(NSInteger)itemTag;
@optional
- (void)tabBarSelectedItemChanged:(CMTabBar *)tabBar curItemTag:(NSInteger)itemTag oldItemTag:(NSInteger)oldItemTag;

@end
