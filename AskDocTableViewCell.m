//
//  AskDocTableViewCell.m
//  HDMedical
//
//  Created by David on 15-8-16.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "AskDocTableViewCell.h"
#import "UIView+Positioning.h"

@implementation AskDocTableViewCell

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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        [self addSubview:self.leftImgView];
    }
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:self.leftImgView.x +self.leftImgView.width + 15];
        [self.tilteLable setY:self.leftImgView.y];
        
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:20.0]];
        
        [self addSubview:self.tilteLable];
    }
    
    if (self.detailLabel == nil)
    {
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        [self.detailLabel setX:self.leftImgView.x +self.leftImgView.width + 15];
        [self.detailLabel setY:self.leftImgView.bottom - 40];
        
        [self.detailLabel setTextAlignment:NSTextAlignmentLeft];
        [self.detailLabel setTextColor:[UIColor lightGrayColor]];
        [self.detailLabel setFont:[UIFont systemFontOfSize:16.0]];
        
        [self addSubview:self.detailLabel];
    }

}

@end
