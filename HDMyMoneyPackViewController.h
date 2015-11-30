//
//  HDMyMoneyPackViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "DataItem.h"

@interface HDMyMoneyPackViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * mineMoneyPackTableView;
@property(nonatomic,strong)NSMutableArray * mineMoneyArray;
@end
