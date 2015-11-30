//
//  HDMainViewController.m
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMainViewController.h"
#import "UIView+Positioning.h"
#import "UIImageView+WebCache.h"
#import "TOWebViewController.h"
#import "LoadingView.h"
#import "MedicalNewsTableViewCell.h"
#import "HDLoginViewController.h"
#import "CMTabBarController.h"
#import "KxMenu.h"
#import "HDChooseDoctorViewController.h"
#import "KHDMessageCenterViewController.h"
#import "HDPhysicalExaminationViewController.h"
#import "JSONFormatFunc.h"
#import "JKAlertDialog.h"
#import "HDSelectCityAndRegionViewController.h"

#define headTableView_Height     (kScreenW - 50)/3.0 + 254

@interface HDMainViewController ()

- (void)initAdvUI:(UIView *)tableHeadView;
- (void)initsearchField:(UIView *)tableHeadView;
- (void)initThreeBanner:(UIView *)tableHeadView;
- (void)inithdMainTableView;

- (void)rightBtnAction:(id)sender;
- (void)midBtnAction:(id)sender;
- (void)leftBtnAction:(id)sender;

@end

@implementation HDMainViewController
@synthesize imagePlayerView;
@synthesize hdMainTableView;
@synthesize mediclalNewArray;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"首页";
        self.showNav    = YES;
        self.resident   = YES;
        [self createTabBarItem:self.title iconImgName:@"home_footbar_icon_shouye" selIconImgName:@"home_footbar_icon_shouye_pressed"];
        //[self createTabBarItem:self.title iconImgName:nil selIconImgName:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalhasMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalAlreadLogout object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalADVImg object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalSelectedCityAndRegion object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)initExtendedData
{
    self.mediclalNewArray = [[NSMutableArray alloc] init];
    self.newsArray = [[NSMutableArray alloc] init];
    self.pages = 1;
    self.pageend = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasMessageAction:)
                                                 name:KHDMedicalhasMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadLogoutAction:)
                                                 name:KHDMedicalAlreadLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(advHaveRemovedAction:)
                                                 name:KHDMedicalADVImg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectedCityAndRegionAction:)
                                                 name:KHDMedicalSelectedCityAndRegion object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(pullHasMessage:) userInfo:nil repeats:YES];
    //每2秒运行一次function方法。
    
    // 0 请求启动图片
    NSMutableString * baseUrl0 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl0 appendString:KHDMedicalstartupImage];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl0 userInfo:nil withReqTag:6];
    
    // 1 请求首页广告
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicalBanner];
    
    
    NSString * regionID = [NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]];
    // 参数封装
    NSMutableDictionary * totalParamDic0 =[[NSMutableDictionary alloc] initWithCapacity:1];
   [totalParamDic0 setObject:regionID forKey:@"regionId"];
    
    
    if ([regionID length] > 0 && ![regionID isEqualToString:@"0"])
    {
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic0 withReqTag:1];
    }

    // 2 请求新闻
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalNews];
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pages] forKey:@"page"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:2];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHiddenTabBarView:NO];
    
    [self.timer fire];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化广告UI

//- (void)initRegionTableView
//{
////    self.regionTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 4.0*kScreenW/5.0, 3.0*kScreenH/5.0) style:UITableViewStylePlain];
////    self.regionTableView.delegate = self;
////    self.regionTableView.dataSource = self;
//    
//    HDSelectCityAndRegionViewController * crvc = [[HDSelectCityAndRegionViewController alloc] init];
//    self.scrcVC = crvc;
//    
//    
//}


- (void)initAdvUI:(UIView *)tableHeadView
{
    self.imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    
    self.imagePlayerView.imagePlayerViewDelegate = self;
    self.imagePlayerView.scrollInterval = 4.0f;
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    self.imagePlayerView.hidePageControl = NO;
    
    // adjust edgeInset
    //self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
    //UIView * tableHeadView = [self.view viewWithTag:kHDMedicalObjectTagNum3];
    [tableHeadView addSubview:self.imagePlayerView];
}

