//
//  SelfCheckTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-7.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "SelfCheckTableViewCell.h"
#import "UIView+Positioning.h"

@implementation SelfCheckTableViewCell

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
    if (self.sickName == nil) {
        self.sickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [self.sickName setBackgroundColor:[UIColor clearColor]];
        [self.sickName setX:10];
        [self.sickName setY:10];
        
        [self.sickName setTextAlignment:NSTextAlignmentLeft];
        [self.sickName setTextColor:[UIColor blackColor]];
        [self.sickName setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.sickName];
    }
    
    if (self.sickNameDetail == nil)
    {
        self.sickNameDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        [self.sickNameDetail setBackgroundColor:[UIColor clearColor]];
        [self.sickNameDetail setX:10];
        [self.sickNameDetail setY:self.sickName.bottom];
        
        [self.sickNameDetail setTextAlignment:NSTextAlignmentLeft];
        [self.sickNameDetail setTextColor:[UIColor lightGrayColor]];
        [self.sickNameDetail setFont:[UIFont systemFontOfSize:14.0]];
        self.sickNameDetail.numberOfLines = 2;
        
        [self addSubview:self.sickNameDetail];
    }

    
}

@end
