//
//  HDChooseDoctorViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDChooseDoctorViewController.h"
#import "ChooseDocTableViewCell.h"
#import "HDDoctorDetailViewController.h"
#import "UIImage+ResizeImage.h"
#import "UIView+Positioning.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "LoadingView.h"

@interface HDChooseDoctorViewController ()

@end

@implementation HDChooseDoctorViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"在线问诊";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)requestURL
{
    // 1 请求医生列表
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalDocList];
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pages] forKey:@"page"];
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.doctorLevel] forKey:@"level"];
    [totalParamDic setObject:[NSString stringWithFormat:@"%@",self.doctorServices] forKey:@"services"];
    
    NSLog(@"reinId =%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]);
    
    [totalParamDic setObject:[NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedRegionId intValue]] forKey:@"regionId"];
//        [totalParamDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"regionId"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
}

- (void)initExtendedData
{
    
    self.doctorsArray = [[NSMutableArray alloc] init];
    self.pages = 1;
    self.pageend = NO;
    
}

- (void)loadUIData
{
    [self initChooseDocTableView];
    [self initHeadView];
    [self requestURL];
}


- (void)initChooseDocTableView
{
//    self.chooseDoctorTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
//    [self.chooseDoctorTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    self.chooseDoctorTableView.delegate = self;
//    self.chooseDoctorTableView.dataSource = self;
//    self.chooseDoctorTableView.showsHorizontalScrollIndicator = NO;
//    self.chooseDoctorTableView.showsVerticalScrollIndicator= NO;
//    self.chooseDoctorTableView.bounces = YES;
//    self.chooseDoctorTableView.alwaysBounceVertical = NO;
//    self.chooseDoctorTableView.alwaysBounceHorizontal = NO;
//    [self.view addSubview:self.chooseDoctorTableView];
    
    
    self.chooseDoctorTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    [self.chooseDoctorTableView setArrowImage:[UIImage imageNamed:@"refresh_up"] arrowDownImage:[UIImage imageNamed:@"refresh_down"]];
    self.chooseDoctorTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.chooseDoctorTableView.delegate = self;
    self.chooseDoctorTableView.dataSource = self;
    [self.chooseDoctorTableView setPullingDelegate:self];
    [self.chooseDoctorTableView setEnableFooterPull:YES];
    [self.chooseDoctorTableView setEnableHeaderPull:NO];
    self.chooseDoctorTableView.footerView.stateLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.chooseDoctorTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.chooseDoctorTableView];
    
}

- (void)initHeadView
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 31)];
    UIView * gap = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, 0.5)];
    [gap setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel * headViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    headViewLabel.tag = 10;
    [headViewLabel setText:@"  请选择医生"];
    [headViewLabel setTextAlignment:NSTextAlignmentLeft];
    [headViewLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [headView addSubview:headViewLabel];
    [headView addSubview:gap];
    
    self.chooseDoctorTableView.tableHeaderView = headView;
    
}

#pragma mark -  PullingRefreshTableViewScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.chooseDoctorTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.chooseDoctorTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
// 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{

}

