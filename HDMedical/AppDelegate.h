//
//  AppDelegate.h
//  HDMedical
//
//  Created by DEV_00 on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "CMTabBarController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "SMPageControl.h"
#import "UIImageView+WebCache.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CMTabBarControllerDelegate,EAIntroDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