#pragma mark - 初始化搜索框
- (void)initsearchField:(UIView *)tableHeadView
{
    // 搜索的主View
    UIView * searchMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    [searchMainView setTag:kHDMedicalObjectTagNum2];
    [searchMainView setY:self.imagePlayerView.y+self.imagePlayerView.height];
    [searchMainView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, kScreenW-30, 50)];
    [imgView setImage:[UIImage imageNamed:@"main_search"]];
    [searchMainView addSubview:imgView];
    //[imgView centerToParent];
    
    //UIView * tableHeadView = [self.view viewWithTag:kHDMedicalObjectTagNum3];
    [tableHeadView addSubview:searchMainView];
//    [self.view addSubview:searchMainView];
    
    // 搜索文本框
    UITextField * displayTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW-80, 28)];
    [displayTF setTag:kHDMedicalObjectTagNum1];
    [displayTF setFont:[UIFont systemFontOfSize:15]];
    [displayTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [displayTF setPlaceholder:@"搜索疾病"];
    [displayTF setClearButtonMode:UITextFieldViewModeAlways];
    [displayTF setBorderStyle:UITextBorderStyleNone];
    [displayTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [displayTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [displayTF setKeyboardType:UIKeyboardTypeDefault];
    [displayTF setReturnKeyType:UIReturnKeySearch];
    [displayTF setMinimumFontSize:13];
    [displayTF setDelegate:self];
    [displayTF setAutoresizesSubviews:YES];
    [displayTF setBackgroundColor:[UIColor clearColor]];
    [displayTF setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [searchMainView addSubview:displayTF];
    [displayTF setX:50];
    [displayTF setCenterY:imgView.centerY];
    //[displayTF centerToParent];
    

}

- (void)initThreeBanner:(UIView *)tableHeadView
{
    // 三个Banner主View
    UIView * twoBannerMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenW - 50)/3.0 + 20)];
    UIView * searchMainView = [tableHeadView viewWithTag:kHDMedicalObjectTagNum2];
    [twoBannerMainView setY:searchMainView.y+searchMainView.height];
    [twoBannerMainView setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView * leftImgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_threebanner_bg"]];
    [leftImgBG setFrame:CGRectMake(0, 0, (kScreenW - 50)/3.0, (kScreenW - 50)/3.0)];
    [leftImgBG setX:15];
    [leftImgBG setTop:10];
    
    UIImageView * midImgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_threebanner_bg"]];
    [midImgBG setFrame:CGRectMake(0, 0, (kScreenW - 50)/3.0, (kScreenW - 50)/3.0)];
    [midImgBG setX:leftImgBG.x + leftImgBG.width + 10];
    [midImgBG setTop:10];
    
    
    UIImageView * rightImgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_threebanner_bg"]];
    [rightImgBG setFrame:CGRectMake(0, 0, (kScreenW - 50)/3.0, (kScreenW - 50)/3.0)];
    [rightImgBG setRight:kScreenW - 15];
    [rightImgBG setTop:10];
    
    [twoBannerMainView addSubview:leftImgBG];
    [twoBannerMainView addSubview:midImgBG];
    [twoBannerMainView addSubview:rightImgBG];

    
    //在线问诊
    UIImageView * onlineAskDocBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_online_doc"]];
    [onlineAskDocBG setFrame:CGRectMake(0, 0, 40, 50)];
    [leftImgBG addSubview:onlineAskDocBG];
    [onlineAskDocBG centerToParent];
    [onlineAskDocBG setCenterY:onlineAskDocBG.center.y - 13];
    
    UILabel * onlineAskDocLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [onlineAskDocLabel setFont:[UIFont systemFontOfSize:14.0]];
    [onlineAskDocLabel setBackgroundColor:[UIColor clearColor]];
    [onlineAskDocLabel setTextColor:[UIColor colorWithRed:252.0/255.0 green:112.0/255.0 blue:51.0/255.0 alpha:1.0]];
    [onlineAskDocLabel setTextAlignment:NSTextAlignmentCenter];
    [onlineAskDocLabel setText:@"在线问诊"];
    [leftImgBG addSubview:onlineAskDocLabel];
    [onlineAskDocLabel centerToParent];
    [onlineAskDocLabel setCenterY:onlineAskDocLabel.center.y + 30];
    
    //预约就诊
    UIImageView * askDocBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_ready_doc"]];
    [askDocBG setFrame:CGRectMake(0, 0, 40, 50)];
    [midImgBG addSubview:askDocBG];
    [askDocBG centerToParent];
    [askDocBG setCenterY:askDocBG.center.y - 10];
    
    UILabel * askDocLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [askDocLabel setFont:[UIFont systemFontOfSize:14.0]];
    [askDocLabel setBackgroundColor:[UIColor clearColor]];
    [askDocLabel setTextColor:[UIColor colorWithRed:252.0/255.0 green:112.0/255.0 blue:51.0/255.0 alpha:1.0]];
    [askDocLabel setTextAlignment:NSTextAlignmentCenter];
    [askDocLabel setText:@"预约就诊"];
    [midImgBG addSubview:askDocLabel];
    [askDocLabel centerToParent];
    [askDocLabel setCenterY:askDocLabel.center.y + 30];
    
    
    //名医就诊
    UIImageView * bjPlanBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_famous_doc"]];
    [bjPlanBG setFrame:CGRectMake(0, 0, 40, 50)];
    [rightImgBG addSubview:bjPlanBG];
    [bjPlanBG centerToParent];
    [bjPlanBG setCenterY:bjPlanBG.center.y - 13];
    
    UILabel * bjPlanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [bjPlanLabel setFont:[UIFont systemFontOfSize:14.0]];
    [bjPlanLabel setBackgroundColor:[UIColor clearColor]];
    [bjPlanLabel setTextColor:[UIColor colorWithRed:252.0/255.0 green:112.0/255.0 blue:51.0/255.0 alpha:1.0]];
    [bjPlanLabel setTextAlignment:NSTextAlignmentCenter];
    [bjPlanLabel setText:@"名医问诊"];
    [rightImgBG addSubview:bjPlanLabel];
    [bjPlanLabel centerToParent];
    [bjPlanLabel setCenterY:bjPlanLabel.center.y + 30];
    
    // 三button
    
    UIButton * middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleBtn setFrame:leftImgBG.frame];
    [middleBtn setBackgroundColor:[UIColor clearColor]];
    [middleBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:rightImgBG.frame];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:midImgBG.frame];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn addTarget:self action:@selector(midBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [twoBannerMainView addSubview:leftBtn];
    [twoBannerMainView addSubview:middleBtn];
    [twoBannerMainView addSubview:rightBtn];
    
   // UIView * tableHeadView = [self.view viewWithTag:kHDMedicalObjectTagNum3];
    [tableHeadView addSubview:twoBannerMainView];
    
//    [self.view addSubview:twoBannerMainView];
}

