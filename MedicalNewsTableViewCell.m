//
//  MedicalNewsTableViewCell.m
//  HDMedical
//
//  Created by David on 15-8-15.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MedicalNewsTableViewCell.h"
#import "CommonDefine.h"
#import "UIView+Positioning.h"

@implementation MedicalNewsTableViewCell
@synthesize leftNewSImgsView;
@synthesize newsHeadLineLable;
@synthesize newsSourceLable;
@synthesize newsTimeLable;

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
    
    if (self.leftNewSImgsView == nil) {
        self.leftNewSImgsView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12.5, 90, 65)];
        [self addSubview:self.leftNewSImgsView];
    }
    
    if (self.newsHeadLineLable == nil)
    {
        self.newsHeadLineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        [self.newsHeadLineLable setBackgroundColor:[UIColor clearColor]];
        [self.newsHeadLineLable setX:self.leftNewSImgsView.x +self.leftNewSImgsView.width + 8];
        [self.newsHeadLineLable setY:self.leftNewSImgsView.y];
        
        [self.newsHeadLineLable setTextAlignment:NSTextAlignmentLeft];
        [self.newsHeadLineLable setTextColor:[UIColor blackColor]];
        [self.newsHeadLineLable setFont:[UIFont systemFontOfSize:14.0]];
        self.newsHeadLineLable.numberOfLines = 2;
        
        [self addSubview:self.newsHeadLineLable];
    }
    
    if (self.newsSourceLable == nil)
    {
        self.newsSourceLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 15)];
        [self.newsSourceLable setX:self.leftNewSImgsView.x +self.leftNewSImgsView.width + 8];
        [self.newsSourceLable setY:self.leftNewSImgsView.bottom - 15];
        
        [self.newsSourceLable setTextAlignment:NSTextAlignmentLeft];
        [self.newsSourceLable setTextColor:[UIColor blackColor]];
        [self.newsSourceLable setFont:[UIFont systemFontOfSize:12.0]];
        self.newsSourceLable.numberOfLines = 1;

        [self addSubview:self.newsSourceLable];
    }
    
    if (self.newsTimeLable == nil)
    {
        self.newsTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
        [self.newsTimeLable setX:kScreenW - 15 -80];
        [self.newsTimeLable setY:self.leftNewSImgsView.bottom - 15];
        
        [self.newsTimeLable setTextAlignment:NSTextAlignmentRight];
        [self.newsTimeLable setTextColor:[UIColor blackColor]];
        [self.newsTimeLable setFont:[UIFont systemFontOfSize:12.0]];
        self.newsTimeLable.numberOfLines = 1;
        
        [self addSubview:self.newsTimeLable];
    }

}

@end
