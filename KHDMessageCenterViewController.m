//
//  KHDMessageCenterViewController.m
//  HDMedical
//
//  Created by David on 15-9-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "KHDMessageCenterViewController.h"
#import "MessageTableViewCell.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "HDReceiveFamilyViewController.h"

@interface KHDMessageCenterViewController ()

@end

@implementation KHDMessageCenterViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"消息中心";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalMessageHasRead object:nil];
}

- (void)initExtendedData
{
    self.messageArray = [NSMutableArray array];

    [self requestMessageCenter];
}

- (void)requestMessageCenter
{
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalmyMessage];
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageHasReadAction:)
                                                 name:KHDMedicalMessageHasRead object:nil];
    
    // 请求
    //
    //[self requestURL];
    //user-platform-web-1.0.0/rest/user/myWallet?token=[0]
    
    
}

- (void)messageHasReadAction:(NSNotification *)sender
{
    [self requestMessageCenter];
}

- (void)initMineinofTableView
{
    self.messageCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.messageCenterTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.messageCenterTableView.delegate = self;
    self.messageCenterTableView.dataSource = self;
    self.messageCenterTableView.showsHorizontalScrollIndicator = NO;
    self.messageCenterTableView.showsVerticalScrollIndicator= NO;
    self.messageCenterTableView.bounces = YES;
    //    self.mineMoneyPackTableView.allowsSelection = NO;
    self.messageCenterTableView.alwaysBounceVertical = NO;
    self.messageCenterTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.messageCenterTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    MessageTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    myMessageCenterItem *item = [self.messageArray objectAtIndex:indexPath.row];
    if ([item.type intValue]== 1)
    {
        [tableCell.redImageView setImage:[UIImage imageNamed:@"main_message_dot"]];
    }
    [tableCell.tilteLable setText:item.title];
    [tableCell.timeLable setText:item.time];
    
//    tableCell.messageType = 3;
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    myMessageCenterItem *item = [self.messageArray objectAtIndex:indexPath.row];
    
    if ([item.type  intValue]== 1)
    {
        HDReceiveFamilyViewController * receiveFaVC = [[HDReceiveFamilyViewController alloc] init];
        receiveFaVC.messageItem = item;
        [self.navigationController pushViewController:receiveFaVC animated:YES];
    }
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSMutableArray * messageArray = [NSMutableArray arrayWithArray:[JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData]];
        
        if (code == 1)
        {
            [self.messageArray removeAllObjects];
            for (NSDictionary * dic in messageArray)
            {
                myMessageCenterItem *item = [[myMessageCenterItem alloc] init];
                
                item.messageId = [JSONFormatFunc strValueForKey:@"id" ofDict:dic];
                item.type = [JSONFormatFunc strValueForKey:@"type" ofDict:dic];
                item.hasRead = [(NSNumber *)[JSONFormatFunc numberValueForKey:@"hasRead" ofDict:dic] boolValue];
                item.title = [JSONFormatFunc strValueForKey:@"title" ofDict:dic];
                
                long long int  time = [[JSONFormatFunc strValueForKey:@"time" ofDict:dic] longLongValue];
                long long int actural = time/1000;
                
                NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:(long long int)actural];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
                
                item.time = destDateString;
                item.info = [JSONFormatFunc dictionaryValueForKey:@"info" ofDict:dic];
                
                [self.messageArray addObject:item];
            }
            
            [self.messageCenterTableView reloadData];
            
            // 发送已经读的数据给服务端
            for (myMessageCenterItem  * item in  self.messageArray)
            {
                if (!item.hasRead && [item.type intValue] != 1)
                {
                    // 1 请求参数
                    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
                    [baseUrl appendString:@"/"];
                    [baseUrl appendString:KHDMedicalreadMessage];
                    
                    // 参数封装
                    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
                    
                    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
                    [totalParamDic setObject:item.messageId forKey:@"id"];
                    
                    // 发送数据
                    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
                }
            }
            
        }else if (code == -302) // 尚未登录，可能被踢出
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
    }if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        // 已经读过的消息
        NSLog(@"responseData= %@",responseData);
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
