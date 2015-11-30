//
//  HDYuYueDocViewController.m
//  HDMedical
//
//  Created by David on 15-9-16.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDYuYueDocViewController.h"
#import "UIView+Positioning.h"
#import "JSONFormatFunc.h"
#import "HDMyYuYueViewController.h"

@interface HDYuYueDocViewController ()

@end

@implementation HDYuYueDocViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"选择预约时间";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    
    self.yuyueDocTimeArray = [NSMutableArray array];
    //[self.yuyueDocTimeArray addObject:@" dddd"];
    
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    //[self initsubViewsWithArrayList:[NSMutableArray arrayWithObject:self.yuyueDocTimeArray] ];
    // 请求
    [self requestURL];
}


- (void)initsubViewsWithArrayList:(NSMutableArray *) array
{
    
    UILabel * tipLabel = [[UILabel alloc] init];
    [tipLabel setFrame:CGRectMake(15, 15, kScreenW, 30)];
    [tipLabel setText:@"选择预约时间:"];
    [tipLabel setFont:[UIFont systemFontOfSize:16.0]];
    [tipLabel setTextColor:[UIColor blackColor]];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:tipLabel];
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:array selectedColor:UIColorFromRGB(0x7d7d7d) withTableFrame:CGRectMake(15, 10, kScreenW- 30, 0)];
    menu.tag = 1;
    menu.tableViewRowNum = 5;
    [menu setBackgroundColor:[UIColor whiteColor]];
    menu.delegate = self;
    menu.frame = CGRectMake(15, tipLabel.bottom + 5,kScreenW -30, menu.frame.size.height);
    [self.view addSubview:menu];
    
    UILabel * infoLabel = [[UILabel alloc] init];
    [infoLabel setFrame:CGRectMake(15, 0, kScreenW, 30)];
    [infoLabel setY:menu.bottom + 10];
    [infoLabel setText:@"填写预约附属信息:"];
    [infoLabel setFont:[UIFont systemFontOfSize:16.0]];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:infoLabel];
    
    // contentView
    UITextView * contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, infoLabel.bottom + 10, kScreenW - 30, 120)];
    contentView.delegate = self;
    contentView.tag = 3;
    [contentView.layer setCornerRadius:5.0];
    [self.view addSubview:contentView];
    
    
    // 提交按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确     认" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setFrame:CGRectMake(25, kScreenH - 49 - 100, kScreenW - 50, 40)];
    [self.view addSubview:sureBtn];
    [sureBtn.layer setCornerRadius:3.0];
    
    /*
    // 预约时间
    UILabel * yuyueTime = [[UILabel alloc] init];
    [yuyueTime setFrame:CGRectMake(15, 10, 40, 36)];
    [yuyueTime setText:@"请选择预约时间:"];
    [yuyueTime setFont:[UIFont systemFontOfSize:14.0]];
    [yuyueTime setTextColor:[UIColor blackColor]];
    [yuyueTime setTextAlignment:NSTextAlignmentLeft];
    [yuyueTime setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:yuyueTime];
    
    //画下拉列表
    self.yuyueDropMenu = [[MXPullDownMenu alloc] initWithArray:array selectedColor:UIColorFromRGB(0x7d7d7d) withTableFrame:CGRectMake(yuyueTime.right, 10, kScreenW- 110, 0)];
    self.yuyueDropMenu.tableViewRowNum = 5;
    [self.yuyueDropMenu setBackgroundColor:[UIColor whiteColor]];
    self.yuyueDropMenu.delegate = self;
    self.yuyueDropMenu.frame = CGRectMake(yuyueTime.right, yuyueTime.y,kScreenW-110, self.yuyueDropMenu.frame.size.height);
    [self.view addSubview:self.yuyueDropMenu];
    
    // 画线
    UIView * lineGap = [[UIView alloc] initWithFrame:CGRectMake(0, self.yuyueDropMenu.bottom + 10, kScreenW, 0.5)];
    [lineGap setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineGap];
    
    
    // 备注
    UILabel * beizhu = [[UILabel alloc] init];
    [beizhu setFrame:CGRectMake(15, lineGap.bottom +3, 40, 36)];
    [beizhu setText:@"备注:"];
    [beizhu setFont:[UIFont systemFontOfSize:14.0]];
    [beizhu setTextColor:[UIColor blackColor]];
    [beizhu setTextAlignment:NSTextAlignmentLeft];
    [beizhu setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:beizhu];
    
    // 备注内容
    UILabel * beizhuContent = [[UILabel alloc] init];
    [beizhuContent setFrame:CGRectMake(beizhu.right + 5, lineGap.bottom +3, kScreenW - 80, 36)];
    [beizhuContent setText:@"dfdslfjsdlfjs;dlfj;ladjfls;"];
    [beizhuContent setFont:[UIFont systemFontOfSize:13.0]];
    [beizhuContent setTextColor:[UIColor blackColor]];
    [beizhuContent setTextAlignment:NSTextAlignmentLeft];
    [beizhuContent setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:beizhuContent];
    
    // 画线
    UIView * lineGap1 = [[UIView alloc] initWithFrame:CGRectMake(0, beizhuContent.bottom + 10, kScreenW, 0.5)];
    [lineGap1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineGap1];
    
    
    // 提交按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确     认" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setFrame:CGRectMake(25, kScreenH - 49 - 100, kScreenW - 50, 40)];
    [self.view addSubview:sureBtn];
    [sureBtn.layer setCornerRadius:3.0];
     
     */

}

