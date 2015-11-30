//
//  HDMineViewController.m
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMineViewController.h"
#import "UIView+Positioning.h"
#import "HDHealthRecordsViewController.h"
#import "HDMyFamilyViewController.h"
#import "HDLoginViewController.h"
#import "HDMineInfoViewController.h"
#import "HDMedicalMyYuYueViewController.h"
#import "HDMyMoneyPackViewController.h"
#import "HDHealthManageViewController.h"
#import "HDMyYuYueViewController.h"
#import "TOWebViewController.h"
#import "HDAboutUsViewController.h"
#import "JSONFormatFunc.h"

@interface HDMineViewController ()
- (void)initMineTableView;
- (void)initHeadView;
@end

@implementation HDMineViewController
@synthesize mineTableView;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的";
        self.showNav    = YES;
        self.resident   = YES;
        [self createTabBarItem:@"我的" iconImgName:@"home_footbar_icon_mine" selIconImgName:@"home_footbar_icon_mine_pressed"];
        //[self createTabBarItem:self.title iconImgName:nil selIconImgName:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalAlreadLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalAlreadLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalNameFixed object:nil];

}

- (void)initExtendedData
{
    
    self.html5Array = [NSMutableArray array];
    self.localArray = [NSMutableArray array];
    

    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"health_history",@"image", @"健康管理",@"name",nil];
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"my_family",@"image", @"我的家庭",@"name",nil];
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"my_money",@"image", @"我的钱包",@"name",nil];
    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_ask",@"image", @"我的问诊",@"name",nil];
    NSDictionary * dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"product_pack",@"image", @"我的预约",@"name",nil];
    NSDictionary * dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@"product_pack",@"image", @"程序版本",@"name",nil];
    
    [self.localArray addObject:dic];
    [self.localArray addObject:dic1];
    [self.localArray addObject:dic2];
    [self.localArray addObject:dic3];
    [self.localArray addObject:dic4];
    [self.localArray addObject:dic5];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadLoginAction:)
                                                 name:KHDMedicalAlreadLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadLogoutAction:)
                                                 name:KHDMedicalAlreadLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadFixedNameAction:)
                                                 name:KHDMedicalNameFixed object:nil];
    
    if ([DataEngine sharedDataEngine].isLogin)
    {
        // 1 请求参数
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl appendString:KHDMedicaluserboardlist];
        
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
    }
}

- (void)alreadLoginAction:(NSNotification *)sender
{
    UIButton * logBtn = (UIButton *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum4];
    [logBtn setTitle:[DataEngine sharedDataEngine].phoneNum forState:UIControlStateNormal];
    
    UIImageView * loginimageView = (UIImageView *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum5];
    [loginimageView setImage:[UIImage imageNamed:@"user_photo_default"]];
    
    if ([DataEngine sharedDataEngine].isLogin)
    {
        // 1 请求参数
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl appendString:KHDMedicaluserboardlist];
        
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
    }
}

- (void)alreadLogoutAction:(NSNotification *)sender
{
    UIButton * logBtn = (UIButton *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum4];
    [logBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    
    UIImageView * loginimageView = (UIImageView *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum5];
    [loginimageView setImage:[UIImage imageNamed:@"mine_profile_default"]];
}

- (void)alreadFixedNameAction:(NSNotification *)sender
{
    NSString * name = [[sender object] objectForKey:@"name"];
    UIButton * logBtn = (UIButton *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum4];
    [logBtn setTitle:name forState:UIControlStateNormal];
}

- (void)initMineTableView
{
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 49 - 64) style:UITableViewStylePlain];
    [self.mineTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.showsHorizontalScrollIndicator = NO;
    self.mineTableView.showsVerticalScrollIndicator= NO;
    self.mineTableView.bounces = YES;
    self.mineTableView.alwaysBounceVertical = NO;
    self.mineTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.mineTableView];
    
}

