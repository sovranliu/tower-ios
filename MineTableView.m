//
//  MineTableView.m
//  HDMedical
//
//  Created by David on 15-9-25.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "MineTableView.h"
#import "UIView+Positioning.h"

@implementation MineTableView

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
        self.leftNewSImgsView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 25, 25, 25)];
        [self addSubview:self.leftNewSImgsView];
    }
    
    if (self.newsHeadLineLable == nil)
    {
        self.newsHeadLineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [self.newsHeadLineLable setBackgroundColor:[UIColor clearColor]];
        [self.newsHeadLineLable setX:self.leftNewSImgsView.right + 16];
        [self.newsHeadLineLable setY:self.leftNewSImgsView.y- 10];
        
        [self.newsHeadLineLable setTextAlignment:NSTextAlignmentLeft];
        [self.newsHeadLineLable setTextColor:[UIColor blackColor]];
        [self.newsHeadLineLable setFont:[UIFont systemFontOfSize:17.0]];
        
        [self addSubview:self.newsHeadLineLable];
    }
}


@end
