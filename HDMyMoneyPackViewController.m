//
//  HDMyMoneyPackViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMyMoneyPackViewController.h"
#import "MyMoneyTableViewCell.h"
#import "JSONFormatFunc.h"

@interface HDMyMoneyPackViewController ()

@end

@implementation HDMyMoneyPackViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的钱包";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.mineMoneyArray = [NSMutableArray array];
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalmyWallet];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
    
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
    self.mineMoneyPackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.mineMoneyPackTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.mineMoneyPackTableView.delegate = self;
    self.mineMoneyPackTableView.dataSource = self;
    self.mineMoneyPackTableView.showsHorizontalScrollIndicator = NO;
    self.mineMoneyPackTableView.showsVerticalScrollIndicator= NO;
    self.mineMoneyPackTableView.bounces = YES;
//    self.mineMoneyPackTableView.allowsSelection = NO;
    self.mineMoneyPackTableView.alwaysBounceVertical = NO;
    self.mineMoneyPackTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.mineMoneyPackTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mineMoneyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    MyMoneyTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MyMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    myMoneyItem * item = [self.mineMoneyArray objectAtIndex:indexPath.row];
    
    
    [tableCell.leftImgView setImage:[UIImage imageNamed:@"mine_mymoney_leftgap"]];
    [tableCell.moneySysLable setText:@"￥"];
    [tableCell.moneyNumLable setText:item.amount];
    [tableCell.moneyYuanLable setText:@"元"];
    [tableCell.gapImgView setImage:[UIImage imageNamed:@"mine_mymoney_midgap"]];
    [tableCell.honBaoLable setText:@"红包"];
    [tableCell.bankLable setText:item.bank];
    [tableCell.timeLable setText:item.time];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * moneyArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [moneyArray count] >0)
        {
            for (NSDictionary * dic in moneyArray)
            {
                myMoneyItem * item = [[myMoneyItem alloc] init];
                
                item.myId = [JSONFormatFunc strValueForKey:@"id" ofDict:dic];
                item.amount = [JSONFormatFunc strValueForKey:@"amount" ofDict:dic];
                item.bank = [JSONFormatFunc strValueForKey:@"bank" ofDict:dic];
                item.time = [JSONFormatFunc strValueForKey:@"time" ofDict:dic];
                
                [self.mineMoneyArray addObject:item];
            }
            [self.mineMoneyPackTableView reloadData];
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
