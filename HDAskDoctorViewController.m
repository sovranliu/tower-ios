//
//  HDAskDoctorViewController.m
//  HDMedical
//
//  Created by David on 15-8-10.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDAskDoctorViewController.h"
#import "AskDocTableViewCell.h"
#import "HDChooseDoctorViewController.h"
#import "HDSelfAskDocViewController.h"

@interface HDAskDoctorViewController ()

@end

@implementation HDAskDoctorViewController
@synthesize askDoctorTableView;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"问诊";
        self.showNav    = YES;
        self.resident   = YES;
        [self createTabBarItem:self.title iconImgName:@"home_footbar_icon_askdoc" selIconImgName:@"home_footbar_icon_askdoc_pressed"];
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
    self.askDoctorTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 -49) style:UITableViewStylePlain];
    [self.askDoctorTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.askDoctorTableView.delegate = self;
    self.askDoctorTableView.dataSource = self;
    self.askDoctorTableView.showsHorizontalScrollIndicator = NO;
    self.askDoctorTableView.showsVerticalScrollIndicator= NO;
    self.askDoctorTableView.bounces = YES;
    self.askDoctorTableView.alwaysBounceVertical = NO;
    self.askDoctorTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.askDoctorTableView];
    
}

- (void)initHeadView
{
    
    UILabel * headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    headView.tag = 10;
    [headView setText:@"  最新消息：恒大健康计划上线啦。。"];
    [headView setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1.0]];
    [headView setTextAlignment:NSTextAlignmentLeft];
    [headView setFont:[UIFont systemFontOfSize:14.0]];
    
    self.askDoctorTableView.tableHeaderView = headView;
    
}

#pragma mark -UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        
    }
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            [tableCell.leftImgView setImage:[UIImage imageNamed:@"askdoctor_online"]];
            [tableCell.tilteLable setText:@"在线问诊"];
            [tableCell.detailLabel setText:@"直接对话医生，获得专业指导"];
            break;
        case 1:
            [tableCell.leftImgView setImage:[UIImage imageNamed:@"askdoctor_self"]];
            [tableCell.tilteLable setText:@"自我诊断"];
            [tableCell.detailLabel setText:@"帮你判断身体不适"];
            break;
        case 2:
            [tableCell.leftImgView setImage:[UIImage imageNamed:@"askdoctor_famous"]];
            [tableCell.tilteLable setText:@"名医问诊"];
            [tableCell.detailLabel setText:@"三甲医院名医义务坐诊"];
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
    
    NSString * cityID =[NSString stringWithFormat:@"%@",[DataEngine sharedDataEngine].selectedCityId];
    
    switch (indexPath.row) {
        case 0:
        {
            if ([cityID length] >0)
            {
                HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
                chooseDocVC.doctorLevel = 2;
                chooseDocVC.doctorServices = @"reserve";
                [self.navigationController pushViewController:chooseDocVC animated:YES];
                [self setHiddenTabBarView:YES];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag= 1;
                [alertView show];
            }

        }
            break;

        case 1:
        {
            HDSelfAskDocViewController * hdselfVC = [[HDSelfAskDocViewController alloc] init];
            [self.navigationController pushViewController:hdselfVC animated:YES];
            [self setHiddenTabBarView:YES];
            
        }
            break;
        case 2:
        {
            if ([cityID length] >0)
            {
                HDChooseDoctorViewController * chooseDocVC = [[HDChooseDoctorViewController alloc] init];
                chooseDocVC.doctorLevel = 1;
                chooseDocVC.doctorServices = @"inquiry";
                [self.navigationController pushViewController:chooseDocVC animated:YES];
                [self setHiddenTabBarView:YES];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在首页选择小区！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
