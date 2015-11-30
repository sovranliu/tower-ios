//
//  HDUIWebViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15/9/29.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "HDUIWebViewController.h"

@interface HDUIWebViewController ()

@end

@implementation HDUIWebViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"web";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    
}

- (void)loadUIData
{
//    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    
//    [self initMineinofTableView];
    
    // 请求
    //
    //[self requestURL];
    //user-platform-web-1.0.0/rest/user/myWallet?token=[0]
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 69)];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    NSString * urlddsrt = @"http://cdn.oss.wehop-resources.wehop.cn/well-risk/sites/v-1/index.html#/form?";
    
    NSString * tokenStr = [NSString stringWithFormat:@"%@",@"token＝2b878e3f-eb08-4556-9c78-587a985845bd"];
    
    NSString *tokensrt=[tokenStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *totoal = [NSString stringWithFormat:@"%@%@",urlddsrt,tokensrt];
    
    NSURL *weburl = [NSURL URLWithString:totoal];

    
//    NSURL *url =[NSURL URLWithString:@"http://cdn.oss.wehop-resources.wehop.cn/user/sites/health-data/v-1/index.html?token＝2b878e3f-eb08-4556-9c78-587a985845bd"];
    NSLog(@"url = %@",weburl);
    
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:weburl];
    
    [self.webView loadRequest:request];
    
}

- (void)initMineinofTableView
{
//    self.reveiveFamilyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH- 64) style:UITableViewStylePlain];
//    [self.reveiveFamilyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    self.reveiveFamilyTableView.delegate = self;
//    self.reveiveFamilyTableView.dataSource = self;
//    self.reveiveFamilyTableView.showsHorizontalScrollIndicator = NO;
//    self.reveiveFamilyTableView.showsVerticalScrollIndicator= NO;
//    self.reveiveFamilyTableView.bounces = YES;
//    //    self.mineMoneyPackTableView.allowsSelection = NO;
//    self.reveiveFamilyTableView.alwaysBounceVertical = NO;
//    self.reveiveFamilyTableView.alwaysBounceHorizontal = NO;
//    [self.view addSubview:self.reveiveFamilyTableView];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 69)];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSLog(@"url = %@",urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"errot = %@",error.description);
    
//    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alterview show];
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
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
