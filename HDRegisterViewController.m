//
//  HDRegisterViewController.m
//  HDMedical
//
//  Created by David on 14-12-18.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "HDRegisterViewController.h"
#import "Utils.h"

@interface HDRegisterViewController ()

@end

@implementation HDRegisterViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"注册";
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (void)initExtendedData
{
    
}

- (void)loadUIData
{
    
    UITextField * phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, kScreenW - 40, 40)];
    phoneNumField.placeholder = @"请输入您的手机号";
    phoneNumField.delegate = self;
    phoneNumField.tag = 11;
    [phoneNumField setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:phoneNumField];
    
    UITextField * pwsField = [[UITextField alloc] initWithFrame:CGRectMake(20, 85, kScreenW - 40, 40)];
    pwsField.placeholder = @"请输入密码";
    pwsField.delegate = self;
    pwsField.tag = 12;
    [pwsField setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:pwsField];
    
    UITextField * messageField = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, kScreenW - 160, 40)];
    messageField.placeholder = @"请输入短信验证码";
    messageField.delegate = self;
    messageField.tag = 13;
    [messageField setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:messageField];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(kScreenW - 120, 140, 100, 40)];
    [confirmBtn addTarget:self action:@selector(fireMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [confirmBtn setFont:[UIFont systemFontOfSize:14.0]];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:163.0/255.0 blue:216.0/255.0 alpha:1.0]];
    confirmBtn.tag = 10;
    [self.view addSubview:confirmBtn];
    
    
    UIButton * forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn setFrame:CGRectMake(20, 280, kScreenW - 40, 40)];
    [forgetPwdBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    [forgetPwdBtn setFont:[UIFont systemFontOfSize:16.0]];
    [forgetPwdBtn setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:120.0/255.0 blue:159.0/255.0 alpha:1.0]];
    [self.view addSubview:forgetPwdBtn];

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
    
    [self timeFireMethod];
    
    //首部
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:4];
    [paramDic setObject:@"sendMessage" forKey:@"action"];
    [paramDic setObject:@"201503061043" forKey:@"requestTime"];
    //[paramDic setObject:@"" forKey:@"token"];
    [paramDic setObject:@"1.0" forKey:@"version"];
    
    //确切参数
    NSMutableDictionary * subParamDic =[[NSMutableDictionary alloc] initWithCapacity:3];
    [subParamDic setObject:phoneNum forKey:@"phone"];
    [subParamDic setObject:@"1" forKey:@"toType"];
    [subParamDic setObject:@"1" forKey:@"type"];
    
    
    [paramDic setObject:subParamDic forKey:@"arg"];
    
    //转化为json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String: %@",jsonString);
    
    //总参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:jsonString forKey:@"param"];
//    NSMutableString * codeStr = [NSMutableString stringWithString:kLCBUserDefineURL];
//    [codeStr appendString:jsonString];
    
//    // 发送数据
//    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:kLCBUserDefineURL userInfo:totalParamDic withReqTag:1];
    
}

- (void)registerAction:(id)sender
{
    NSLog(@"registerAction");
    UITextField * textField =  (UITextField *)[self.view viewWithTag:11];
    UITextField * pwdField =  (UITextField *)[self.view viewWithTag:12];
    UITextField * yzmField =  (UITextField *)[self.view viewWithTag:13];
    
    NSString *phoneNum = textField.text;
    NSString *pwdStr = pwdField.text;
    NSString *yzmStr = yzmField.text;
    
    if (![Utils checkPhoneNumInput:phoneNum]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不对，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([pwdStr length] == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([yzmStr length] == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    //首部
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:4];
    [paramDic setObject:@"register" forKey:@"action"];
    [paramDic setObject:@"201503061043" forKey:@"requestTime"];
    //[paramDic setObject:@"" forKey:@"token"];
    [paramDic setObject:@"1.0" forKey:@"version"];
    
    //确切参数
    NSMutableDictionary * subParamDic =[[NSMutableDictionary alloc] initWithCapacity:4];
    [subParamDic setObject:phoneNum forKey:@"act"];
    [subParamDic setObject:pwdStr forKey:@"pass"];
    [subParamDic setObject:phoneNum forKey:@"phone"];
    [subParamDic setObject:yzmStr forKey:@"code"];
    
    
    [paramDic setObject:subParamDic forKey:@"arg"];
    
    //转化为json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String: %@",jsonString);
    
    //总参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:jsonString forKey:@"param"];
    
//    NSMutableString * codeStr = [NSMutableString stringWithString:kLCBUserDefineURL];
//    [codeStr appendString:jsonString];
    
    // 发送数据
//    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:kLCBUserDefineURL userInfo:totalParamDic withReqTag:2];
//    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
//    [self performSelector:@selector(reflashTargetUI:responseData:withTag:) withObject:nil afterDelay:2.0];
    
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
                btn.enabled = YES;
            });
        }else{
//            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton * btn = (UIButton *)[self.view viewWithTag:10];
                [btn setTitle:strTime forState:UIControlStateNormal];
                btn.enabled = NO;
                
            });
            timeout--;
            
        }  
    });  
    dispatch_resume(_timer);
}

#pragma mark - UITextFieldDelegate
// 返回一个bool值，指明是否允许在按下回车键时结束编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 11)
    {
        [textField resignFirstResponder];
        [[self.view viewWithTag:12] becomeFirstResponder];
        [[self.view viewWithTag:13] resignFirstResponder];
    }
    else if (textField.tag == 12)
    {
        [textField resignFirstResponder];
        [[self.view viewWithTag:11] resignFirstResponder];
        [[self.view viewWithTag:13] becomeFirstResponder];
    }else if (textField.tag == 13)
    {
        [textField resignFirstResponder];
        [[self.view viewWithTag:12] resignFirstResponder];
        [[self.view viewWithTag:13] resignFirstResponder];
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    NSLog(@"responseData = %@",responseData);
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)// 发送验证码
    {
        if ([[responseData objectForKey:@"code"] integerValue] == 0 )// 发送验证码成功
        {
            int code =[[[responseData objectForKey:@"arg"] objectForKey:@"code"] intValue];
            NSLog(@"发送验证码成功,验证码是=%d",code);
        }
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseData objectForKey:@"code"] integerValue] == 0 )// 注册成功
        {
            NSLog(@"注册成功是");
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功，请用注册的账号登录！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
            
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败，请重新注册！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 2;
            [alertView show];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
