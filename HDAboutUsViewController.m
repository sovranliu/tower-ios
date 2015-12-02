//
//  HDAboutUsViewController.m
//  HDMedical
//
//  Created by David on 15-9-24.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDAboutUsViewController.h"
#import "UIView+Positioning.h"
#import "AboutUSTableViewCell.h"

@interface HDAboutUsViewController ()

@end

@implementation HDAboutUsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"程序版本";
        self.showNav    = YES;
        self.resident   = YES;
        
    }
    return self;
}



- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.programeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 40)];
    [self.programeLable setBackgroundColor:[UIColor clearColor]];

    
    [self.programeLable setTextAlignment:NSTextAlignmentLeft];
    [self.programeLable setTextColor:[UIColor lightGrayColor]];
    [self.programeLable setFont:[UIFont systemFontOfSize:18.0]];
    
    [self.programeLable setText:@"当前版本1.0.6"];
    
    [self.view addSubview:self.programeLable];
}



@end
