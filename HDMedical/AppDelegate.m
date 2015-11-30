//
//  AppDelegate.m
//  HDMedical
//
//  Created by DEV_00 on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "AppDelegate.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "CMViewController.h"
#import "CMTabBarController.h"
#import "CommonDrawFunc.h"
#import "CommonGetPlistFunc.h"

static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
//    
//    /**
//     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
//     此方法必须在启动时调用，否则会限制SDK的使用。
//     **/
//    [ShareSDK registerApp:@"4c704ccb80aa"];
//    
//    
//    /**
//     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
//     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
//     **/
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
    
    // 设置ViewControllers
    CMTabBarController* tabBarController = [[CMTabBarController alloc] init];
    tabBarController.delegate = self;
    [tabBarController setTabBarSelectedIndex:0];
    [tabBarController setTabBarBGImage:[UIImage imageNamed:@"main_tabbar"]];
    //    [tabBarController setTabBarSelectedBGImage:[CommonDrawFunc retinaImageNamed:@"tray_menu_select_bg.png"]];
    tabBarController.viewControllers = [NSMutableArray arrayWithArray:[CommonGetPlistFunc getTabBarViewControllers]];
    self.window.rootViewController = tabBarController;
    
    // 首次操作指引
//    if ([DataEngine sharedDataEngine].isFirstInstruction) {
//        [self showCustomIntro];
//    }
    NSLog(@"adv URL =%@",[DataEngine sharedDataEngine].advImgURLStr);
//     [DataEngine sharedDataEngine].advImgURLStr = @"http://www.soomal.com/images/doc/20130613/00032080.jpg";
    // 启动广告图片
    CGRect rt  = [[UIScreen mainScreen] bounds];
    UIImageView * splashView = [[UIImageView alloc] initWithFrame:rt];
    [splashView setImageWithURL:[NSURL URLWithString:[DataEngine sharedDataEngine].advImgURLStr] placeholderImage:[UIImage imageNamed:@"start_load_default"]];
    [self.window addSubview:splashView];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view addSubview:splashView];
    [self performSelector:@selector(removeSplasImgView:) withObject:splashView afterDelay:2.0];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)removeSplasImgView:(UIImageView *)imgView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalADVImg object:nil];
    [imgView removeFromSuperview];
}

//-(void)showOpenAppViewWithOpenAppTime:(CGFloat)openApptime showOpenAppAdTime:(CGFloat)showAdtime
//{
//    if (self.showAdtime != defaultShowAdtime) {
//        self.showAdtime = showAdtime;
//    }
//    [ProjectAppDelegate.window addSubview:self];
//    if (self.openAppAdConfig.isAdvertismentViewShow) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.openAppAdView.alpha = 1;
//        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.showAdtime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self removeOpenAppView];
//        });
//    }else {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((openApptime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self removeOpenAppView];
//        });
//    }
//}

//由于SSO授权需要跳转到客户端进行授权验证，因此需要添加以下两个handleOpenURL:回调方法处理返回消息
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:nil];
//}
////
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[DataEngine sharedDataEngine] saveUserBaseInfoData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[DataEngine sharedDataEngine] saveUserBaseInfoData];
}

#pragma mark - showCustomIntro

- (void)showCustomIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.titlePositionY = 240;
    page1.desc = sampleDescription1;
    page1.descPositionY = 220;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    page1.titleIconPositionY = 100;
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 240;
    page2.desc = sampleDescription2;
    page2.descPositionY = 220;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon1"]];
    page2.titleIconPositionY = 260;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titlePositionY = 240;
    page3.desc = sampleDescription3;
    page3.descPositionY = 220;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon2"]];
    page3.titleIconPositionY = 260;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.titlePositionY = 240;
    page4.desc = sampleDescription4;
    page4.descPositionY = 220;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon3"]];
    page4.titleIconPositionY = 260;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame: ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view.bounds andPages:@[page1,page2,page3,page4]];
    intro.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigLogo"]];
    intro.titleViewY = 120;
    intro.tapToNext = YES;
    [intro setDelegate:self];
    
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageDot"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"selectedPageDot"];
    [pageControl sizeToFit];
    intro.pageControl = (UIPageControl *)pageControl;
    intro.pageControlY = 130.f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 270, 50)];
    intro.skipButton = btn;
    intro.skipButtonY = 80.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    
    [intro showInView: ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view animateDuration:0.0];
    
    
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    
    [DataEngine sharedDataEngine].isFirstInstruction = NO;
 }

#pragma mark - CMTabBarControllerDelegate delegate
// CMTabBarController选中当前的viewController
- (void)tabBarController:(CMTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController * naVC = (UINavigationController *) viewController;
    [(CMViewController *)naVC.topViewController didSelectedTabBarItem];
}


@end
