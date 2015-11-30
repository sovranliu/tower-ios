//
//  HDMedicalMyYuYueViewController.m
//  HDMedical
//
//  Created by David on 15-9-18.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMedicalMyYuYueViewController.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "UIImageView+WebCache.h"
#import "HistoryTalkTableViewCell.h"
#import "HDChatViewController.h"

@interface HDMedicalMyYuYueViewController ()

@end

@implementation HDMedicalMyYuYueViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的问诊";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.mineYuyueArray = [NSMutableArray array];
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    
    [self initMineinofTableView];
    
    // 请求
    //
    //[self requestURL];
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalqueryPipe];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
    
}

- (void)initMineinofTableView
{
    self.mineYuYueTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
    [self.mineYuYueTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.mineYuYueTableView.delegate = self;
    self.mineYuYueTableView.dataSource = self;
    self.mineYuYueTableView.showsHorizontalScrollIndicator = NO;
    self.mineYuYueTableView.showsVerticalScrollIndicator= NO;
    self.mineYuYueTableView.bounces = YES;
    self.mineYuYueTableView.alwaysBounceVertical = NO;
    self.mineYuYueTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.mineYuYueTableView];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mineYuyueArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    HistoryTalkTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[HistoryTalkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    myAskDocItem * item = [self.mineYuyueArray objectAtIndex:indexPath.row];
    NSString * imgsURLstr = item.imgUrl;
    [tableCell.leftImageView setImageWithURL:[NSURL URLWithString:imgsURLstr] placeholderImage:[UIImage imageNamed:@"user_photo_default"]];
    [tableCell.tilteLable setText:item.name];
    [tableCell.timeLable setText:item.time];
    
    
    
//    tableCell.rightBtn.tag = indexPath.row;
//    tableCell.rightBtnDelegate = self;
//    switch (indexPath.row) {
//        case 0:
//            [tableCell.leftImgView setImage:[UIImage imageNamed:@"askdoctor_online"]];
//            [tableCell.tilteLable setText:@"王医生"];
//            [tableCell.detailLabel setText:@"2012-09-18 PM"];
//            [tableCell.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
//            
//            break;
//        case 1:
//            [tableCell.leftImgView setImage:[UIImage imageNamed:@"askdoctor_self"]];
//            [tableCell.tilteLable setText:@"曹医生"];
//            [tableCell.detailLabel setText:@"2014-07-16 PM"];
//             [tableCell.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    myAskDocItem * item = [self.mineYuyueArray objectAtIndex:indexPath.row];
    NSString * doctorID = item.doctor;
    
    HDChatViewController * chatVC = [[HDChatViewController alloc] init];
    
    chatVC.doctorId = doctorID;
    chatVC.doctorImgURL = item.imgUrl;
    chatVC.isFormDocDetail = NO;
    chatVC.alreadyPipe = YES;
    chatVC.pipe = [item.myid intValue];
    chatVC.messageId = 0;
    
    [self.navigationController pushViewController:chatVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)rightBtnAction:(NSInteger)index
{
    NSLog(@"index = %ld",index);
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData33= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * docArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1)
        {
            [self.mineYuyueArray removeAllObjects];
            for (NSDictionary * dic in docArray)
            {
                myAskDocItem * item = [[myAskDocItem alloc] init];
                item.doctor = [JSONFormatFunc strValueForKey:@"doctor" ofDict:dic];
                item.myid = [JSONFormatFunc strValueForKey:@"id" ofDict:dic];
                item.imgUrl = [JSONFormatFunc strValueForKey:@"imgUrl" ofDict:dic];
                item.name = [JSONFormatFunc strValueForKey:@"name" ofDict:dic];
                item.status = [JSONFormatFunc strValueForKey:@"status" ofDict:dic];
                
                
                long long int  time = [[JSONFormatFunc strValueForKey:@"time" ofDict:dic] longLongValue];
                long long int actural = time/1000;
                
                NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:(long long int)actural];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *destDateString = [dateFormatter stringFromDate:confromTimesp];
                
                item.time = destDateString;
                item.topic = [JSONFormatFunc strValueForKey:@"topic" ofDict:dic];
                item.user = [JSONFormatFunc strValueForKey:@"user" ofDict:dic];
                
                [self.mineYuyueArray addObject:item];
            }
            [self. mineYuYueTableView reloadData];

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
            [DataEngine sharedDataEngine].selectedRegionName = @"";
            [DataEngine sharedDataEngine].selectedCityName = @"";
            [DataEngine sharedDataEngine].selectedRegionId = @"";
            
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
