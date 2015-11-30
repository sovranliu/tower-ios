//
//  HDSelectCityAndRegionViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15/11/29.
//  Copyright © 2015年 HD. All rights reserved.
//

#import "CMViewController.h"

@interface HDSelectCityAndRegionViewController : CMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL showBackBtnFlag;

@property(nonatomic,strong)UITableView * leftTableView;
@property(nonatomic,strong)NSMutableArray * leftTableViewDataArray;


@property(nonatomic,strong)UITableView * rightTableView;
@property(nonatomic,strong)NSMutableArray * rightTableViewDataArray;
@property(nonatomic,assign)BOOL isfirstClickFlag;
@end
