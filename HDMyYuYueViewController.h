//
//  HDMyYuYueViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-24.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDMyYuYueViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * messageCenterTableView;
@property(nonatomic,strong)NSMutableArray * myYuyueArray;
@end