- (void)loginAction1:(id)sender
{
    if (![DataEngine sharedDataEngine].isLogin)
    {
        HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
        [self setHiddenTabBarView:YES];
    }else
    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert setTag:10];
//        [alert show];
        
        HDMineInfoViewController * mineInfo = [[HDMineInfoViewController alloc] init];
        [self.navigationController pushViewController:mineInfo animated:YES];
        [self setHiddenTabBarView:YES];
        
    }

}

- (void)initHeadView
{
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
    [headView setImage:[UIImage imageNamed:@"mine_head_bg"]];
    headView.userInteractionEnabled = YES;

    UIImageView * showIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [showIconImgView setImage:[UIImage imageNamed:@"mine_profile_default"]];
    [headView addSubview:showIconImgView];
    [showIconImgView centerToParent];
    [showIconImgView setCenterY:showIconImgView.centerY - 20];
    [showIconImgView setTag:kHDMedicalObjectTagNum5];
    
    
    UIButton * showIconImagViewBtn = [[UIButton alloc] initWithFrame:showIconImgView.frame];
    [showIconImagViewBtn setBackgroundColor:[UIColor clearColor]];
    [showIconImagViewBtn addTarget:self action:@selector(loginAction1:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:showIconImagViewBtn];
    

    
    UIButton * nickName = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, kScreenW - 80, 40)];
    if([DataEngine sharedDataEngine].isLogin)
    {
        [showIconImgView setImage:[UIImage imageNamed:@"user_photo_default"]];
        [nickName setTitle:[DataEngine sharedDataEngine].phoneNum forState:UIControlStateNormal];
    }

    else
    {
        [showIconImgView setImage:[UIImage imageNamed:@"mine_profile_default"]];
        [nickName setTitle:@"点击登录" forState:UIControlStateNormal];
    }

    [nickName setTintColor:[UIColor whiteColor]];
    [nickName addTarget:self action:@selector(loginAction1:) forControlEvents:UIControlEventTouchUpInside];
    [nickName setBackgroundColor:[UIColor clearColor]];
    [nickName.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nickName setTag:kHDMedicalObjectTagNum4];
    [nickName setY:showIconImgView.bottom];
    [headView addSubview:nickName];
    
    
    self.mineTableView.tableHeaderView = headView;
    
}


