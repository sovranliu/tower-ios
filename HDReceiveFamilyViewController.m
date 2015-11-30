//
//  HDReceiveFamilyViewController.m
//  HDMedical
//
//  Created by David on 15-9-26.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDReceiveFamilyViewController.h"
#import "MyYuYueTableViewCell.h"
#import "JSONFormatFunc.h"

@interface HDReceiveFamilyViewController ()

@end

@implementation HDReceiveFamilyViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"消息列表";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    
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
    self.reveiveFamilyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.reveiveFamilyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.reveiveFamilyTableView.delegate = self;
    self.reveiveFamilyTableView.dataSource = self;
    self.reveiveFamilyTableView.showsHorizontalScrollIndicator = NO;
    self.reveiveFamilyTableView.showsVerticalScrollIndicator= NO;
    self.reveiveFamilyTableView.bounces = YES;
    //    self.mineMoneyPackTableView.allowsSelection = NO;
    self.reveiveFamilyTableView.alwaysBounceVertical = NO;
    self.reveiveFamilyTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.reveiveFamilyTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    MyYuYueTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MyYuYueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    NSString *name = [self.messageItem.info objectForKey:@"name"];
    NSString *relation = [self.messageItem.info objectForKey:@"relation"];
    
    
    [tableCell.tilteLable setText:name];
    [tableCell setTimeLableWidth:kScreenW - 40.0];
    [tableCell.timeLable setText:[NSString stringWithFormat:@"%@请求添加你为亲友",relation]];
    
    if ([self.selectedStr length] > 0)
    {
        [tableCell hiddenRightTwoBtnAWithMsg:self.selectedStr];
    }else
    {
        [tableCell showRightTwoBtn];
    }

    tableCell.rightBtnDelegate = self;
    tableCell.rightCancelBtnDelegate = self;
        
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - rightBtn Delegate

- (void)rightBtnAction:(NSInteger)index
{
    NSLog(@"jieshou ");
    
    self.selectedStr = @"已接受";
    
    NSString * requestId = [self.messageItem.info objectForKey:@"requestId"];
    
    // 发送接受接口
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalresponseFamily];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:@"true" forKey:@"isResponse"];
    [totalParamDic setObject:requestId forKey:@"requestId"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)rightCancelBtnAction:(NSInteger)index
{
     NSLog(@"juejue ");
    self.selectedStr = @"已拒绝";
    
    NSString * requestId = [self.messageItem.info objectForKey:@"requestId"];
    
    // 发送拒绝接口
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalresponseFamily];
    
    
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:@"false" forKey:@"isResponse"];
    [totalParamDic setObject:requestId forKey:@"requestId"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg = [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        if (code >0)
        {

           [self.reveiveFamilyTableView reloadData];
            
            // 发送已读接口
            // 1 请求参数
            NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
            [baseUrl1 appendString:@"/"];
            [baseUrl1 appendString:KHDMedicalreadMessage];
            
            // 参数封装
            NSMutableDictionary * totalParamDic1 =[[NSMutableDictionary alloc] initWithCapacity:1];
            
            [totalParamDic1 setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
            [totalParamDic1 setObject:self.messageItem.messageId forKey:@"id"];
            
            // 发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl1 userInfo:totalParamDic1 withReqTag:2];

        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else  if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        NSLog(@"responseData= %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
        if (code >0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalMessageHasRead object:nil];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString * message = [NSString stringWithFormat:@"%@成功",self.selectedStr];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
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
