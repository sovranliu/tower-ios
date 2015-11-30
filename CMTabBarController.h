//
//  CMTabBarController.h
//  Video
//
//  Created by Howard on 13-5-8.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "CMViewController.h"
#import "CMTabBar.h"


@protocol CMTabBarControllerDelegate;

@interface CMTabBarController : CMViewController
@property (nonatomic, strong, setter = setViewControllers:) NSMutableArray *viewControllers;
@property (nonatomic, strong) CMTabBar *tabBar;
@property (nonatomic, assign) id<CMTabBarControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *tabBarBGImage;
@property (nonatomic, strong) UIImage *tabBarSelectedBGImage;
@property (nonatomic, assign) NSInteger tabBarHeight;
@property (nonatomic, assign) BOOL isPopToRoot;
@property (nonatomic, readonly) NSInteger curSelIndex;

- (void)setTabBarSelectedIndex:(NSInteger)selIndex;
- (void)setSelectedVCIndex:(int)index;
@end


@protocol CMTabBarControllerDelegate <NSObject>
@optional
// 当前TabbarItem是否允许选中
- (BOOL)tabBarController:(CMTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);

// CMTabBarController选中当前的viewController
- (void)tabBarController:(CMTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

// CMTabBarController中移除选中的viewController
- (void)tabBarController:(CMTabBarController *)tabBarController removeSelectViewController:(UIViewController *)viewController;

// CMTabBarController点击同一TabbarItem项时，当前viewController要处理的操作(viewController参数可能是UINavigationController, 实现此委托方法需要自己判断; 如果isPopToRoot属性设置为YES时，此方法不会被调用)
- (void)tabBarController:(CMTabBarController *)tabBarController selectedTheSameTabBarItemOperation:(UIViewController *)viewController;

@end
