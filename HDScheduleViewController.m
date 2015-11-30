//
//  HDScheduleViewController.m
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDScheduleViewController.h"
#import "AskDocTableViewCell.h"
#import "HDPhysicalExaminationViewController.h"
#import "HDChooseDoctorViewController.h"
#import "HDLoginViewController.h"

@interface HDScheduleViewController ()

@end

@implementation HDScheduleViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"预约";
        self.showNav    = YES;
        self.resident   = YES;
        [self createTabBarItem:self.title iconImgName:@"home_footbar_icon_yuyue" selIconImgName:@"home_footbar_icon_yuyue_pressed"];
        //[self createTabBarItem:self.title iconImgName:nil selIconImgName:nil];
        
    }
    return self;
}
- (void)initExtendedData
{
    
}

- (void)loadUIData
{
    [self initAskDocTableView];
    [self initHeadView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHiddenTabBarView:NO];
}

- (void)initAskDocTableView
{
    self.scheduleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 -49) style:UITableViewStylePlain];
    [self.scheduleTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    self.scheduleTableView.showsHorizontalScrollIndicator = NO;
    self.scheduleTableView.showsVerticalScrollIndicator= NO;
    self.scheduleTableView.bounces = YES;
    self.scheduleTableView.alwaysBounceVertical = NO;
    self.scheduleTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.scheduleTableView];
    
}

- (void)initHeadView
{
    
    UILabel * headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    headView.tag = 10;
    [headView setText:@"  最新消息：恒大健康计划上线啦。。"];
    [headView setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1.0]];
    [headView setTextAlignment:NSTextAlignmentLeft];
    [headView setFont:[UIFont systemFontOfSize:14.0]];
    
    self.scheduleTableView.tableHeaderView = headView;
    
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    AskDocTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[AskDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    switch (indexPath.row) {
        case 0:
            [tableCell.leftImgView setImage:[UIImage imageNamed:@"sechedul_yuyue_tj"]];
            [tableCell.tilteLable setText:@"体检介绍"];
            [tableCell.detailLabel setText:@"包含多种体检套餐"];
            break;
        case 1:
            [tableCell.leftImgView setImage:[UIImage imageNamed:@"sechedul_yuye_jz"]];
            [tableCell.tilteLable setText:@"预约就诊"];
            [tableCell.detailLabel setText:@"在线选择医生预约就诊"];
            break;
        default:
            break;
    }
    
    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    switch (indexPath.row) {
        case 0:
        {
            if (![DataEngine sharedDataEngine].isLogin)
            {
                HDLoginViewController * loginVC = [[HDLoginViewController alloc] init];
                UINavigationController * rootNavigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self.navigationController presentViewController:rootNavigationVC animated:YES completion:nil];
                [self setHiddenTabBarView:YES];
            }else
            {
                HDPhysicalExaminationViewController * peVC = [[HDPhysicalExaminationViewController alloc] init];
                [self.navigationController pushViewController:peVC animated:YES];
                [self setHiddenTabBarView:YES];
            }

            
            
        }
            break;
            
        case 1:
        {
//            HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
//            chooseDocVC.doctorLevel = 2;
//            chooseDocVC.doctorServices = @"inquiry";
//            [self.navigationController pushViewController:chooseDocVC animated:YES];
//            [self setHiddenTabBarView:YES];
            
            NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
            
            if ([cityID length] >0)
            {
                HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
                chooseDocVC.doctorLevel = 2;
                chooseDocVC.doctorServices = @"inquiry";
                [self.navigationController pushViewController:chooseDocVC animated:YES];
                [self setHiddenTabBarView:YES];
                
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag= 1;
                [alertView show];
            }
            
        }
            break;
        default:
            break;
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didSelectedTabBarItem
{
    NSLog(@"didSelectedTabBarItem =%@",self);
}
@end
