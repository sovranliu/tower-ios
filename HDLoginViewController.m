//
//  HDLoginViewController.m
//  HDMedical
//
//  Created by David on 14-12-17.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "HDLoginViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "HDRegisterViewController.h"
#import "HDForgetPwdViewController.h"

//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
#import "UIView+Positioning.h"

#import "Utils.h"
#import "CustomTextField.h"

#import "JSONFormatFunc.h"

@interface HDLoginViewController ()
- (void)timeFireMethod;
@end

@implementation HDLoginViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"登录";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initExtendedData
{
    
}

- (void)fireMessageAction:(id)sender
{
    NSLog(@"fireMessageAction");
    
    UITextField * textField =  (UITextField *)[self.view viewWithTag:11];
    NSString *phoneNum = textField.text;
    if (![Utils checkPhoneNumInput:phoneNum]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不对，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicalFetchCode];
    
    // 参数
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [paramDic setObject:phoneNum forKey:@"phone"];

    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:paramDic withReqTag:1];
    
    [self timeFireMethod];

}

- (void)timeFireMethod
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton * btn = (UIButton *)[self.view viewWithTag:10];
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
//                btn.enabled = YES;
                btn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton * btn = (UIButton *)[self.view viewWithTag:10];
                [btn setTitle:strTime forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)loadUIData
{
     [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    // 右item
//    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [logBtn setFrame:CGRectMake(kScreenW - 50, 30, 40, 30)];
//    [logBtn setTitle:@"注册" forState:normal];
//    [logBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [logBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logBtn];
//    self.navigationItem.rightBarButtonItem = releaseButtonItem;
  
    // 左item
    UIButton *backActionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backActionBtn setFrame:CGRectMake(10, 30, 40, 30)];
    [backActionBtn setTitle:@"回退" forState:normal];
    [backActionBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [backActionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backActionBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backActionBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    
    UIView * textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 89)];
    [textFieldBg setBackgroundColor:[UIColor whiteColor]];
    
    CustomTextField * phoneNumField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 110, 44)];
    phoneNumField.placeholder = @"请输入手机号码";
    phoneNumField.delegate = self;
    phoneNumField.tag = 11;
    [phoneNumField setKeyboardType:UIKeyboardTypeNumberPad];
    [phoneNumField setBackgroundColor:[UIColor whiteColor]];
    [textFieldBg addSubview:phoneNumField];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(phoneNumField.x + phoneNumField.width , 5, 100, 35)];
    [confirmBtn addTarget:self action:@selector(fireMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:114.0/255.0 blue:190.0/255.0 alpha:1.0]];
    confirmBtn.tag = 10;
    [textFieldBg addSubview:confirmBtn];
    
    // 中间的线
    UIView *linegap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    [linegap setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [textFieldBg addSubview:linegap];
    [linegap setY:phoneNumField.height + phoneNumField.y];
    
    
    CustomTextField * messageField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 110, 44)];
    [messageField setY:phoneNumField.y + phoneNumField.height +1];
    messageField.placeholder = @"请输入验证码";
    [messageField setKeyboardType:UIKeyboardTypeNumberPad];
    messageField.delegate = self;
    messageField.tag = 12;
    [messageField setBackgroundColor:[UIColor whiteColor]];
    [textFieldBg addSubview:messageField];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake(messageField.x + messageField.width , messageField.y + 5, 100, 35)];
    [sureBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:114.0/255.0 blue:190.0/255.0 alpha:1.0]];
    [textFieldBg addSubview:sureBtn];
    
    [self.view addSubview:textFieldBg];
    
//    UITextField * pwsField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, kScreenW - 40, 40)];
//    pwsField.placeholder = @"密码";
//    pwsField.delegate = self;
//    pwsField.tag = 12;
//    [pwsField setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:pwsField];
    
//    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmBtn setFrame:CGRectMake(20, 150, kScreenW - 40, 40)];
//    [confirmBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
//    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [confirmBtn setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:120.0/255.0 blue:159.0/255.0 alpha:1.0]];
//    [self.view addSubview:confirmBtn];
    
    
//    UIButton * forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [forgetPwdBtn setFrame:CGRectMake(kScreenW- 80, 200, 60, 40)];
//    [forgetPwdBtn addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
//    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [forgetPwdBtn setTitleColor:UIColorFromRGB(0x5699cb) forState:UIControlStateNormal];
//    [forgetPwdBtn setFont:[UIFont systemFontOfSize:15.0]];
//    [forgetPwdBtn setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:forgetPwdBtn];
    
