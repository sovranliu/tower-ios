//
//  CMViewController.h
//  LeCakeIphone
//
//  Created by David on 14-10-21.
//  Copyright (c) 2014年 NX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Customizer.h"
#import "CMTabBar.h"
#import "CommonDrawFunc.h"
#import "CommonDefine.h"
#import "DataEngine.h"
#import "MBProgressHUD.h"

//@class TabBarItem;

@interface CMViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic, strong) TabBarItem *cMTabBarItem;     // CMViewController 对应的TabBarItem信息，如果CMViewController关联到CMTabBar控件，需要设置此属性，否则为nil
@property (nonatomic, assign) NSInteger tabBarIndex;        // 用于 FMWKTypeSideMenu 类型 (Path界面风格，如果有CMTabBar控件，此属性对应CMTabBar中对应的TabBarItem项)
@property (nonatomic, assign) BOOL showNav;                 // CMViewController导航栏显示状态, 默认YES
@property (nonatomic, assign) BOOL resident;                // 用于 FMWKTypeSideMenu 类型 (Path界面风格，如果resident为YES, 此CMViewController会常驻内存;默认状态为NO,页面移除会释放内存)

/**************************************************************************
 FunctionName:  initExtendedData
 FunctionDesc:  扩展的初始化数据(子类继承时,子类初始化数据处理可在此函数中进行数据初始化)
 Parameters:    NONE
 ReturnVal:     NONE
 **************************************************************************/
- (void)initExtendedData;

/**************************************************************************
 FunctionName:  loadUIData
 FunctionDesc:  界面加载(子类继承时,子类扩展界面加载可在此函数中进行)
 Parameters:    NONE
 ReturnVal:     NONE
 **************************************************************************/
- (void)loadUIData;

/**************************************************************************
 FunctionName:  receiveLowMemoryWarning
 FunctionDesc:  内存告警调用
 Parameters:    NONE
 ReturnVal:     NONE
 **************************************************************************/
- (void)receiveLowMemoryWarning;

/**************************************************************************
 FunctionName:  vcMsgCenterProcess
 FunctionDesc:  通讯返回数据通知函数
 Parameters:    notification:NSNotification
 ReturnVal:     NONE
 **************************************************************************/
- (void)vcMsgCenterProcess:(NSNotification *)notification;

/**************************************************************************
 FunctionName:  vcMsgThemeChange
 FunctionDesc:  UI换肤信息通知函数
 Parameters:    notification:NSNotification
 ReturnVal:     NONE
 **************************************************************************/
- (void)vcMsgThemeChange:(NSNotification *)notification;

/**************************************************************************
 FunctionName:  setHiddenTabBarView
 FunctionDesc:  是否隐藏TabBarItem所属的TabBarView(如果TabBarItem父视图TabBarView为nil,则设置无效)
 Parameters:    isHidden:BOOL
 ReturnVal:     NONE
 **************************************************************************/
- (void)setHiddenTabBarView:(BOOL)isHidden;

/**
 *  push到navigationController指定类名对应的controller
 *
 *  @param targetName 指定类名
 *  @param animated   是否有动画效果
 *
 *  @return 对应的controller
 */
- (UIViewController*)popToTargetControllerByName:(NSString *)targetName animated:(BOOL)animated;

/**
 *  push到navigationController指定类名对应的controller,默认没有动画
 *
 *  @param targetName 指定类名
 *
 *  @return 对应的controller
 */
- (UIViewController*)popToTargetControllerByName:(NSString *)targetName;

/**************************************************************************
 FunctionName:  createTabBarItem
 FunctionDesc:  创建VC下面的tabBar
 Parameters:    isHidden:BOOL
 ReturnVal:     NONE
 **************************************************************************/
- (void)createTabBarItem:(NSString *)title iconImgName:(NSString *)iconImgName selIconImgName:(NSString *)selIconImgName;
/**
 *  http请求达到后刷新指定页面
 *
 *  @param vc 指定哪个vc刷新 
 *  @param responseData 返回的json数据
 *  @param tag 用一个页面有类似请求，用这个tag来区分标识
 *
 *
 */
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag;

/**
 *  http请求达到后解析指定页面
 *
 *  @param vc 指定哪个vc刷新
 *  @param jsonData 返回的json数据
 *  @param tag 用一个页面有类似请求，用这个tag来区分标识
 *
 *
 */
- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag;

/**
 *  http请求错误
 *
 *  @param vc 指定哪个vc请求
 *  @param error error数据
 *  @param tag 用一个页面有类似请求，用这个tag来区分标识
 *
 *
 */
- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag;

/**
 *  点击下面tabBarItem,可以用以刷新当前的VC做些事情
 *
 */
- (void)didSelectedTabBarItem;

@end
