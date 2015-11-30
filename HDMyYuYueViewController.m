//
//  HDMyYuYueViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-24.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMyYuYueViewController.h"
#import "MyAskDocTableViewCell.h"
#import "JSONFormatFunc.h"
#import "DataItem.h"

@interface HDMyYuYueViewController ()

@end

@implementation HDMyYuYueViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的预约";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.myYuyueArray = [NSMutableArray array];
    
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalreserveHistory];
    
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
    return [self.myYuyueArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    MyAskDocTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MyAskDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    myYuyueItem *item = [self.myYuyueArray objectAtIndex:indexPath.row];
    int type = [item.type intValue];
    int status = [item.status intValue];
    
    if (type == 1)
    {
        NSDictionary * dic = item.doctor;
        NSString * name = [dic objectForKey:@"name"];
        NSString * docImagURl = [dic objectForKey:@"photo"]; 
        [tableCell.tilteLable setText:name];
    
        [tableCell.redImageView setImageWithURL:[NSURL URLWithString:docImagURl] placeholderImage:[UIImage imageNamed:@"ask_doctor_self"]];
        
    }else if(type == 2)
    {
        NSDictionary * dic = item.examination;
        NSString * name = [dic objectForKey:@"name"];
        
        [tableCell.tilteLable setText:name];
        
        [tableCell.redImageView setImage:[UIImage imageNamed:@"ask_doctor_self"]];
        
    }else
    {
        NSDictionary * dic = item.examination;
        NSString * name = [dic objectForKey:@"name"];
        
        [tableCell.tilteLable setText:name];
        
        [tableCell.redImageView setImage:[UIImage imageNamed:@"ask_doctor_self"]];
    }
    
    if (status == 1) {
        [tableCell.tipLable setText:@"已预约"];
    }else if (status == 2)
    {
        [tableCell.tipLable setText:@"已赴约"];
    }else if (status == 3)
    {
        [tableCell.tipLable setText:@"已结束"];
    }
    
    NSMutableString * time = [NSMutableString stringWithFormat:@"%@   %@",item.date,item.span];
    [tableCell.timeLable setText:time];

    //[tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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
        NSArray * timeArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1)
        {
            [self.myYuyueArray removeAllObjects];
            
            for (NSDictionary * dic in timeArray)
            {
                myYuyueItem *item = [[myYuyueItem alloc] init];
                item.date = [JSONFormatFunc strValueForKey:@"date" ofDict:dic];
                item.doctor = [JSONFormatFunc dictionaryValueForKey:@"doctor" ofDict:dic];
                item.examination = [JSONFormatFunc dictionaryValueForKey:@"examination" ofDict:dic];
                
                
                item.myId = [JSONFormatFunc strValueForKey:@"id" ofDict:dic];
                item.span = [JSONFormatFunc strValueForKey:@"span" ofDict:dic];
                item.type = [JSONFormatFunc strValueForKey:@"type" ofDict:dic];
                item.status = [JSONFormatFunc strValueForKey:@"status" ofDict:dic];
                [self.myYuyueArray addObject:item];
            }
            [self.messageCenterTableView reloadData];
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