/*
    // 微信


//    UIButton * wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [wxLoginBtn setFrame:CGRectMake(offxspace, kScreenH - kSysNavBarHeight - 80, btnWidth, 40)];
//    [wxLoginBtn addTarget:self action:@selector(wxLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [wxLoginBtn setTitle:@"微信" forState:UIControlStateNormal];
//    [wxLoginBtn setBackgroundColor:[UIColor grayColor]
//     ];
//    [self.view addSubview:wxLoginBtn];
    
    float lineWidth = 80; //第三方登陆提示的宽度
    float offxlinespace = (kScreenW -  (80 + 10))/2.0; //btn离边界
    
    UILabel * seprateLineLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - kSysNavBarHeight - 180 , offxlinespace, 1)];
    [seprateLineLeft setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
    
    UILabel * seprateLineInfo = [[UILabel alloc] initWithFrame:CGRectMake(seprateLineLeft.frame.size.width + 5, kScreenH - kSysNavBarHeight - 187.5 , lineWidth, 15)];
    [seprateLineInfo setText:@"第三方登录"];
    [seprateLineInfo setTextAlignment:NSTextAlignmentCenter];
    [seprateLineInfo setFont:[UIFont systemFontOfSize:14.0]];
//    [seprateLineInfo setTextColor:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
    [seprateLineInfo setTextColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [seprateLineInfo setBackgroundColor:[UIColor clearColor]];
    
    UILabel * seprateLineRight = [[UILabel alloc] initWithFrame:CGRectMake(seprateLineInfo.frame.origin.x + seprateLineInfo.frame.size.width + 5 , kScreenH - kSysNavBarHeight - 180, offxlinespace, 1)];
    [seprateLineRight setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]];
    [self.view addSubview:seprateLineLeft];
    [self.view addSubview:seprateLineInfo];
    [self.view addSubview:seprateLineRight];
    
    
    
    float btnWidth = 60; //btn的宽度
    float offxspace = (kScreenW - ( 60 * 2 + 40))/2.0; //btn离边界
    // qq
    UIButton * qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqLoginBtn setBackgroundColor:[UIColor clearColor]];
    [qqLoginBtn setFrame:CGRectMake(offxspace, kScreenH - kSysNavBarHeight - 160, btnWidth, 60)];
    [qqLoginBtn addTarget:self action:@selector(qqLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [self.view addSubview:qqLoginBtn];
    
    UILabel * qqLoginInfo = [[UILabel alloc] initWithFrame:CGRectMake(offxspace, kScreenH - kSysNavBarHeight - 160 + 60 + 10 , btnWidth, 20)];
    [qqLoginInfo setText:@"QQ"];
    [qqLoginInfo setTextAlignment:NSTextAlignmentCenter];
    [qqLoginInfo setFont:[UIFont systemFontOfSize:15.0]];
    [qqLoginInfo setTextColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [qqLoginInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:qqLoginInfo];
    
    // sina
    UIButton * sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sinaLoginBtn setFrame:CGRectMake(qqLoginBtn.frame.origin.x + btnWidth + 40, kScreenH - kSysNavBarHeight - 160 , btnWidth, 60)];
    [sinaLoginBtn addTarget:self action:@selector(sinaLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sinaLoginBtn setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    [sinaLoginBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sinaLoginBtn];
    
    
    UILabel * sinaLoginInfo = [[UILabel alloc] initWithFrame:CGRectMake(qqLoginBtn.frame.origin.x + btnWidth + 40, kScreenH - kSysNavBarHeight - 160 + 60 + 10, btnWidth, 20)];
    [sinaLoginInfo setText:@"微博"];
    [sinaLoginInfo setTextAlignment:NSTextAlignmentCenter];
    [sinaLoginInfo setFont:[UIFont systemFontOfSize:15.0]];
    [sinaLoginInfo setTextColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [sinaLoginInfo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sinaLoginInfo];
 
 
 */

}

- (void)loginAction:(id)sender
{

    UITextField * textField =  (UITextField *)[self.view viewWithTag:11];
    UITextField * pwdField =  (UITextField *)[self.view viewWithTag:12];
    NSString *phoneNum = textField.text;
    NSString *pwdStr = pwdField.text;
    if (![Utils checkPhoneNumInput:phoneNum]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不对，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([pwdStr length] == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //总参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:phoneNum forKey:@"phone"];
    [totalParamDic setObject:pwdStr forKey:@"code"];
    
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl appendString:KHDMedicalLogin];
//    [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)forgetPwdAction:(id)sender
{
     NSLog(@"forgetPwdAction");
    HDForgetPwdViewController * forgetPwdVC = [[HDForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (void)registerBtnAction:(id)sender
{
    NSLog(@"registerBtnAction");
    HDRegisterViewController * regVC = [[HDRegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}
- (void)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
// 返回一个bool值，指明是否允许在按下回车键时结束编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 11)
    {
        [textField resignFirstResponder];
        [[self.view viewWithTag:12] becomeFirstResponder];
    }
    else if (textField.tag == 12)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg =[JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];         NSLog(@"code = %d,msg =%@",code,msg);
        if (code == 1)
        {
            NSLog(@"验证码发成功");
            
        }
    }else if (vc == self && [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"response Data = %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg =[JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];   
        NSLog(@"code = %d,msg =%@",code,msg);
        if (code == 1) // 登陆成功
        {
            
            NSMutableDictionary * logindata = [responseData objectForKey:@"data"];
            NSString * deviceToken = [logindata objectForKey:@"token"];
            NSString * userId      = [logindata objectForKey:@"userGlobalId"];
            NSString * phoneNum      = [logindata objectForKey:@"name"];
            NSLog(@"token = %@,name = %@,photo =%@,userId = %@",[logindata objectForKey:@"token"],[logindata objectForKey:@"name"],[logindata objectForKey:@"photo"],[logindata objectForKey:@"userGlobalId"]);
            

            [DataEngine sharedDataEngine].isLogin = YES;
            [DataEngine sharedDataEngine].deviceToken = deviceToken;
            [DataEngine sharedDataEngine].userId = userId;
            [DataEngine sharedDataEngine].phoneNum = phoneNum;
            
            // 保存本地，记录登陆状态
            [[DataEngine sharedDataEngine] saveUserBaseInfoData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalAlreadLogin object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else if (code == -103) // 验证码错误
        {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误，请重新输入！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
