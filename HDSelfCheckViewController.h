//
//  HDSelfCheckViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-7.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDSelfCheckViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * selfCheckTableView;
@property(nonatomic,strong)NSMutableArray * selfCheckArray;
@property(nonatomic,strong)NSString * selfSymptom;
@end