- (void)initGapBgView:(UIView *)tableHeadView
{
    UIView * gapBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    [gapBgView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [gapBgView setBottom:tableHeadView.height -30];
    [tableHeadView addSubview:gapBgView];
}

- (void)initNewsTitle:(UIView *)tableHeadView
{
    UILabel * newsTitleLable   = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW -20, 30)];
    [newsTitleLable setBottom:tableHeadView.height];
    [newsTitleLable setText:@"最新医讯"];
    [newsTitleLable setFont:[UIFont systemFontOfSize:20]];
    [newsTitleLable setTextColor:[UIColor blackColor]];
    [newsTitleLable setTextAlignment:NSTextAlignmentLeft];
    [newsTitleLable setBackgroundColor:[UIColor whiteColor]];
    [tableHeadView addSubview:newsTitleLable];
}

- (void)inithdMainTableView
{
    self.hdMainTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49) style:UITableViewStylePlain];
    [self.hdMainTableView setArrowImage:[UIImage imageNamed:@"refresh_up"] arrowDownImage:[UIImage imageNamed:@"refresh_down"]];
    self.hdMainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.hdMainTableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0f];
    self.hdMainTableView.delegate = self;
    self.hdMainTableView.dataSource = self;
    [self.hdMainTableView setPullingDelegate:self];
    [self.hdMainTableView setEnableFooterPull:YES];
    [self.hdMainTableView setEnableHeaderPull:NO];
    //self.hdMainTableView.headerView.stateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.hdMainTableView.footerView.stateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.hdMainTableView.showsVerticalScrollIndicator = NO;
}

