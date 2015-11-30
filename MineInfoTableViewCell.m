//
//  MineInfoTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-17.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MineInfoTableViewCell.h"
#import "UIView+Positioning.h"

@implementation MineInfoTableViewCell

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
    
    if (self.nameTitle == nil)
    {
        self.nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 40)];
        [self.nameTitle setBackgroundColor:[UIColor clearColor]];
        [self.nameTitle setTextAlignment:NSTextAlignmentLeft];
        [self.nameTitle setTextColor:[UIColor blackColor]];
        [self.nameTitle setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:self.nameTitle];
    }
    
    if (self.nameContent == nil)
    {
        self.nameContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [self.nameContent setX:self.nameTitle.right];
        [self.nameContent setY:self.nameTitle.y];
        [self.nameContent setTextAlignment:NSTextAlignmentLeft];
        [self.nameContent setTextColor:[UIColor lightGrayColor]];
        [self.nameContent setFont:[UIFont systemFontOfSize:14.0]];
        
        [self addSubview:self.nameContent];
    }
    
}

@end
