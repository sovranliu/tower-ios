//
//  CMTabBarController.m
//  Video
//
//  Created by Howard on 13-5-8.
//  Copyright (c) 2013年 DZH. All rights reserved.
//

#import "CMTabBarController.h"
#import "CommonDefine.h"


@interface CMTabBarController () <CMTabBarDelegate>

- (void)doPopToRootViewController:(NSInteger)itemTag;
- (NSMutableArray *)getTabBarItemsArray;

@end

@implementation CMTabBarController
@synthesize viewControllers = _viewControllers;
@synthesize tabBar          = _tabBar;
@synthesize delegate        = _delegate;
@synthesize tabBarBGImage   = _tabBarBGImage;
@synthesize tabBarSelectedBGImage = _tabBarSelectedBGImage;
@synthesize tabBarHeight    = _tabBarHeight;
@synthesize isPopToRoot     = _isPopToRoot;
@synthesize curSelIndex     = _curSelIndex;


- (void)initExtendedData
{
    [super initExtendedData];
    _tabBarHeight   = KCommonDefineTabBarHeight;
    _isPopToRoot = YES;
}

//- (void)dealloc
//{
//    self.viewControllers        = nil;
//    self.tabBar                 = nil;
//    self.delegate               = nil;
//    self.tabBarBGImage          = nil;
//    self.tabBarSelectedBGImage  = nil;
//    [super dealloc];
//}

- (void)loadUIData
{
    [super loadUIData];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    
    BOOL isIOS7Later = ((floor(NSFoundationVersionNumber))>NSFoundationVersionNumber_iOS_6_1 && [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0);
    int offset = isIOS7Later ? 0 : kSysStatusBarHeight;
//    
//    NSLog(@"self.view = %@,mainFrame = %@，",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(mainFrame));
    
    _tabBar = [[CMTabBar alloc] initWithFrame:CGRectMake(0, mainFrame.size.height-_tabBarHeight-offset, mainFrame.size.width, _tabBarHeight)];
    [_tabBar setDelegate:self];
    [_tabBar setTabBarItems:[self getTabBarItemsArray]];
    [_tabBar setBgImage:_tabBarBGImage];
    [_tabBar setCoatBgImage:_tabBarSelectedBGImage];
    [_tabBar layoutSubviews];
    [self.view addSubview:_tabBar];
//    [_tabBar release];
    [_tabBar highlightMenuItemAtIndex:_curSelIndex];
}

- (void)receiveLowMemoryWarning
{
    [super receiveLowMemoryWarning];
    
    _tabBar = nil;
}

#pragma mark - private methods
- (void)doPopToRootViewController:(NSInteger)itemTag
{
    if (itemTag < [_viewControllers count])
    {
        UIViewController *ctrl = [_viewControllers objectAtIndex:itemTag];
        if ([ctrl isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController *)ctrl popToRootViewControllerAnimated:NO];
        }
        else
        {
            if (ctrl.navigationController)
            {
                [ctrl.navigationController popToRootViewControllerAnimated:NO];
            }
        }
    }
}

- (NSMutableArray *)getTabBarItemsArray
{
    NSMutableArray *tabBarItemsArray = [NSMutableArray array];
    CMViewController *cmvc;
    
    for (id vc in _viewControllers)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *tmpNavc = (UINavigationController *)vc;
            cmvc = [tmpNavc.viewControllers objectAtIndex:0];
        }
        else
            cmvc = (CMViewController *)vc;
        
        if ([cmvc respondsToSelector:@selector(cMTabBarItem)])
            [tabBarItemsArray addObject:cmvc.cMTabBarItem];
    }
    
    return tabBarItemsArray;
}

#pragma mark - public methods
- (void)setTabBarSelectedIndex:(NSInteger)selIndex
{
    if (selIndex >= 0 && selIndex < [_viewControllers count])
    {
        [_tabBar highlightMenuItemAtIndex:selIndex];
        
        if (selIndex != _curSelIndex)
            _curSelIndex = selIndex;
    }
}

- (void)setSelectedVCIndex:(int)index
{
    if (index < _tabBar.tabBarItems.count)
    {
        //TabBarItem * item = [ _tabBar.tabBarItems objectAtIndex:index];
        
        [_tabBar selectedAtIndex:3];
    }
}

#pragma mark - setter methods
- (void)setViewControllers:(NSMutableArray *)array;
{
    for (UIViewController *vc in _viewControllers)
        [vc.view removeFromSuperview];
    
//    [array retain];
//    [_viewControllers release];
    _viewControllers = array;
    
    [_tabBar setBgImage:_tabBarBGImage];
    [_tabBar setCoatBgImage:_tabBarSelectedBGImage];
    [_tabBar setTabBarItems:[self getTabBarItemsArray]];
    [_tabBar layoutSubviews];
    
    for (UIViewController *vc in _viewControllers)
    {
        CGRect rtFrame = vc.view.frame;
        
        IOS_VERSION_7_OR_ABOVE?[vc.view setFrame:CGRectMake(0, 0, rtFrame.size.width, rtFrame.size.height)]:[vc.view setFrame:CGRectMake(0, -kSysStatusBarHeight, rtFrame.size.width, rtFrame.size.height)];
    }
    
    if (_curSelIndex >= 0 && _curSelIndex < [_viewControllers count])
    {
        [self.view addSubview:((UIViewController *)[_viewControllers objectAtIndex:_curSelIndex]).view];
        [self.view bringSubviewToFront:_tabBar];
        
        [_tabBar highlightMenuItemAtIndex:_curSelIndex];
    }
}