- (void)initLoginNavigationItem
{
/*
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([DataEngine sharedDataEngine].isLogin)
        [logBtn setBackgroundImage:[UIImage imageNamed:@"islogin"] forState:UIControlStateNormal];
    else
        [logBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    
    
    logBtn.tag = 101;
    [logBtn setFrame:CGRectMake(15, 5, 35, 35)];
    [logBtn addTarget:self action:@selector(logBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logBtn];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
 */
    
    
/*
//    UIView * rightNavItemView = [[UIView alloc] init];
//    [rightNavItemView setFrame:CGRectMake(0, 0, 85, 40)
//     ];
//    [rightNavItemView setBackgroundColor:[UIColor clearColor]];
//    
//    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [calculateBtn setBackgroundImage:[CommonDrawFunc retinaImageNamed:@"compute.png"] forState:UIControlStateNormal];
//    [calculateBtn setFrame:CGRectMake(0, 0, 35, 35)];
//    [calculateBtn addTarget:self action:@selector(calculateBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [findBtn setBackgroundImage:[CommonDrawFunc retinaImageNamed:@"search.png"] forState:UIControlStateNormal];
//    [findBtn setFrame:CGRectMake(40, 0, 35, 35)];
//    [findBtn addTarget:self action:@selector(findBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [rightNavItemView addSubview:calculateBtn];
//    [rightNavItemView addSubview:findBtn];
//    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavItemView];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
*/
    
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];

    
    //小区 demo 左边
    self.directBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[DataEngine sharedDataEngine].selectedRegionName length] >0)
    {
        
        [self.directBtn setTitle:[DataEngine sharedDataEngine].selectedRegionName forState:UIControlStateNormal];
    }else
    {
        [self.directBtn setTitle:@"选择小区" forState:UIControlStateNormal];
    }

    [self.directBtn.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    self.directBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.directBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.directBtn setBackgroundColor:[UIColor clearColor]];
    self.directBtn.tag = 101;
    [self.directBtn setFrame:CGRectMake(0, 0, 60, 40)];
    [self.directBtn addTarget:self action:@selector(logBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.directBtn setBackgroundImage:[UIImage imageNamed:@"mian_leftnav_item"] forState:UIControlStateNormal];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.directBtn];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    
    // 右边
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rightBtn setBackgroundColor:[UIColor clearColor]];
    self.rightBtn.tag = 102;
    [self.rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [self.rightBtn addTarget:self action:@selector(messageCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"main_rightnav_item"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)leftBtnAction:(id)sender
{
    NSLog(@"leftBtnAction");
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
    
    
    
    NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
    
    if ([cityID length] >0)
    {
        HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
        chooseDocVC.doctorLevel = 2;
        chooseDocVC.doctorServices = @"reserve";
        [self.navigationController pushViewController:chooseDocVC animated:YES];
        [self setHiddenTabBarView:YES];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag= 1;
        [alertView show];
    }
    
    
//    HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
//    chooseDocVC.doctorLevel = 2;
//    chooseDocVC.doctorServices = @"reserve";
//    [self.navigationController pushViewController:chooseDocVC animated:YES];
//    [self setHiddenTabBarView:YES];
}

- (void)midBtnAction:(id)sender
{
    NSLog(@"midBtnAction");
    
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];

    
    NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
    
    if ([cityID length] >0)
    {
        HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
        chooseDocVC.doctorLevel = 2;
        chooseDocVC.doctorServices = @"inquiry";
        [self.navigationController pushViewController:chooseDocVC animated:YES];
        [self setHiddenTabBarView:YES];

    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag= 1;
        [alertView show];
    }
    
    
//    HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
//    chooseDocVC.doctorLevel = 2;
//    chooseDocVC.doctorServices = @"inquiry";
//    [self.navigationController pushViewController:chooseDocVC animated:YES];
//    [self setHiddenTabBarView:YES];
    
}
- (void)rightBtnAction:(id)sender
{
    NSLog(@"rightBtnAction");
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
    
    NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
    
    if ([cityID length] >0)
    {
        HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
        chooseDocVC.doctorLevel = 1;
        chooseDocVC.doctorServices = @"inquiry";
        [self.navigationController pushViewController:chooseDocVC animated:YES];
        [self setHiddenTabBarView:YES];
        
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag= 1;
        [alertView show];
    }
    
    
//    HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
//    chooseDocVC.doctorLevel = 1;
//    chooseDocVC.doctorServices = @"inquiry";
//    [self.navigationController pushViewController:chooseDocVC animated:YES];
//    [self setHiddenTabBarView:YES];
}

- (void)messageCenterAction:(id)sender
{
    
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
    
    if (![DataEngine sharedDataEngine].isLogin) {
        HDLoginViewController  * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
        
    }else
    {
        KHDMessageCenterViewController * messageCenter = [[KHDMessageCenterViewController alloc] init];
        [self setHiddenTabBarView:YES];
        [self.navigationController pushViewController:messageCenter animated:YES];
    }
}

- (void)logBtnAction:(UIButton *)sender
{
    NSLog(@"directBtnAction");
    
    
    HDSelectCityAndRegionViewController * loginVC = [[HDSelectCityAndRegionViewController alloc] init];
    loginVC.showBackBtnFlag = YES;
    UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
    
 
    /*
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
    
    
        if ([self.regionArray count] > 0)
        {
            NSMutableArray *menuItems = [NSMutableArray array];
            
            for (int i = 0; i<[self.regionArray count]; i ++)
            {
                NSString * resgionName = [[self.regionArray objectAtIndex:i] objectForKey:@"name"];
                NSString * cityId = [[self.regionArray objectAtIndex:i] objectForKey:@"cityId"];
                [menuItems addObject:[KxMenuItem menuItem:resgionName
                                                   cityId:cityId
                                                    image:nil
                                                   target:self
                                                   action:@selector(pushMenuItem:)]];
            }
            
            [KxMenu showMenuInView:self.view
                          fromRect:CGRectMake(0, 0, 60, 1)
                         menuItems:menuItems];
        }else
        {
            
            NSString * deviceToken = @"";
            if ([[DataEngine sharedDataEngine].deviceToken length] > 0)
                deviceToken = [DataEngine sharedDataEngine].deviceToken;
            
            
            // 3请求小区
            NSMutableString * baseUrl2 = [NSMutableString stringWithString:KHDMedicalBaseURL];
            [baseUrl2 appendString:kHDMedicalregionList];
            // 参数封装
            NSMutableDictionary * totalParamDic1 =[[NSMutableDictionary alloc] initWithCapacity:1];
            [totalParamDic1 setObject:deviceToken forKey:@"token"];
            // 发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl2 userInfo:totalParamDic1 withReqTag:3];
        }
*/
}


- (void)loadUIData
{
    
    // 初始化headTableView
    UIView * headTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, headTableView_Height)];
    [headTableView setBackgroundColor:[UIColor whiteColor]];
    headTableView.tag = kHDMedicalObjectTagNum3;
    
    // 设置登录按钮
    [self initLoginNavigationItem];
    
    // 设置下拉刷新tableView
    [self inithdMainTableView];
    
    // 设置广告
    [self initAdvUI:headTableView];
    
    // 设置搜索框
    [self initsearchField:headTableView];

    // 设置三个Banner
    [self initThreeBanner:headTableView];
    
    // 设置背景色gap
    [self initGapBgView:headTableView];
    
    // 设置新闻title
    [self initNewsTitle:headTableView];
    

    
    
    self.hdMainTableView.tableHeaderView = headTableView;
    [self.view addSubview:self.hdMainTableView];
    
    // 设置searchView
    [self initSearchView];
    
    // 设置首次启动选择小区