- (void)requestURL
{
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicaldoctorTime];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    
    [totalParamDic setObject:self.doctorID forKey:@"doctorId"];
    //[totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    NSLog(@"self.doctorId = %@,token =%@",self.doctorID,[DataEngine sharedDataEngine].deviceToken);
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
}

- (void)sureBtnAction:(id)sender
{
    NSLog(@"sureBtnAction");
    
    NSString *timeAndSpan = [self.yuyueDocTimeArray objectAtIndex:self.currentSelectedIndex];
    NSLog(@"timeand su = %@",timeAndSpan);
    
    NSArray * tmpArr = [timeAndSpan componentsSeparatedByString:@"   "];
//    
    for (NSString * str in tmpArr)
    {
        NSLog(@"str = %@",str);
    }
    
    UITextView *textView = (UITextView *)[self.view viewWithTag:3];
    NSString * contentText = textView.text;
    NSLog(@"contentText = %@",contentText);
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicaldoctorTimeOrder];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[tmpArr objectAtIndex:0] forKey:@"date"];
    [totalParamDic setObject:[tmpArr objectAtIndex:1] forKey:@"span"];
    [totalParamDic setObject:contentText forKey:@"memo"];
    [totalParamDic setObject:self.doctorID forKey:@"doctorId"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    NSLog(@"baseURL =%@,TOtalDIc = %@",baseUrl,totalParamDic);
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
    
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    if (pullDownMenu.tag == 1)
    {
        self.currentSelectedIndex = (int)row;
    }
    
    NSLog(@"%ld -- %ld", column, row);
}

#pragma mark -alertView 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        [self.navigationController popViewControllerAnimated:YES];
        HDMyYuYueViewController * yuyueVC = [[HDMyYuYueViewController alloc] init];
        [self.navigationController pushViewController:yuyueVC animated:YES];
    }
    
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * timeArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [timeArray count] >0)
        {
            
            [self.yuyueDocTimeArray removeAllObjects];
            for (NSDictionary *dic in timeArray)
            {
                NSMutableString * yuyueStr = [NSMutableString string];
                NSString * str1 = [JSONFormatFunc strValueForKey:@"date" ofDict:dic];
                NSString * str2 = [JSONFormatFunc strValueForKey:@"span" ofDict:dic];
                [yuyueStr appendString:str1];
                [yuyueStr appendString:[NSString stringWithFormat:@"   %@",str2]];
                [self.yuyueDocTimeArray addObject:yuyueStr];
            }
            
            for (UIView * subView in [self.view subviews])
            {
                [subView removeFromSuperview];
            }
            
            [self initsubViewsWithArrayList:[NSMutableArray arrayWithObject:self.yuyueDocTimeArray]];
        }
    }else if (vc == self && [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        NSLog(@"responseData11= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        if (code >0)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
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