// 上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    NSLog(@"pullingTableViewDidStartLoading");
    
    
    if (!self.pageend)
    {
        // 1 请求医生列表
        NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
        [baseUrl1 appendString:KHDMedicalDocList];
        // 参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.pages] forKey:@"page"];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",self.doctorLevel] forKey:@"level"];
        [totalParamDic setObject:[NSString stringWithFormat:@"%@",self.doctorServices] forKey:@"services"];
        [totalParamDic setObject:[NSString stringWithFormat:@"%d",[[DataEngine sharedDataEngine].selectedCityId intValue]] forKey:@"regionId"];
//       [totalParamDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"regionId"];
        
        // 发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:totalParamDic withReqTag:1];
        
        self.chooseDoctorTableView.reachedTheEnd  = NO;
        [self.chooseDoctorTableView tableViewDidFinishedLoading];
    }else
    {
        
        self.chooseDoctorTableView.reachedTheEnd  = YES;
        [self.chooseDoctorTableView tableViewDidFinishedLoading];
        
    }
    
    
    NSLog(@"pullingTableViewDidStartLoading");
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.doctorsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    ChooseDocTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[ChooseDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    
    if ([self.doctorsArray count] >0)
    {
        dactorItem * item = [self.doctorsArray objectAtIndex:indexPath.row];
        
        // 名医
        [item.level intValue] == 1?[tableCell.tipImgView setImage:[UIImage imageNamed:@"askdoctor_tip"]] :[tableCell.tipImgView setImage:[UIImage imageNamed:@""]];
        
        // 医生头像
        [tableCell.leftImgView setImageWithURL:[NSURL URLWithString:item.photo] placeholderImage:[UIImage imageNamed:@"user_photo_default"]];
        
        
        // 医生的名字
        [tableCell setDocNameText:item.name];
        
        // 医生的科室
        [tableCell setksText:item.department];
        
        // 医生的职称
        [tableCell setzcText:item.title];
        
        
        NSArray * array = item.services;
        for (NSString * type in array)
        {
            if ([type isEqualToString:@"inquiry"])
            {
                // 问
                [tableCell setaskViewImg:@"askdoctor_ask1"];
            }else if ([type isEqualToString:@"reserve"])
            {
                // 预
                [tableCell setyuViewImg:@"askdoctor_yu"];
 
            }
        }
        
        // 医生的详细介绍
        [tableCell setdetailLabelText:item.docDescription];
        
        
        [tableCell setAccessoryType:UITableViewCellAccessoryNone];
        
        
    }
    return tableCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    
    HDDoctorDetailViewController * docDetailVC = [[HDDoctorDetailViewController alloc] init];
    
    
    docDetailVC.docItem = [self.doctorsArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:docDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSMutableArray * doctorArray = [NSMutableArray arrayWithArray:[JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData]];
        NSString * msg =[responseData objectForKey:@"msg"];
        NSLog(@"msg = %@",msg);
        if (code == 1 && [doctorArray count] >0)
        {
//            [self.doctorsArray removeAllObjects];
            for (int i = 0; i <[doctorArray count]; i ++)
            {
                NSDictionary * dic = [doctorArray objectAtIndex:i];
                
                dactorItem * item = [[dactorItem alloc] init];
                item.userGlobalId = [JSONFormatFunc strValueForKey:@"userGlobalId" ofDict:dic];
                item.name         = [JSONFormatFunc strValueForKey:@"name" ofDict:dic];
                item.photo        = [JSONFormatFunc strValueForKey:@"photo" ofDict:dic];
                item.department   = [JSONFormatFunc strValueForKey:@"department" ofDict:dic];
                item.level        = [JSONFormatFunc strValueForKey:@"level" ofDict:dic];
                item.title        = [JSONFormatFunc strValueForKey:@"title" ofDict:dic];
                item.services     = [NSArray arrayWithArray:[dic objectForKey:@"services"]];
                item.docDescription = [JSONFormatFunc strValueForKey:@"description" ofDict:dic];
                item.resume       = [JSONFormatFunc strValueForKey:@"resume" ofDict:dic];
                item.goodNum      = [JSONFormatFunc strValueForKey:@"good" ofDict:dic];
                item.badNum      = [JSONFormatFunc strValueForKey:@"bad" ofDict:dic];
                [self.doctorsArray addObject:item];
            }
            
            [self.chooseDoctorTableView reloadData];
            
            //为第二页请求做准备
            self.pages ++;
            
        }else if (code == 1 && [doctorArray count] ==0)
        {
            self.pageend = YES;
            
            self.chooseDoctorTableView.reachedTheEnd  = YES;
            
            [UIView animateWithDuration:kPRAnimationDuration animations:^{
                self.chooseDoctorTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL bl){
            }];
        }
        
    }
    
}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    NSLog(@"error %@",error.description);
}


@end
