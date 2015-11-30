//
//  HDEvaluateViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDEvaluateViewController.h"
#import "UIView+Positioning.h"
#import "JSONFormatFunc.h"
#import "HDDoctorDetailViewController.h"

@interface HDEvaluateViewController ()

@end

@implementation HDEvaluateViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"评价";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.doctorName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW-10, 40)];
    self.doctorName.text = self.docItem.name;
    [self.doctorName setTextAlignment:NSTextAlignmentLeft];
    [self.doctorName setFont:[UIFont systemFontOfSize:16.0]];
    [self.doctorName setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.doctorName];
    
    // UITextView
    //首先定义UITextView
    self.textView = [[UITextView alloc] init];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] CGColor];
    [self.textView.layer setCornerRadius:8.0];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.frame =CGRectMake(10, 40, kScreenW-20, kScreenW-20);
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.hidden = NO;
    self.textView.delegate = self;
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    self.placehoder = [[UILabel alloc] init];
    [self.placehoder setFont:[UIFont systemFontOfSize:14.0]];
    self.placehoder.frame =CGRectMake(15, 40 +5, kScreenW-20, 20);
    self.placehoder.text = @"请输入您对医生的评价建议";
    self.placehoder.enabled = NO;//lable必须设置为不可用
    self.placehoder.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.placehoder];
    
    // 两个点赞功能
    UIButton * goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodBtn setImage:[UIImage imageNamed:@"askdoctor_suggest_good"] forState:UIControlStateHighlighted];
    [goodBtn setImage:[UIImage imageNamed:@"askdoctor_good"] forState:UIControlStateNormal];
    
    [goodBtn addTarget:self action:@selector(goodBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [goodBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:goodBtn];
    [goodBtn setTag:10];
    [goodBtn setX:self.textView.x + 5];
    [goodBtn setY:self.textView.bottom - 60];
    
    UIButton * badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [badBtn setImage:[UIImage imageNamed:@"askdoctor_suggest_bad"] forState:UIControlStateHighlighted];
    [badBtn setImage:[UIImage imageNamed:@"askdoctor_bad"] forState:UIControlStateNormal];
    [badBtn addTarget:self action:@selector(badBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [badBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [badBtn setTag:11];
    [self.view addSubview:badBtn];
    [badBtn setX:goodBtn.x + goodBtn.width + 20];
    [badBtn setY:self.textView.bottom - 60];
    
    // 提交按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setFrame:CGRectMake(0, 0, 80, 30)];
    [self.view addSubview:sureBtn];
    [sureBtn setX:kScreenW - 80 -20];
    [sureBtn setY:self.textView.bottom - 50];
    [sureBtn.layer setCornerRadius:5.0];

}

- (void)initExtendedData
{
    self.goodOrBad = @"true";
}

- (void)sureBtnAction:(id)sender
{
    NSLog(@"submitAction");
    
    NSString *contentStr = self.textView.text;
    
    if ([contentStr length] > 0)
    {
        // 1 请求用户评价
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
        [baseUrl1 appendString:@"/"];
        [baseUrl1 appendString:kHDMedicalcomment];
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        
        [totalParamDic setObject:self.docItem.userGlobalId forKey:@"id"];
        [totalParamDic setObject:contentStr forKey:@"content"];
        [totalParamDic setObject:self.goodOrBad forKey:@"attitude"];
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写评价建议！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

- (void)goodBtnAction:(id)sender
{
    
    UIButton * goodbtn = (UIButton *)[self.view viewWithTag:10];
    UIButton * badbtn = (UIButton *)[self.view viewWithTag:11];
    
    [goodbtn setImage:[UIImage imageNamed:@"askdoctor_suggest_good"] forState:UIControlStateNormal];
    
    [badbtn setImage:[UIImage imageNamed:@"askdoctor_bad"] forState:UIControlStateNormal];
   
    
    self.goodOrBad = @"true";
}

- (void)badBtnAction:(id)sender
{
    UIButton * goodbtn = (UIButton *)[self.view viewWithTag:10];
    UIButton * badbtn = (UIButton *)[self.view viewWithTag:11];
    
    [goodbtn setImage:[UIImage imageNamed:@"askdoctor_good"] forState:UIControlStateNormal];
    
    [badbtn setImage:[UIImage imageNamed:@"askdoctor_suggest_bad"] forState:UIControlStateNormal];
    
    self.goodOrBad = @"false";
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placehoder.text = @"请输入您对医生的评价建议";
    }else{
        self.placehoder.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
//        [(HDDoctorDetailViewController *)self.parentViewController requestDoctorDetailInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg = [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        NSLog(@"msg = %@",msg);
        if (code > 1)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的评价！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
            
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