//    [self initRegionTableView];
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];

}

//- (void)endEdit
//{
//    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
//    [subView resignFirstResponder];
//}




- (void)didSelectedTabBarItem
{
    NSLog(@"didSelectedTabBarItem =%@",self);
}


- (void)hasMessageAction:(id)sender
{
    NSLog(@"hasMessageAction");
}


- (void)pullHasMessage:(id)sender
{
//    // 1 请求参数
//    NSLog(@"60s 拉去一下有无消息");
    
    if([[DataEngine sharedDataEngine].deviceToken length] > 0)
    {
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
        [baseUrl appendString:@"/"];
        [baseUrl appendString:KHDMedicalhasMessage];
        
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:4];
    }


}

- (void)selectedCityAndRegionAction:(NSNotification *)sender
{
    NSLog(@"selectedCityAndRegionAction");
    [self.directBtn setTitle:[DataEngine sharedDataEngine].selectedRegionName forState:UIControlStateNormal];
    
    
    NSNumber * showBackFlag = [[sender object] objectForKey:@"showBackFlag"];
    
    if (![showBackFlag boolValue])
    {
        
        // 1 请求首页广告
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl appendString:KHDMedicalBanner];
        
        NSString * regionID = [NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]];
        // 参数封装
        NSMutableDictionary * totalParamDic0 =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic0 setObject:regionID forKey:@"regionId"];
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic0 withReqTag:1];
//        
//        if ([regionID length] == 0)
//        {
//            // 发送数据
//            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:nil withReqTag:1];
//        }else
//        {
            // 发送数据
