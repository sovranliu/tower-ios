//
//  HDCHUFanViewController.h
//  HDMedical
//
//  Created by David on 15-9-26.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDCHUFanViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * chufanTableView;
@property(nonatomic,strong)NSMutableArray * ChufanArray;
@end
