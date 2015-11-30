//
//  HDSelectCityAndRegionViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15/11/29.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "HDSelectCityAndRegionViewController.h"
#import "JSONFormatFunc.h"
#import "UIKit+AFNetworking.h"

@interface HDSelectCityAndRegionViewController ()

@end

@implementation HDSelectCityAndRegionViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"请选择所在城市和小区";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalBodyImg object:nil];
}

- (void)initExtendedData
{
    self.isfirstClickFlag = NO;
    self.leftTableViewDataArray = [[NSMutableArray alloc] init];
    self.rightTableViewDataArray = [[NSMutableArray alloc] init];
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicalcitylist];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:nil withReqTag:1];
    
    
}

- (void)loadUIData
{
    [self initLeftTableView];
    [self initRightTableView];
    
    
    if (self.showBackBtnFlag)
    {
        // 左item
        UIButton *backActionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [backActionBtn setFrame:CGRectMake(10, 30, 40, 30)];
        [backActionBtn setTitle:@"回退" forState:normal];
        [backActionBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [backActionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backActionBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backActionBtn];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
}

- (void)initLeftTableView
{
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, kScreenH - 64) style:UITableViewStylePlain];
    [self.leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.leftTableView setSeparatorInset:UIEdgeInsetsZero];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.showsHorizontalScrollIndicator = NO;
    self.leftTableView.showsVerticalScrollIndicator= NO;
    self.leftTableView.bounces = YES;
    self.leftTableView.alwaysBounceVertical = NO;
    self.leftTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.leftTableView];
    
    
    // 分割线左移 ios7
    if ([ self.leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.leftTableView   setSeparatorInset:UIEdgeInsetsZero];
    }
    // 分割线左移 ios8
    if ([self.leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)initRightTableView
{
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, 0, kScreenW - 120, kScreenH - 64) style:UITableViewStylePlain];
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.showsHorizontalScrollIndicator = NO;
    self.rightTableView.showsVerticalScrollIndicator= NO;
    self.rightTableView.bounces = YES;
    self.rightTableView.alwaysBounceVertical = NO;
    self.rightTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.rightTableView];
    
    // 分割线左移 ios7
    if ([ self.rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.rightTableView   setSeparatorInset:UIEdgeInsetsZero];
    }
    // 分割线左移 ios8
    if ([self.rightTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.rightTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -列表处理
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
//    if(tableView == self.leftTableView ||)
//    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [cell setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [cell setLayoutMargins:UIEdgeInsetsZero];
            
        }
//    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int num = (tableView == self.leftTableView) ? (int)[self.leftTableViewDataArray count] : (int)[self.rightTableViewDataArray count] ;
    return num;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = (tableView == self.leftTableView) ? 60 : 45 ;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        NSString *cellIdentifierStr = @"LeftBasicInforIdentifier";
        
        UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
        if (tableCell == nil)
        {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
        
        if ([self.leftTableViewDataArray count] > 0)
        {
            
            NSDictionary * dic = [self.leftTableViewDataArray objectAtIndex:indexPath.row];
            
            tableCell.textLabel.text =  [dic objectForKey:@"name"];
            [tableCell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [tableCell setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
            
            if (indexPath.row == 0 && !self.isfirstClickFlag)
            {
                [tableCell setBackgroundColor:[UIColor whiteColor]];
            }
        }
        
        return tableCell;
        
    }else
    {
        NSString *cellIdentifierStr = @"RightBasicInforIdentifier";
        
        UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
        if (tableCell == nil)
        {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
        
        if ([self.rightTableViewDataArray count] > 0)
        {
            
            NSDictionary * dic = [self.rightTableViewDataArray objectAtIndex:indexPath.row];
            
            tableCell.textLabel.text =  [dic objectForKey:@"name"];
            
        }
        
        
        return tableCell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.leftTableView)
    {
        // 更新cell 颜色
        self.isfirstClickFlag = YES;
        [tableView reloadData];
        UITableViewCell * tableCell = [self.leftTableView cellForRowAtIndexPath:indexPath];
        [tableCell setBackgroundColor:[UIColor whiteColor]];
        
        
 //       NSArray * cityArray = (NSArray *)[self.leftTableViewDataArray objectAtIndex:indexPath.row];
        NSDictionary * cityDic = [self.leftTableViewDataArray objectAtIndex:indexPath.row];
        NSString * cityId = [cityDic objectForKey:@"id"];
        NSString * cityName = [cityDic objectForKey:@"name"];
        
        NSString * deviceToken = @"";
        if ([[DataEngine sharedDataEngine].deviceToken length] > 0)
            deviceToken = [DataEngine sharedDataEngine].deviceToken;
        
        // 3请求小区
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:kHDMedicalregionList];
        // 参数封装
        NSMutableDictionary * totalParamDic0 =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic0 setObject:deviceToken forKey:@"token"];
        [totalParamDic0 setObject:cityId forKey:@"cityId"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic0 withReqTag:2];
        
        // 保存城市名字
        [DataEngine sharedDataEngine].selectedCityName = cityName;
        
    }
    else if (tableView == self.rightTableView)
    {
        
        NSDictionary * cityDic = [self.rightTableViewDataArray objectAtIndex:indexPath.row];
        NSString * cityId = [cityDic objectForKey:@"cityId"];
        NSString * regionId = [cityDic objectForKey:@"id"];
        NSString * regionName = [cityDic objectForKey:@"name"];
        
        [DataEngine sharedDataEngine].selectedCityId = cityId;
        [DataEngine sharedDataEngine].selectedRegionName = regionName;
        [DataEngine sharedDataEngine].selectedRegionId = regionId;
        
        [[DataEngine sharedDataEngine] saveUserBaseInfoData];
        
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.showBackBtnFlag], @"showBackFlag",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalSelectedCityAndRegion object:userInfo];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//
    
    

}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        // NSString * msg = [responseData objectForKey:@"msg"];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [dataArray count] >0)
        {
            [self.leftTableViewDataArray removeAllObjects];
            [self.leftTableViewDataArray addObjectsFromArray:dataArray];
            [self.leftTableView reloadData];
            
            NSString * deviceToken = @"";
            if ([[DataEngine sharedDataEngine].deviceToken length] > 0)
                deviceToken = [DataEngine sharedDataEngine].deviceToken;
            
            NSDictionary * cityDic = [dataArray objectAtIndex:0];
            NSString * cityId = [cityDic objectForKey:@"id"];
            
            // 3请求小区
            NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
            [baseUrl1 appendString:kHDMedicalregionList];
            // 参数封装
            NSMutableDictionary * totalParamDic0 =[[NSMutableDictionary alloc] initWithCapacity:1];
            [totalParamDic0 setObject:deviceToken forKey:@"token"];
            [totalParamDic0 setObject:cityId forKey:@"cityId"];
            
            // 发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic0 withReqTag:2];

        }
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        NSLog(@"response2 Data = %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
        //NSString * msg = [responseData objectForKey:@"msg"];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        //        NSLog(@"code = %d,msg =%@",code,msg);
        if (code == 1 && [dataArray count] >0)
        {
            [self.rightTableViewDataArray removeAllObjects];
            [self.rightTableViewDataArray addObjectsFromArray:dataArray];
            [self.rightTableView reloadData];
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