//            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic0 withReqTag:1];
//        }
    }

}

- (void)advHaveRemovedAction:(NSNotification *)sender
{
    // 用户首次登陆选择所在的小区
    NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
    if ([cityID length] ==0)
    {
//        // 3请求小区
//        NSMutableString * baseUrl2 = [NSMutableString stringWithString:KHDMedicalBaseURL];
//        [baseUrl2 appendString:kHDMedicalregionList];
//        // 参数封装
//        NSMutableDictionary * totalParamDic1 =[[NSMutableDictionary alloc] initWithCapacity:1];
//        [totalParamDic1 setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
//        // 发送数据
//        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl2 userInfo:totalParamDic1 withReqTag:3];
        
        HDSelectCityAndRegionViewController * loginVC = [[HDSelectCityAndRegionViewController alloc] init];
        loginVC.showBackBtnFlag = NO;
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
        
    }
}

- (void)alreadLogoutAction:(NSNotification *)sender
{
    [self.directBtn setTitle:@"选择小区" forState:UIControlStateNormal];
}

- (void)initSearchView
{
    self.hiddenKeyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.hiddenKeyBoardView setBackgroundColor:[UIColor whiteColor]];
    self.hiddenKeyBoardView.alpha = 0.02;
    [self.hiddenKeyBoardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    self.hiddenKeyBoardView.hidden = YES;
    [self.view addSubview:self.hiddenKeyBoardView];
    
}

