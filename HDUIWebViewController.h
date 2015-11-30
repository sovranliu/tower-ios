//
//  HDUIWebViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15/9/29.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDUIWebViewController : CMViewController<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)NSString * urlStr;

- (void)loadWebPageWithString:(NSString*)urlString;
@end
