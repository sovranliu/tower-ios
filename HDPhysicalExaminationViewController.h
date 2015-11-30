//
//  HDPhysicalExaminationViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-16.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "MXPullDownMenu.h"
#import "UIImageView+WebCache.h"

@interface HDPhysicalExaminationViewController : CMViewController<MXPullDownMenuDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray * tcDropDownArryList;
@property(nonatomic,assign)int currentSelectedIndex;
@property(nonatomic,assign)int currentTimeSelectedIndex;
@end