-(void)endEdit
{
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    self.hiddenKeyBoardView.hidden = NO;
}

- (void)keyboardWillHidden:(NSNotification *)note
{
    self.hiddenKeyBoardView.hidden = YES;
}

////页面消失，进入后台不显示该页面，关闭定时器
//-(void)viewDidDisappear:(BOOL)animated
//{
//    //关闭定时器
//    //    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.timer invalidate];
//    self.timer = nil;
//}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageAndAdvURLArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary * dic = [self.imageAndAdvURLArray objectAtIndex:index];
    NSString * urlStr =  [dic objectForKey:@"image"];
    NSURL * strUrl = [NSURL URLWithString:urlStr];
    
    [imageView setImageWithURL:strUrl placeholderImage:[UIImage imageNamed:@"main_adv_default"]];
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
 //   NSString * urlStr = [self.advURLs objectAtIndex:index];
    
    UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
    [subView resignFirstResponder];
    
    NSDictionary * dic = [self.imageAndAdvURLArray objectAtIndex:index];
    NSString * urlStr =  [dic objectForKey:@"url"];
    
    TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:urlStr];
    [self setHiddenTabBarView:YES];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kHDMedicalObjectTagNum1) {
        [textField resignFirstResponder];
        // to do someting work
        
        
        NSLog(@"didSelectRow");
        NSString * textContent = textField.text;
        
        
        
        // 检查疾病
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:KHDMedicalsearch];
        [baseUrl1 appendFormat:@"?disease=%@",[textContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:baseUrl1];
        [self setHiddenTabBarView:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];
        
    }
    return YES;
}

#pragma mark -  PullingRefreshTableViewScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.hdMainTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.hdMainTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
// 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //    if ([self.wisdomListData count]>0)
    //    {
    //        [self.wisdomListData removeAllObjects];
    //    }
    //    pageNumber = 0;
    //    [self request2972Type155:1+pageNumber*10 EndIndex:10+pageNumber*10];
    NSLog(@"pullingTableViewDidStartRefreshing");
}

