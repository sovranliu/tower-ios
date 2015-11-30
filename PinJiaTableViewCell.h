//
//  PinJiaTableViewCell.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-2.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinJiaTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * nickName;
@property(nonatomic,strong)UILabel * date;
@property(nonatomic,strong)UILabel * pinjiaDetail;
@property(nonatomic,strong)UIView * singleLine;

- (void)setSingleLineFrame:(CGRect)rect;
@end
