//
//  MyMoneyTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MyMoneyTableViewCell.h"
#import "UIView+Positioning.h"

@implementation MyMoneyTableViewCell

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

    
    if (self.leftImgView == nil) {
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2.5, 5, 85)];
        [self addSubview:self.leftImgView];
    }
    
    if (self.moneySysLable == nil)
    {
        self.moneySysLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [self.moneySysLable setBackgroundColor:[UIColor clearColor]];
        [self.moneySysLable setX:self.leftImgView.right + 10];
        [self.moneySysLable setY:45];
        
        [self.moneySysLable setTextAlignment:NSTextAlignmentLeft];
        [self.moneySysLable setTextColor:[UIColor colorWithRed:223.0/255.0 green:171.0/255.0 blue:36.0/255.0 alpha:1.0]];
        [self.moneySysLable setFont:[UIFont systemFontOfSize:12.0]];
        
        [self addSubview:self.moneySysLable];
    }
    
    if (self.moneyNumLable == nil)
    {
        self.moneyNumLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [self.moneyNumLable setX:self.moneySysLable.right + 15];
        [self.moneyNumLable setY:30];
        
        [self.moneyNumLable setTextAlignment:NSTextAlignmentLeft];
        [self.moneyNumLable setTextColor:[UIColor colorWithRed:239.0/255.0 green:181.0/255.0 blue:87.0/255.0 alpha:1.0]];
        [self.moneyNumLable setFont:[UIFont systemFontOfSize:30.0]];
        
        [self addSubview:self.moneyNumLable];
    }
    
    if (self.moneyYuanLable == nil)
    {
        self.moneyYuanLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        [self.moneyYuanLable setX:self.moneyNumLable.right + 5];
        [self.moneyYuanLable setY:45];
        
        [self.moneyYuanLable setTextAlignment:NSTextAlignmentLeft];
        [self.moneyYuanLable setTextColor:[UIColor lightGrayColor]];
        [self.moneyYuanLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.moneyYuanLable];
    }
    
    if (self.gapImgView == nil)
    {
        self.gapImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
        [self.gapImgView setX:self.moneyYuanLable.right + 10];
        [self.gapImgView setY:5];
        [self addSubview:self.gapImgView];
    }
    
    if(self.honBaoLable == nil)
    {
        self.honBaoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
        [self.honBaoLable setX:self.gapImgView.x + 20];
        [self.honBaoLable setY:10];
        [self.honBaoLable setTextColor:[UIColor blackColor]];
        [self.honBaoLable setTextAlignment:NSTextAlignmentLeft];
        [self.honBaoLable setTextColor:[UIColor blackColor]];
        [self.honBaoLable setFont:[UIFont systemFontOfSize:22.0]];
        [self addSubview:self.honBaoLable];
    }
    
    if (self.bankLable == nil)
    {
        self.bankLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [self.bankLable setX:self.honBaoLable.x];
        [self.bankLable setY:self.honBaoLable.bottom + 5];
        [self.bankLable setTextColor:[UIColor blackColor]];
        [self.bankLable setTextAlignment:NSTextAlignmentLeft];
        [self.bankLable setTextColor:[UIColor lightGrayColor]];
        [self.bankLable setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:self.bankLable];
    }
    
    if (self.timeLable == nil)
    {
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
        [self.timeLable setX:self.bankLable.x];
        [self.timeLable setY:self.bankLable.bottom ];
        [self.timeLable setTextColor:[UIColor blackColor]];
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor lightGrayColor]];
        [self.timeLable setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:self.timeLable];
    }
    
}


@end
