//
//  HDPhysicalExaminationViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-16.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDPhysicalExaminationViewController.h"
#import "UIView+Positioning.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "HDMyYuYueViewController.h"

@interface HDPhysicalExaminationViewController ()

@end

@implementation HDPhysicalExaminationViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"预约体检";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.tcDropDownArryList = [[NSMutableArray alloc] init];
    
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalexaminationList];
    
    NSString * regionID = [NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:regionID forKey:@"regionId"];
    
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];

}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    
    
    //[self initDropDownView:nil withTimeArray:nil];
}



- (void)initDropDownView2withTimeArray:(NSMutableArray *)yuyueTimeArray withDetail:(NSString *)detail
{
    //UILabel * yuyueTime = (UILabel *)[self.view viewWithTag:4];
    MXPullDownMenu *menu = (MXPullDownMenu *)[self.view viewWithTag:1];
    
//    MXPullDownMenu *yuyueMenu = [[MXPullDownMenu alloc] initWithArray:yuyueTimeArray selectedColor:UIColorFromRGB(0x7d7d7d) withTableFrame:CGRectMake(15, 10, kScreenW- 30, 0)];
//    yuyueMenu.tag = 2;
//    yuyueMenu.tableViewRowNum = 2.5;
//    [yuyueMenu setBackgroundColor:[UIColor whiteColor]];
//    yuyueMenu.delegate = self;
//    yuyueMenu.frame = CGRectMake(15, kScreenH - 49 - 30 - 120 + 30 + 5,kScreenW -30, yuyueMenu.frame.size.height);
//    [self.view addSubview:yuyueMenu];
    
    // contentView
//    UITextView * contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, menu.bottom + 10, kScreenW - 30, yuyueTime.y - menu.bottom - 20)];
//    [contentView setEditable:NO];
//    [contentView setText:detail];
//    contentView.tag = 3;
//    [self.view addSubview:contentView];
    
    UIImageView * contentViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, menu.bottom + 10, kScreenW - 30, kScreenH  -70  - menu.bottom - 20)];
    contentViewImg.tag = 3;
    [contentViewImg setImageWithURL:[NSURL URLWithString:detail] placeholderImage:nil];
    [self.view addSubview:contentViewImg];
    
}

- (void)initDropDownView:(NSMutableArray *)tcArray withTimeArray:(NSMutableArray *)yuyueTimeArray withDetail:(NSString *)detail
{
    
    UILabel * tipLabel = [[UILabel alloc] init];
    [tipLabel setFrame:CGRectMake(15, 15, kScreenW, 30)];
    [tipLabel setText:@"请选择检查项目:"];
    [tipLabel setFont:[UIFont systemFontOfSize:16.0]];
    [tipLabel setTextColor:[UIColor blackColor]];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:tipLabel];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:tcArray selectedColor:UIColorFromRGB(0x7d7d7d) withTableFrame:CGRectMake(15, 10, kScreenW- 30, 0)];
    menu.tag = 1;
    menu.tableViewRowNum = 5;
    [menu setBackgroundColor:[UIColor whiteColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(15, tipLabel.bottom + 5,kScreenW -30, menu.frame.size.height);
    [self.view addSubview:menu];
    
//    // 预约时间
//    UILabel * yuyueTime = [[UILabel alloc] init];
//    [yuyueTime setFrame:CGRectMake(15, kScreenH - 49 - 30 - 30 - 120, kScreenW - 30, 30)];
//    [yuyueTime setText:@"可预约时间:"];
//    [yuyueTime setFont:[UIFont systemFontOfSize:16.0]];
//    [yuyueTime setTextColor:[UIColor blackColor]];
//    [yuyueTime setTextAlignment:NSTextAlignmentLeft];
//    yuyueTime.tag = 4;
//    [self.view addSubview:yuyueTime];
    
    

//    MXPullDownMenu *yuyueMenu = [[MXPullDownMenu alloc] initWithArray:yuyueTimeArray selectedColor:UIColorFromRGB(0x7d7d7d) withTableFrame:CGRectMake(15, 10, kScreenW- 30, 0)];
//    yuyueMenu.tag = 2;
//    yuyueMenu.tableViewRowNum = 2.5;
//    [yuyueMenu setBackgroundColor:[UIColor whiteColor]];
//    yuyueMenu.delegate = self;
//    yuyueMenu.frame = CGRectMake(15, yuyueTime.bottom + 5,kScreenW -30, yuyueMenu.frame.size.height);
//    [self.view addSubview:yuyueMenu];
//    
//    // 提交按钮
//    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sureBtn setTitle:@"申   请" forState:UIControlStateNormal];
//    [sureBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
//    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [sureBtn setFrame:CGRectMake(25, yuyueMenu.bottom + 15, kScreenW - 50, 40)];
//    [self.view addSubview:sureBtn];
//    [sureBtn.layer setCornerRadius:3.0];
    
    // contentView
//    UITextView * contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, menu.bottom + 10, kScreenW - 30, yuyueTime.y - menu.bottom - 20)];
//    [contentView setEditable:NO];
//    [contentView setText:detail];
//    contentView.tag = 3;
//    [self.view addSubview:contentView];
    UIImageView * contentViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, menu.bottom + 10, kScreenW - 30, kScreenH - 70 - menu.bottom - 20)];
    contentViewImg.tag = 3;
    [contentViewImg setImageWithURL:[NSURL URLWithString:detail] placeholderImage:nil];
    [self.view addSubview:contentViewImg];
    
}

