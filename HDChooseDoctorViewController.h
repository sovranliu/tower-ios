//
//  HDChooseDoctorViewController.h
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "CMViewController.h"
#import "PullingRefreshTableView.h"
#import "DataItem.h"

@interface HDChooseDoctorViewController : CMViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property(nonatomic,strong)PullingRefreshTableView * chooseDoctorTableView;
@property(nonatomic,strong)NSMutableArray * doctorsArray;
@property(nonatomic,assign)int doctorLevel;
@property(nonatomic,strong)NSString *  doctorServices;

@property(assign,nonatomic) int  pages;
@property(assign,nonatomic) BOOL pageend;

@end
