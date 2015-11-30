//
//  HistoryTalkTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-25.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HistoryTalkTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"

@implementation HistoryTalkTableViewCell

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
    
    if (self.leftImageView == nil) {
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self addSubview:self.leftImageView];
    }
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:self.leftImageView.right + 15];
        [self.tilteLable setY:cellheight/2.0- 15];
        
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.tilteLable];
    }
    
    if (self.timeLable == nil)
    {
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
        [self.timeLable setX:kScreenW - 120];
        [self.timeLable setY:cellheight/2.0- 15];
        
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor lightGrayColor]];
        [self.timeLable setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.timeLable];
    }
}
@end
