//
//  HDForgetPwdViewController.m
//  HDMedical
//
//  Created by David on 14-12-18.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "HDForgetPwdViewController.h"
#import "Utils.h"

@interface HDForgetPwdViewController ()

@end

@implementation HDForgetPwdViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.title      = @"找回密码";
    }
    return self;
}

- (void)loadUIData
{
    UITextField * phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, kScreenW - 40, 40)];
    phoneNumField.placeholder = @"邮箱或手机";
    phoneNumField.delegate = self;
    phoneNumField.tag = 11;
    [phoneNumField setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:phoneNumField];
    
//    UITextField * nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, kScreenW - 40, 40)];
//    nameField.placeholder = @"用户名";
//    nameField.delegate = self;
//    nameField.tag = 12;
//    [nameField setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:nameField];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(20, 150, kScreenW - 40, 40)];
    [confirmBtn addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:120.0/255.0 blue:159.0/255.0 alpha:1.0]];
    [self.view addSubview:confirmBtn];
}

- (void)forgetPwdAction:(id)sender
{
    NSLog(@"forgetPwdAction");
    
    UITextField * textField =  (UITextField *)[self.view viewWithTag:11];
//    UITextField * pwdField =  (UITextField *)[self.view viewWithTag:12];
    NSString *phoneNum = textField.text;
//    NSString *pwdStr = pwdField.text;
    if (![Utils checkPhoneNumInput:phoneNum]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不对，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
//    if ([pwdStr length] == 0) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
    
    //首部
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:4];
    [paramDic setObject:@"forgetPass" forKey:@"action"];
    [paramDic setObject:@"" forKey:@"token"];
    [paramDic setObject:@"" forKey:@"version"];
    
    
    
    //确切参数
    NSMutableDictionary * subParamDic =[[NSMutableDictionary alloc] initWithCapacity:3];
    NSLog(@"pphone = %@",phoneNum);
    [subParamDic setObject:phoneNum forKey:@"act"];
    [subParamDic setObject:phoneNum forKey:@"phone"];
    
    [paramDic setObject:subParamDic forKey:@"arg"];
    
    //转化为json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String: %@",jsonString);
    
    //总参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:jsonString forKey:@"param"];
    
//    // 发送数据
//    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:kLCBUserDefineURL userInfo:totalParamDic withReqTag:1];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    NSLog(@"forget pws responseData = %@",responseData);
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)// 发送验证码
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseData objectForKey:@"code"] integerValue] == 0 )// 发送验证码成功
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码已发送，稍后请登录！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
    }
    
}

@end
