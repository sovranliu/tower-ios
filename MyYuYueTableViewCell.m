//
//  MyYuYueTableViewCell.m
//  HDMedical
//
//  Created by David on 15-9-18.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MyYuYueTableViewCell.h"
#import "CommonDefine.h"
#import "UIView+Positioning.h"

@implementation MyYuYueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creat];
    }
    return self;
}

- (void)creat
{
    int cellheight = 90.0;
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:20];
        [self.tilteLable setY:cellheight/2.0- 25];
        
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.tilteLable];
    }
    
    if (self.timeLable == nil)
    {
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        [self.timeLable setX:20];
        [self.timeLable setY:cellheight/2.0+ 10];
        
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor lightGrayColor]];
        [self.timeLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.timeLable];
    }
    
    if (self.rightBtn == nil) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setFrame:CGRectMake(kScreenW - 150, 30, 60, 30)];
        [self.rightBtn.layer setCornerRadius:5.0];
        [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.rightBtn setTitle:@"接受" forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor colorWithRed:1 green:183.0/255.0 blue:126.0/255.0 alpha:1.0]];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
    }
    
    if (self.rightCancelBtn == nil) {
        self.rightCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightCancelBtn setFrame:CGRectMake(kScreenW - 80, 30, 60, 30)];
        [self.rightCancelBtn.layer setCornerRadius:5.0];
        [self.rightCancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.rightCancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.rightCancelBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:103.0/255.0 blue:92.0/255.0 alpha:1.0]];
        [self.rightCancelBtn addTarget:self action:@selector(rightBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightCancelBtn];
    }
    
    if (self.tipLable == nil)
    {
        self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [self.tipLable setBackgroundColor:[UIColor clearColor]];
        [self.tipLable setX:kScreenW - 120];
        [self.tipLable setY:30];
        
        [self.tipLable setTextAlignment:NSTextAlignmentLeft];
        [self.tipLable setTextColor:[UIColor redColor]];
        [self.tipLable setFont:[UIFont systemFontOfSize:16.0]];
        self.tipLable.hidden = YES;
        [self addSubview:self.tipLable];
    }

}


- (void)rightBtnAction1:(id)sender
{
    UIButton * btn = sender;
    [self.rightBtnDelegate rightBtnAction:btn.tag];
}

- (void)rightBtnAction2:(id)sender
{
    UIButton * btn = sender;
    [self.rightCancelBtnDelegate rightCancelBtnAction:btn.tag];
}

- (void)hiddenRightTwoBtnAWithMsg:(NSString *)msg
{
    self.rightBtn.hidden        = YES;
    self.rightCancelBtn.hidden  = YES;
    self.tipLable.hidden        = NO;
    [self.tipLable setText:msg];
}

- (void)showRightTwoBtn
{
    self.rightBtn.hidden        = NO;
    self.rightCancelBtn.hidden  = NO;
    self.tipLable.hidden        = YES;
}

- (void)setTimeLableWidth:(float)width
{
    [self.timeLable setFrame:CGRectMake(self.timeLable.origin.x, self.timeLable.origin.y, width, self.timeLable.size.height)];
}

@end
