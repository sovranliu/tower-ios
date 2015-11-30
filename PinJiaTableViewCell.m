//
//  PinJiaTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-2.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "PinJiaTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"

@implementation PinJiaTableViewCell

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
    if (self.nickName == nil) {
        self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.nickName setBackgroundColor:[UIColor clearColor]];
        [self.nickName setX:10];
        [self.nickName setY:5];
        
        [self.nickName setTextAlignment:NSTextAlignmentLeft];
        [self.nickName setTextColor:[UIColor lightGrayColor]];
        [self.nickName setFont:[UIFont systemFontOfSize:14.0]];
        
        [self addSubview:self.nickName];
    }
    
    if (self.date == nil)
    {
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 155, 20)];
        [self.date setBackgroundColor:[UIColor clearColor]];
        [self.date setX:kScreenW - 145];
        [self.date setY:5];
        [self.date setTextAlignment:NSTextAlignmentLeft];
        [self.date setTextColor:[UIColor lightGrayColor]];
        [self.date setFont:[UIFont systemFontOfSize:14.0]];
        
        [self addSubview:self.date];
    }
    
    if (self.pinjiaDetail == nil)
    {
        self.pinjiaDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 20, 15)];
        [self.pinjiaDetail setX:self.nickName.x];
        [self.pinjiaDetail setY:self.nickName.bottom];
        
        [self.pinjiaDetail setTextAlignment:NSTextAlignmentLeft];
        [self.pinjiaDetail setTextColor:[UIColor grayColor]];
        [self.pinjiaDetail setFont:[UIFont systemFontOfSize:14.0]];
        self.pinjiaDetail.numberOfLines = 0;
        
        [self addSubview:self.pinjiaDetail];
    }
    
    if (self.singleLine == nil)
    {
        self.singleLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        [self.singleLine setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        
        [self addSubview:self.singleLine];
    }

}

- (void)setSingleLineFrame:(CGRect)rect
{
    [self.singleLine setFrame:rect];
}
@end
