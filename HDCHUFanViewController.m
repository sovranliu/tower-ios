//
//  HDCHUFanViewController.m
//  HDMedical
//
//  Created by David on 15-9-26.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDCHUFanViewController.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "TOWebViewController.h"

@interface HDCHUFanViewController ()

@end

@implementation HDCHUFanViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"医生处方";
        self.showNav    = YES;
        self.resident   = YES;
        
    }
    return self;
}
- (void)initExtendedData
{
    self.ChufanArray = [NSMutableArray array];
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalprescriptionlist];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
}

- (void)initMineTableView
{
    self.chufanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    [self.chufanTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.chufanTableView.delegate = self;
    self.chufanTableView.dataSource = self;
    self.chufanTableView.showsHorizontalScrollIndicator = NO;
    self.chufanTableView.showsVerticalScrollIndicator= NO;
    self.chufanTableView.bounces = YES;
    self.chufanTableView.alwaysBounceVertical = NO;
    self.chufanTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.chufanTableView];
    
}

- (void)loadUIData
{
    [self initMineTableView];
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ChufanArray count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    myChufanItem *item = [self.ChufanArray objectAtIndex:indexPath.row];
    tableCell.textLabel.text = item.caption;
    
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     myChufanItem *item = [self.ChufanArray objectAtIndex:indexPath.row];
    TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:item.url];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)didSelectedTabBarItem
{
    NSLog(@"didSelectedTabBarItem =%@",self);
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * contentArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1)
        {
            [self.ChufanArray removeAllObjects];
            for (NSDictionary * dic in  contentArray)
            {
                myChufanItem *item = [[myChufanItem alloc] init];
                item.caption = [JSONFormatFunc strValueForKey:@"caption" ofDict:dic];
                item.url = [JSONFormatFunc strValueForKey:@"url" ofDict:dic];
                [self.ChufanArray addObject:item];
            }
            [self.chufanTableView reloadData];
        }else if (code == -302)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，请重新登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalAlreadLogout object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [DataEngine sharedDataEngine].deviceToken = @"";
            [DataEngine sharedDataEngine].isLogin = NO;
            [DataEngine sharedDataEngine].userId = @"";
            
            [DataEngine sharedDataEngine].selectedCityId = @"";
            [DataEngine sharedDataEngine].selectedCityName = @"";
             [DataEngine sharedDataEngine].selectedRegionId = @"";
             [DataEngine sharedDataEngine].selectedRegionName = @"";
            
            [[DataEngine sharedDataEngine] saveUserBaseInfoData];
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
