//
//  HDSelfAskDocViewController.h
//  HDMedical
//
//  Created by David on 15-9-6.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"


@interface HDSelfAskDocViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * leftTableView;
@property(nonatomic,strong)NSMutableArray * leftTableViewDataArray;


@property(nonatomic,strong)UITableView * rightTableView;
@property(nonatomic,strong)NSMutableArray * rightTableViewDataArray;
@property(nonatomic,assign)BOOL isfirstClickFlag;

@end
