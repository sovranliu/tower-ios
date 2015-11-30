//
//  MedicalNewsTableViewCell.h
//  HDMedical
//
//  Created by David on 15-8-15.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MedicalNewsTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * leftNewSImgsView;
@property(nonatomic,strong)UILabel * newsHeadLineLable;
@property(nonatomic,strong)UILabel * newsSourceLable;
@property(nonatomic,strong)UILabel * newsTimeLable;
@end