#pragma mark - CMTabBarDelegate's methods
- (BOOL)tabBarShouldSelectedItem:(CMTabBar *)tabBar curItemTag:(NSInteger)itemTag
{
    BOOL bRet = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        UIViewController *vc = [_viewControllers objectAtIndex:itemTag];
        bRet = [_delegate tabBarController:self shouldSelectViewController:vc];
    }
    
    return bRet;
}

- (void)tabBarSelectedItemChanged:(CMTabBar *)tabBar curItemTag:(NSInteger)itemTag oldItemTag:(NSInteger)oldItemTag
{
    if (oldItemTag == itemTag)  // 允许返回根视图，点击同一item时，返回根视图
    {
        if (_isPopToRoot)
            [self doPopToRootViewController:itemTag];
        else
        {
            // 如果点击相同tabbaritem，不返回到root，则应用自行处理对应操作
            if (itemTag >= 0 && itemTag < [_viewControllers count] && self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:selectedTheSameTabBarItemOperation:)])
            {
                UIViewController *curSelVC = [_viewControllers objectAtIndex:itemTag];
                [self.delegate tabBarController:self selectedTheSameTabBarItemOperation:curSelVC];
            }
        }
    }
    
    if (oldItemTag != itemTag && itemTag >= 0 && itemTag < [_viewControllers count])
    {
        _curSelIndex = itemTag;
        
        if (oldItemTag >= 0 && oldItemTag < [_viewControllers count])
            [((UIViewController *)[_viewControllers objectAtIndex:oldItemTag]).view removeFromSuperview];
        
        [self.view addSubview:((UIViewController *)[_viewControllers objectAtIndex:itemTag]).view];
        [self.view bringSubviewToFront:_tabBar];
        
        [self performSelector:@selector(tabBarDidSelectItem:) withObject:[_viewControllers objectAtIndex:itemTag] afterDelay:.0];
        
//        if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5.0)       // iOS 5.0 以下 viewWillApper,viewWillDisappear等函数不调用问题修正
//        {
//            if (oldItemTag >= 0 && oldItemTag < [_viewControllers count])
//            {
//                UIViewController *oldVC = [_viewControllers objectAtIndex:oldItemTag];
//                if ([_viewControllers isKindOfClass:[UINavigationController class]])
//                    oldVC = [(UINavigationController *)[_viewControllers objectAtIndex:oldItemTag] topViewController];
//                
//                if ([oldVC respondsToSelector:@selector(viewWillDisappear:)])
//                    [oldVC viewWillDisappear:NO];
//            }
//
//            UIViewController *vc = [_viewControllers objectAtIndex:itemTag];
//            
//            if ([vc isKindOfClass:[UINavigationController class]])
//                vc = [(UINavigationController *)[_viewControllers objectAtIndex:itemTag] topViewController];
//            
//            if ([vc respondsToSelector:@selector(viewWillAppear:)])
//                [vc viewWillAppear:NO];
//            
//            [self performSelector:@selector(tabBarDidSelectItem:) withObject:[_viewControllers objectAtIndex:itemTag] afterDelay:.0];
//        }
    }
}

- (void)tabBarDidSelectItem:(UIViewController *)vc
{
    static UIViewController *lastController = nil;
    
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5.0)   // iOS 5.0 以下 viewDidAppear,viewDidDisappear函数不调用问题修正
//    {    
//        if (lastController)
//        {
//            UIViewController *tmpvc = lastController;
//            if ([lastController isKindOfClass:[UINavigationController class]])
//                tmpvc = [(UINavigationController *)lastController topViewController];
//            
//            if ([tmpvc respondsToSelector:@selector(viewDidDisappear:)])
//                [tmpvc viewDidDisappear:NO];
//        }
//        
//        lastController = vc;
//        UIViewController *didAppearVC = vc;
//        
//        if ([vc isKindOfClass:[UINavigationController class]])
//            didAppearVC = [(UINavigationController *)vc topViewController];
//        
//        [didAppearVC viewDidAppear:NO];
//    }
    
    if (lastController && _delegate && [_delegate respondsToSelector:@selector(tabBarController:removeSelectViewController:)])
        [_delegate tabBarController:self removeSelectViewController:lastController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
        [_delegate tabBarController:self didSelectViewController:vc];
}

@end