// 上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    NSLog(@"pullingTableViewDidStartLoading");
    
    
    if (!self.pageend)
    {
        // 2 请求新闻参数
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:KHDMedicalNews];
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pages] forKey:@"page"];
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:2];
        
        self.hdMainTableView.reachedTheEnd  = NO;
        [self.hdMainTableView tableViewDidFinishedLoading];
    }else
    {

        self.hdMainTableView.reachedTheEnd  = YES;
        [self.hdMainTableView tableViewDidFinishedLoading];

    }
    
    
    NSLog(@"pullingTableViewDidStartLoading");
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        NSString *cellIdentifierStr = @"BasicInforIdentifier";
        
        MedicalNewsTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
        if (tableCell == nil)
        {
            tableCell = [[MedicalNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
        
        if ([self.newsArray count] > 0)
        {
            // 图片URL
            NSString * imgsURLstr = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
            [tableCell.leftNewSImgsView setImageWithURL:[NSURL URLWithString:imgsURLstr] placeholderImage:[UIImage imageNamed:@"main_news_default"]];
            
            // 新闻摘要
            NSString * abstractsStr = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            
            [tableCell.newsHeadLineLable setText:abstractsStr];
            CGRect  titleRect = [tableCell.newsHeadLineLable.text boundingRectWithSize:CGSizeMake(kScreenW - 114,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            [tableCell.newsHeadLineLable setFrame:CGRectMake(tableCell.newsHeadLineLable.frame.origin.x, tableCell.newsHeadLineLable.frame.origin.y, titleRect.size.width, titleRect.size.height)];
            
            // 新闻出处
            NSString * publisherStr = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"publisher"];
            [tableCell.newsSourceLable setText:publisherStr];
            
            // 新闻时间
            NSString * dataStr = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"date"];
            [tableCell.newsTimeLable setText:dataStr];
            
        }
        
        return tableCell;

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITextField *subView = (UITextField *)[self.view  viewWithTag:kHDMedicalObjectTagNum1];
        [subView resignFirstResponder];
        
        NSString * urlStr = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:urlStr];
        [self setHiddenTabBarView:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//#pragma mark - pushMenuItemDelegate
//- (void) pushMenuItem:(id)sender
//{
//    KxMenuItem * item = (KxMenuItem *)sender;
//    NSLog(@"title%@,cityid = %@", item.title,item.regisonCityId);
//    [self.directBtn setTitle:item.title forState:UIControlStateNormal];
//    [DataEngine sharedDataEngine].selectedRegion = item.title;
//    [DataEngine sharedDataEngine].selectedCityId = item.regisonCityId;
//    
//}
//#pragma mark - CMDropListDelegate
//- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
//{
//    NSLog(@"%ld -- %ld", column, row);
//}
#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self && tag == 1 && [responseData isKindOfClass:[NSDictionary class]] )
    {
        //        NSLog(@"responseData= %@",responseData);
        //
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * imgsArray =[JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [imgsArray count] >0)
        {
            self.imageAndAdvURLArray = [NSMutableArray arrayWithArray:imgsArray];
            [self.imagePlayerView reloadData];
        }
    }else if (vc == self && tag == 2 && [responseData isKindOfClass:[NSDictionary class]] )
    {
        NSLog(@"responseData= %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * imgsArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [imgsArray count] >0)
        {
            [self.newsArray addObjectsFromArray:imgsArray];
            [self.hdMainTableView reloadData];
            
            //为第二页请求做准备
            self.pages ++;
            
        }else if (code == 1 && [imgsArray count] == 0)
        {
            self.pageend = YES;
            
            self.hdMainTableView.reachedTheEnd  = YES;
            
            [UIView animateWithDuration:kPRAnimationDuration animations:^{
                self.hdMainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL bl){
            }];
            
        }
        
    }
//    else if (vc == self && tag == 3 && [responseData isKindOfClass:[NSDictionary class]])
//    {
//        NSLog(@"responseData =%@",responseData);
//        
//        int code = [[responseData objectForKey:@"code"] intValue];
//        NSArray * regionArraytmp = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
//        if (code == 1 && [regionArraytmp count] >0)
//        {
//            [self.regionArray removeAllObjects];
//            self.regionArray = [NSMutableArray arrayWithArray:regionArraytmp];
//            
//            // 用户首次登陆选择所在的小区
//            NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
//            if ([cityID length] ==0)
//            {
//                
//                HDSelectCityAndRegionViewController * crvc = [[HDSelectCityAndRegionViewController alloc] init];
//                crvc.showBackBtnFlag = NO;
//                [self.navigationController pushViewController:crvc animated:YES];
//                
//            }
//            
//        }
//    }
    else if (vc == self && tag == 4 && [responseData isKindOfClass:[NSDictionary class]])
    {
        
        int code =[[JSONFormatFunc numberValueForKey:@"code" ofDict:responseData] intValue];
        int redNewsCount = [[JSONFormatFunc numberValueForKey:@"data" ofDict:responseData] intValue];
        if (code == 1 && redNewsCount > 0)// 有消息，显示红点
        {
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"main_rightnav_item_red"] forState:UIControlStateNormal];
        }else // 没有消息，不显示红点
        {
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"main_rightnav_item"] forState:UIControlStateNormal];
        }
    }
    else if (vc == self && tag == 6 && [responseData isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"广告图url =%@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
          NSString * imgURLStr = [JSONFormatFunc strValueForKey:@"data" ofDict:responseData];
        if(code == 0)
        {
            [DataEngine sharedDataEngine].advImgURLStr = imgURLStr;
        }
        
    }
}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    NSLog(@"err =%@",error.description);
}


@end
