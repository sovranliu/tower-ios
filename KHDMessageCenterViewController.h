//
//  KHDMessageCenterViewController.h
//  HDMedical
//
//  Created by David on 15-9-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface KHDMessageCenterViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * messageCenterTableView;
@property(nonatomic,strong)NSMutableArray * messageArray;
@end
