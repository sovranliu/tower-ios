//
//  HDHealthManageViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-23.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDHealthManageViewController.h"
#import "TOWebViewController.h"
#import "HDCHUFanViewController.h"
#import "HDUIWebViewController.h"

@interface HDHealthManageViewController ()

@end

@implementation HDHealthManageViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"健康管理";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    
    // 1 请求参数
//    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
//    [baseUrl appendString:@"/"];
//    [baseUrl appendString:KHDMedicalmyMessage];
//    
//    // 参数封装
//    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
//    
//    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
//    
//    // 发送数据
//    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
    
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    
    [self initMineinofTableView];
    
    // 请求
    //
    //[self requestURL];
    //user-platform-web-1.0.0/rest/user/myWallet?token=[0]
    
    
}

- (void)initMineinofTableView
{
    self.healthManageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.healthManageTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.healthManageTableView.delegate = self;
    self.healthManageTableView.dataSource = self;
    self.healthManageTableView.showsHorizontalScrollIndicator = NO;
    self.healthManageTableView.showsVerticalScrollIndicator= NO;
    self.healthManageTableView.bounces = YES;
    //    self.mineMoneyPackTableView.allowsSelection = NO;
    self.healthManageTableView.alwaysBounceVertical = NO;
    self.healthManageTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.healthManageTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    switch (indexPath.row) {
        case 0:
            [tableCell.textLabel setText:@"医生处方"];
            break;
        case 1:
            [tableCell.textLabel setText:@"健康数据"];
            break;
        case 2:
            [tableCell.textLabel setText:@"问卷调查"];
            break;
        case 3:
            [tableCell.textLabel setText:@"健康报告"];
            break;
            
        default:
            break;
    }
    
    
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0)
    {
        HDCHUFanViewController * hdVC = [[HDCHUFanViewController alloc] init];
        [self.navigationController pushViewController:hdVC animated:YES];
        
    }else if(indexPath.row == 1)
    {
        NSString * urlStr = @"http://cdn.oss.wehop-resources.wehop.cn/user/sites/health-data/v-1/index.html?token=";
        
        
        NSString * tokenStr = [NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].deviceToken];
        NSString * totalStr = [NSString stringWithFormat:@"%@%@",urlStr,tokenStr];
        
        
        NSString *encodedString=[totalStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:encodedString];
        [self.navigationController pushViewController:webViewVC animated:YES];
        
    }else if(indexPath.row == 2)
    {
        NSString * urlStr = @"http://cdn.oss.wehop-resources.wehop.cn/well-risk/sites/v-1/index.html#/form?token=";
        
        NSString * tokenStr = [[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].deviceToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString  * totalStr = [NSString stringWithFormat:@"%@%@",urlStr,tokenStr];
        
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:totalStr];
        [self.navigationController pushViewController:webViewVC animated:YES];

    }else if(indexPath.row == 3)
    {
        NSString * urlStr = @"http://cdn.oss.wehop-resources.wehop.cn/user/sites/health-report/v-1/index.html?token=";
        
        NSString * tokenStr = [[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].deviceToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString  * totalStr = [NSString stringWithFormat:@"%@%@",urlStr,tokenStr];
        TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:totalStr];
        [self.navigationController pushViewController:webViewVC animated:YES];
        
        
    }
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        //        NSMutableArray * timeArray = [responseData objectForKey:@"data"];
        //        if (code == 1 && [timeArray count] >0)
        //        {
        //
        //        }
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
