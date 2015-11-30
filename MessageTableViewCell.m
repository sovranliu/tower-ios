//
//  MessageTableViewCell.m
//  HDMedical
//
//  Created by David on 15-9-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"

@implementation MessageTableViewCell


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
        self.redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 10, 10)];
        [self.redImageView setY:cellheight/2.0- 2.5];
        [self addSubview:self.redImageView];
    }
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:self.redImageView.right + 5];
        [self.tilteLable setY:15];
        
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.tilteLable];
    }
    
    if (self.timeLable == nil)
    {
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [self.timeLable setX:kScreenW - 100];
        [self.timeLable setY:60];
        
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor lightGrayColor]];
        [self.timeLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.timeLable];
    }
    
}

@end
