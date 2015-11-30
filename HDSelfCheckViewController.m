//
//  HDSelfCheckViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-7.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDSelfCheckViewController.h"
#import "SelfCheckTableViewCell.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"
#import "TOWebViewController.h"

@interface HDSelfCheckViewController ()

@end

@implementation HDSelfCheckViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"症状自查";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}

- (void)initExtendedData
{
    self.selfCheckArray = [[NSMutableArray alloc] initWithCapacity:0];
}



- (void)loadUIData
{
    self.selfCheckTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    [self.selfCheckTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.selfCheckTableView setSeparatorInset:UIEdgeInsetsZero];
    self.selfCheckTableView.delegate = self;
    self.selfCheckTableView.dataSource = self;
    self.selfCheckTableView.showsHorizontalScrollIndicator = NO;
    self.selfCheckTableView.showsVerticalScrollIndicator= NO;
    self.selfCheckTableView.bounces = YES;
    self.selfCheckTableView.alwaysBounceVertical = NO;
    self.selfCheckTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.selfCheckTableView];
    
    [self requesURL];

    
}

- (void)requesURL
{
    
    // 2 请求参数
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalloadDisease];
    // 参数
    NSMutableDictionary * paramDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [paramDic setObject:self.selfSymptom forKey:@"symptom"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl1 userInfo:paramDic withReqTag:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selfCheckArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *cellIdentifierStr = @"LeftBasicInforIdentifier";
        
        SelfCheckTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    
        if (tableCell == nil)
        {
            tableCell = [[SelfCheckTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
        }
    
    if ([self.selfCheckArray count] > 0)
    {
        sickItem * item = [self.selfCheckArray objectAtIndex:indexPath.row];
        
        // 新闻摘要
        [tableCell.sickNameDetail setText:item.sickdescription];
        CGRect  titleRect = [tableCell.sickNameDetail.text boundingRectWithSize:CGSizeMake(kScreenW - 40,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        [tableCell.sickNameDetail setFrame:CGRectMake(tableCell.sickNameDetail.frame.origin.x, tableCell.sickNameDetail.frame.origin.y, titleRect.size.width, titleRect.size.height)];
        
        
        tableCell.sickName.text = item.caption;
        
    }
    

        [tableCell.sickName setTextAlignment:NSTextAlignmentLeft];
    
        [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
        return tableCell;
        
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sickItem * item = [self.selfCheckArray objectAtIndex:indexPath.row];
    
    // 检查疾病
    NSMutableString * baseUrl1 = [NSMutableString stringWithString:KHDMedicalBaseURL];
    [baseUrl1 appendString:KHDMedicalsearch];
    [baseUrl1 appendFormat:@"?disease=%@",[item.caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    TOWebViewController * webViewVC = [[TOWebViewController alloc] initWithURLString:baseUrl1];
    [self setHiddenTabBarView:YES];
    [self.navigationController pushViewController:webViewVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        // NSString * msg = [responseData objectForKey:@"msg"];
        NSArray * dataArray = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1 && [dataArray count] >0)
        {
            
            [self.selfCheckArray removeAllObjects];
            
            for (int i = 0; i < [dataArray count]; i ++)
            {
                NSDictionary * dic = [dataArray objectAtIndex:i];
                
                sickItem * item = [[sickItem alloc] init];
                item.caption = [JSONFormatFunc strValueForKey:@"caption" ofDict:dic];
                item.sickdescription = [JSONFormatFunc strValueForKey:@"description" ofDict:dic];
                item.url = [JSONFormatFunc strValueForKey:@"url" ofDict:dic];
                
                [self.selfCheckArray addObject:item];
            }
            
            [self.selfCheckTableView reloadData];
            
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