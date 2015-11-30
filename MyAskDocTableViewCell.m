//
//  MyAskDocTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-24.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MyAskDocTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"

@implementation MyAskDocTableViewCell


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
    float cellheight = 90.0;
    
    if (self.redImageView == nil) {
        self.redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self addSubview:self.redImageView];
    }
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:self.redImageView.right + 15];
        [self.tilteLable setY:cellheight/2.0- 25];
        
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.tilteLable];
    }
    
    if (self.timeLable == nil)
    {
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [self.timeLable setX:self.redImageView.right + 15];
        [self.timeLable setY:cellheight/2.0+ 10];
        
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor lightGrayColor]];
        [self.timeLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.timeLable];
    }
    
    if (self.tipLable == nil)
    {
        self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [self.tipLable setX:kScreenW - 80];
        [self.tipLable setY:cellheight/2.0- 15];
        
        [self.tipLable setTextAlignment:NSTextAlignmentLeft];
        [self.tipLable setTextColor:[UIColor redColor]];
        [self.tipLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.tipLable];
    }
}

@end