- (void)sureBtnAction:(id)sender
{
    NSLog(@"sureBtnAction");
    //user-platform-web-1.0.0/rest/user/reserveExamination?examinationId=[0]&date=[1]&span=[2]&token=[3]
    
    
    tjtcItem * item = [self.tcDropDownArryList objectAtIndex:self.currentSelectedIndex];
    NSString * examinationId = item.tcid;
    
    NSArray * timearray = [NSArray arrayWithArray:item.timeArray] ;
    NSDictionary *dic = [timearray objectAtIndex:self.currentTimeSelectedIndex];
    
    NSString * date =  [JSONFormatFunc strValueForKey:@"date" ofDict:dic];
    NSString * span =  [JSONFormatFunc strValueForKey:@"span" ofDict:dic];
    
    NSLog(@"id%@,date%@,span%@",examinationId,date,span);
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalreserveExamination];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:examinationId forKey:@"examinationId"];
    [totalParamDic setObject:date forKey:@"date"];
    [totalParamDic setObject:span forKey:@"span"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];

}

- (void)reDrowViewWithIndex:(int) index
{
    // 删除所有的子view
    for (UIView * subView  in [self.view subviews]) {
        [subView removeFromSuperview];
    }
    
    // 默认第一行
    tjtcItem * item = [self.tcDropDownArryList objectAtIndex:index];
    
    NSMutableArray * tcNamearray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.tcDropDownArryList count]; i ++)
    {
        tjtcItem * item = [self.tcDropDownArryList objectAtIndex:i];
        [tcNamearray addObject:item.name];
    }
    
    
    NSMutableArray * timeArray = [NSMutableArray array];
    for (NSDictionary *dic in item.timeArray)
    {
        NSMutableString * yuyueStr = [NSMutableString string];
        NSString * str1 = [JSONFormatFunc strValueForKey:@"date" ofDict:dic];
        NSString * str2 = [JSONFormatFunc strValueForKey:@"span" ofDict:dic];
        [yuyueStr appendString:str1];
        [yuyueStr appendString:[NSString stringWithFormat:@"   %@",str2]];
        [timeArray addObject:yuyueStr];
    }
    
    // 重新画View
    [self initDropDownView:[NSMutableArray arrayWithObject:tcNamearray] withTimeArray:[NSMutableArray arrayWithObject:timeArray] withDetail:item.imgURL];
    
}

- (void)reDrowMenu2ViewWithIndex:(int)index
{
    // 删除所有的子view
    for (UIView * subView  in [self.view subviews]) {
        
        if (subView.tag == 2 || subView.tag == 2) {
            [subView removeFromSuperview];
        }
        
    }
    
    // 默认第一行
    tjtcItem * item = [self.tcDropDownArryList objectAtIndex:index];
    
    NSMutableArray * tcNamearray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.tcDropDownArryList count]; i ++)
    {
        tjtcItem * item = [self.tcDropDownArryList objectAtIndex:i];
        [tcNamearray addObject:item.name];
    }
    
    
    NSMutableArray * timeArray = [NSMutableArray array];
    for (NSDictionary *dic in item.timeArray)
    {
        NSMutableString * yuyueStr = [NSMutableString string];
        NSString * str1 = [JSONFormatFunc strValueForKey:@"date" ofDict:dic];
        NSString * str2 = [JSONFormatFunc strValueForKey:@"span" ofDict:dic];
        [yuyueStr appendString:str1];
        [yuyueStr appendString:[NSString stringWithFormat:@"   %@",str2]];
        [timeArray addObject:yuyueStr];
    }
    
    // 重新画View
    [self initDropDownView2withTimeArray:[NSMutableArray arrayWithObject:timeArray] withDetail:item.imgURL];

}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        HDMyYuYueViewController * yuyueVC = [[HDMyYuYueViewController alloc] init];
        [self.navigationController pushViewController:yuyueVC animated:YES];
        
    }else if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    
    if (pullDownMenu.tag == 1)
    {
        self.currentSelectedIndex = (int)row;
        [self reDrowMenu2ViewWithIndex:(int)row];
        
    }else if (pullDownMenu.tag == 2)
    {
        self.currentTimeSelectedIndex = (int)row;
    }
    
    NSLog(@"%ld -- %ld", column, row);
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg = [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        NSArray * tjtcArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [tjtcArray count] >0)
        {
            
            [self.tcDropDownArryList removeAllObjects];
            
            
            
            for (int i = 0; i < [tjtcArray count]; i ++)
            {
                NSDictionary * dic = [tjtcArray objectAtIndex:i];
                
                tjtcItem * item = [[tjtcItem alloc] init];
                item.detail = [JSONFormatFunc strValueForKey:@"detail" ofDict:dic];
                item.tcid  = [JSONFormatFunc strValueForKey:@"id" ofDict:dic];
                item.name  = [JSONFormatFunc strValueForKey:@"name" ofDict:dic];
                item.timeArray  = [[NSMutableArray alloc] initWithArray:[JSONFormatFunc arrayValueForKey:@"times" ofDict:dic]];
                item.imgURL = [JSONFormatFunc strValueForKey:@"image" ofDict:dic];
               
                [self.tcDropDownArryList addObject:item];
                
            }
            
            // 重新画view
            [self reDrowViewWithIndex:0];
            
            
        }else if (code == -302) // 尚未登录，可能被踢出
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，请重新登录！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
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
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
//        NSLog(@"responseData11= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        if (code == 1)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预约成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            alertView.tag = 2;
            [alertView show];
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
