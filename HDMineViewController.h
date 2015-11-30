//
//  HDMineViewController.h
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "DataItem.h"
#import "MineTableView.h"

@interface HDMineViewController : CMViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mineTableView;
@property(nonatomic,strong)NSMutableArray * localArray;
@property(nonatomic,strong)NSMutableArray * html5Array;
@end
