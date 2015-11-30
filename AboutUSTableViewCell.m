//
//  AboutUSTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-25.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "AboutUSTableViewCell.h"
#import "CommonDefine.h"
#import "UIView+Positioning.h"

@implementation AboutUSTableViewCell
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
    float cellheight = 75.0;



    if (self.tilteLable == nil)
    {
    self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.tilteLable setBackgroundColor:[UIColor clearColor]];
    [self.tilteLable setX:15];
    [self.tilteLable setY:cellheight/2.0- 15];
    
    [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
    [self.tilteLable setTextColor:[UIColor lightGrayColor]];
    [self.tilteLable setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:self.tilteLable];
}

if (self.timeLable == nil)
{
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [self.timeLable setX:kScreenW - 180];
    [self.timeLable setY:cellheight/2.0- 15];
    
    [self.timeLable setTextAlignment:NSTextAlignmentRight];
    [self.timeLable setTextColor:[UIColor lightGrayColor]];
    [self.timeLable setFont:[UIFont systemFontOfSize:16.0]];
    
    [self addSubview:self.timeLable];
}
}
@end
