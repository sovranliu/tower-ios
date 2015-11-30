//
//  FamilyTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-8-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "FamilyTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"

@implementation FamilyTableViewCell
@synthesize familyImgsView;
@synthesize familyNickNameLabel;
@synthesize familyNameAndPhoneLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creat];
    }
    return self;
}

- (void)creat{
    
    
    if (self.rightBtn == nil) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setFrame:CGRectMake(kScreenW - 80, 20, 60, 30)];
        [self.rightBtn.layer setCornerRadius:5.0];
        [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.rightBtn setBackgroundColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:55.0/255.0 alpha:1.0]];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
    }
    
    if (self.familyImgsView == nil) {
        self.familyImgsView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 45, 45)];
        [self addSubview:self.familyImgsView];
    }
    
    if (self.familyNickNameLabel == nil)
    {
        self.familyNickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        [self.familyNickNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.familyNickNameLabel setX:self.familyImgsView.x +self.familyImgsView.width + 35];
        [self.familyNickNameLabel setY:self.familyImgsView.y - 10];
        
        [self.familyNickNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.familyNickNameLabel setTextColor:[UIColor lightGrayColor]];
        [self.familyNickNameLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        [self addSubview:self.familyNickNameLabel];
    }
    
    if (self.familyNameAndPhoneLabel == nil)
    {
        self.familyNameAndPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 15)];
        [self.familyNameAndPhoneLabel setX:self.familyImgsView.x +self.familyImgsView.width + 35];
        [self.familyNameAndPhoneLabel setY:self.familyImgsView.bottom - 15];
        
        [self.familyNameAndPhoneLabel setTextAlignment:NSTextAlignmentLeft];
        [self.familyNameAndPhoneLabel setTextColor:[UIColor blackColor]];
        [self.familyNameAndPhoneLabel setFont:[UIFont systemFontOfSize:15.0]];
        self.familyNameAndPhoneLabel.numberOfLines = 1;
        
        [self addSubview:self.familyNameAndPhoneLabel];
    }
    
}

- (void)rightBtnAction1:(id)sender
{
    UIButton * btn = sender;
    [self.rightBtnDelegate rightBtnAction:btn.tag];
}

@end
