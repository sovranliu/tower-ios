//
//  HDAddFamilyWithIDViewController.m
//  HDMedical
//
//  Created by David on 15-8-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDAddFamilyWithIDViewController.h"
#import "UIView+Positioning.h"
#import "CustomTextField.h"
#import "JSONFormatFunc.h"


@interface HDAddFamilyWithIDViewController ()
- (void)initFamilyTextField;
@end

@implementation HDAddFamilyWithIDViewController
@synthesize addFamilyNumlabel;
@synthesize familyRelationField;
@synthesize familyNameField;
//@synthesize familyAgesField;
@synthesize familyIdentityField;
@synthesize familySureBtn;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"添加身份证";
        
    }
    return self;
}


- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [self initFamilyTextField];
}

- (void)initExtendedData
{
    
}


- (void)initFamilyTextField
{
    UIView * textFieldBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    [textFieldBG setBackgroundColor:[UIColor whiteColor]];
    
    self.addFamilyNumlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [self.addFamilyNumlabel setText:@"添加成员"];
    [self.addFamilyNumlabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.addFamilyNumlabel setTextAlignment:NSTextAlignmentLeft];
    [self.addFamilyNumlabel setTextColor:[UIColor blackColor]];
    
    self.familyRelationField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW ,40 )];
    self.familyRelationField.placeholder = @"关系";
    self.familyRelationField.tag = 1;
    self.familyRelationField.delegate = self;
    self.familyRelationField.textAlignment = NSTextAlignmentLeft;
    self.familyRelationField.keyboardType = UIKeyboardTypeDefault;
    self.familyRelationField.font = [UIFont systemFontOfSize:14.0];
    [self.familyRelationField setBackgroundColor:[UIColor whiteColor]];
    
    self.familyNameField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW ,40 )];
    self.familyNameField.placeholder = @"姓名";
    self.familyNameField.tag = 2;
    self.familyNameField.delegate = self;
    self.familyNameField.keyboardType = UIKeyboardTypeDefault;
    self.familyNameField.textAlignment = NSTextAlignmentLeft;
    self.familyNameField.font = [UIFont systemFontOfSize:14.0];
     [self.familyNameField setBackgroundColor:[UIColor whiteColor]];
    
    self.familyIdentityField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW ,40 )];
    self.familyIdentityField.placeholder = @"身份证";
    self.familyIdentityField.tag = 3;
    self.familyIdentityField.delegate = self;
    self.familyIdentityField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.familyIdentityField.textAlignment = NSTextAlignmentLeft;
    self.familyIdentityField.font = [UIFont systemFontOfSize:14.0];
     [self.familyIdentityField setBackgroundColor:[UIColor whiteColor]];
    
//    self.familyAgesField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW ,40 )];
//    self.familyAgesField.placeholder = @"年龄";
//    self.familyAgesField.tag = 4;
//    self.familyAgesField.delegate = self;
//    self.familyAgesField.textAlignment = NSTextAlignmentLeft;
//    self.familyAgesField.keyboardType = UIKeyboardTypeNamePhonePad;
//    self.familyAgesField.font = [UIFont systemFontOfSize:14.0];
//    [self.familyAgesField setBackgroundColor:[UIColor whiteColor]];
    
    self.familySureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.familySureBtn setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:114.0/255.0 blue:190.0/255.0 alpha:1.0]];
    [self.familySureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.familySureBtn.titleLabel.textColor= [UIColor whiteColor];
    self.familySureBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.familySureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addFamilyNumlabel setX:10];
    [self.addFamilyNumlabel setY:0];
    
    [self.familyRelationField setX:0];
    [self.familyRelationField setY:self.addFamilyNumlabel.frame.size.height + self.addFamilyNumlabel.y +1];
    
    [self.familyNameField setX:0];
    [self.familyNameField setY:self.familyRelationField.frame.size.height + self.familyRelationField.y +1];
    
    [self.familyIdentityField setX:0];
    [self.familyIdentityField setY:self.familyNameField.frame.size.height + self.familyNameField.y +1];
    
//    [self.familyAgesField setX:0];
//    [self.familyAgesField setY:self.familyIdentityField.frame.size.height + self.familyIdentityField.y +1];
    
    [self.familySureBtn setFrame:CGRectMake(0, 0, kScreenW - 60, 40)];
    [self.familySureBtn setX:30];
    [self.familySureBtn setY:self.familyIdentityField.frame.size.height + self.familyIdentityField.y + 20];
    
    
    [self.view addSubview:self.addFamilyNumlabel];
    [self.view addSubview:self.familyRelationField];
    [self.view addSubview:self.familyNameField];
    [self.view addSubview:self.familyIdentityField];
//    [self.view addSubview:self.familyAgesField];
    [self.view addSubview:self.familySureBtn];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sureBtnAction:(id)sender
{
    NSLog(@"sureBtnAction");
    
    if([self.familyRelationField.text length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关系不能为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else if ([self.familyNameField.text length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名不能为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else if ([self.familyIdentityField.text length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证不能为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else
    {
        
        //http://121.41.106.35:8080/user-platform-web-1.0.0/rest/user/editowner#token=[0]&userId=[1]&mode=[2]&relation=[3]&name=[4]&idnumber=[5]&age=[6]
        
        NSString * token = [DataEngine sharedDataEngine].deviceToken;
        
        //总参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:token forKey:@"token"];
        //[totalParamDic setObject:token forKey:@"userId"];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"mode"];
        [totalParamDic setObject:self.familyRelationField.text forKey:@"relation"];
        [totalParamDic setObject:self.familyNameField.text forKey:@"name"];
        [totalParamDic setObject:self.familyIdentityField.text forKey:@"idnumber"];
        
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
        [baseUrl appendString:@"/"];
        [baseUrl appendString:KHDMedicaleditowner];
        
        //发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [textField resignFirstResponder];
        [(UITextField *)[self.view viewWithTag:2] becomeFirstResponder];
    }else if (textField.tag == 2)
    {
        [textField resignFirstResponder];
        [(UITextField *)[self.view viewWithTag:3] becomeFirstResponder];
    }else if (textField.tag == 3)
    {
        [textField resignFirstResponder];
        [(UITextField *)[self.view viewWithTag:4] becomeFirstResponder];

    }else if (textField.tag == 4) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ADDFAMILYIDCARDCOMPLETE" object:self.familyRelationField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self && tag == 1 && [responseData isKindOfClass:[NSDictionary class]] )
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg = [JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
        NSLog(@"msg = %@",msg);
        if (code >0)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag= 1;
            [alertView show];

        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag =1;
            [alertView show];
        }
    }
    
}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    
}
@end