- (void)loadUIData
{
    [self initMineTableView];
    [self initHeadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHiddenTabBarView:NO];
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.localArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    MineTableView *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MineTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    [tableCell.leftNewSImgsView setImage:nil];
    [tableCell.imageView setImage:nil];
    [tableCell.textLabel setText:@""];
    [tableCell.newsHeadLineLable setText:@""];
    [tableCell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    
    if (indexPath.row < 6)
    {
        switch (indexPath.row) {
            case 0:
                [tableCell.imageView setImage:[UIImage imageNamed:@"health_history"]];
                [tableCell.textLabel setText:@"健康管理"];
                break;
            case 1:
                [tableCell.imageView setImage:[UIImage imageNamed:@"my_family"]];
                [tableCell.textLabel setText:@"我的家庭"];
                break;
            case 2:
                [tableCell.imageView setImage:[UIImage imageNamed:@"my_money"]];
                [tableCell.textLabel setText:@"我的钱包"];
                break;
            case 3:
                [tableCell.imageView setImage:[UIImage imageNamed:@"mine_ask"]];
                [tableCell.textLabel setText:@"我的问诊"];
                break;
            case 4:
                [tableCell.imageView setImage:[UIImage imageNamed:@"product_pack"]];
                [tableCell.textLabel setText:@"我的预约"];
                break;
            case 5:
                [tableCell.imageView setImage:[UIImage imageNamed:@"mine_soft_about"]];
                [tableCell.textLabel setText:@"程序版本"];
                break;
            default:
                break;
        }
    }else
    {
        myhtml5Item * item = [self.localArray objectAtIndex:indexPath.row];
        [tableCell.leftNewSImgsView setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"product_pack"]];
        
        [tableCell.newsHeadLineLable setText:item.caption];
    }


    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![DataEngine sharedDataEngine].isLogin)
    {
        HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
        UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
        return;
    }
    if (indexPath.row < 6)
    {
        switch (indexPath.row) {
            case 0:
            {
                HDHealthManageViewController * hrVC = [[HDHealthManageViewController alloc] init];
                [self.navigationController pushViewController:hrVC animated:YES];
                [self setHiddenTabBarView:YES];
            }
                break;
            case 1:
            {
                HDMyFamilyViewController * hdfvc = [[HDMyFamilyViewController alloc] init];
                [self.navigationController pushViewController:hdfvc animated:YES];
                [self setHiddenTabBarView:YES];
            }
                break;
            case 2:
            {
                HDMyMoneyPackViewController * hdfvc = [[HDMyMoneyPackViewController alloc] init];
                [self.navigationController pushViewController:hdfvc animated:YES];
                [self setHiddenTabBarView:YES];
                
            }
                break;
            case 3:
            {
                
                HDMedicalMyYuYueViewController * hdfvc = [[HDMedicalMyYuYueViewController alloc] init];
                [self.navigationController pushViewController:hdfvc animated:YES];
                [self setHiddenTabBarView:YES];
            }
                break;
            case 4:
            {
                HDMyYuYueViewController * yuyueVC = [[HDMyYuYueViewController alloc] init];
                [self.navigationController pushViewController:yuyueVC animated:YES];
                [self setHiddenTabBarView:YES];
                
            }
                break;
            case 5:
            {
                HDAboutUsViewController * yuyueVC = [[HDAboutUsViewController alloc] init];
                [self.navigationController pushViewController:yuyueVC animated:YES];
                [self setHiddenTabBarView:YES];
                
            }
                break;
                
            default:
                break;
        }
    }else
    {
        myhtml5Item * item = [self.localArray objectAtIndex:indexPath.row];
        NSString * urlStr = item.url;
        NSString *encodedString=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:encodedString];
        [self setHiddenTabBarView:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didSelectedTabBarItem
{
    NSLog(@"didSelectedTabBarItem =%@",self);
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10 && buttonIndex == 1)
    {
        
        NSString * token = [DataEngine sharedDataEngine].deviceToken;
        
        //总参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:token forKey:@"token"];
        
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl appendString:KHDMedicalLogout];
        
         //发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        
    }
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
//                NSString * msg = [responseData objectForKey:@"msg"];
//                NSLog(@"code = %d,msg =%@",code,msg);
        if (code == 1)
        {
            [DataEngine sharedDataEngine].isLogin = NO;
            [DataEngine sharedDataEngine].deviceToken = @"";
            UIButton * logBtn = (UIButton *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum4];
            [logBtn setTitle:@"点击登录" forState:UIControlStateNormal];
            
             UIImageView * loginimageView = (UIImageView *)[self.mineTableView.tableHeaderView viewWithTag:kHDMedicalObjectTagNum5];
            [loginimageView setImage:[UIImage imageNamed:@"mine_profile_default"]];
            
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [dataArray count] >0)
        {
            [self.html5Array  removeAllObjects];
            for (NSDictionary * dic in  dataArray)
            {
                 myhtml5Item * item = [[myhtml5Item alloc] init];
                item.caption = [JSONFormatFunc strValueForKey:@"caption" ofDict:dic];
                item.icon    = [JSONFormatFunc strValueForKey:@"icon" ofDict:dic];
                
                NSString * regionID = [NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]];
//                [totalParamDic setObject:regionID forKey:@"regionId"];
                
                item.url     = [NSString stringWithFormat:@"%@&regionID=%@",[JSONFormatFunc strValueForKey:@"url" ofDict:dic],regionID];
                [self.html5Array addObject:item];
            }
            
            [self.localArray addObjectsFromArray:self.html5Array];
            [self.mineTableView reloadData];
            
        }
    }

    
}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    NSLog(@"error %@",error.description);
}
@end
