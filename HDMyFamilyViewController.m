//
//  HDMyFamilyViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-8-21.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMyFamilyViewController.h"
#import "FamilyTableViewCell.h"
#import "HDAddFamilyWithIDViewController.h"
#import "DataItem.h"
#import "JSONFormatFunc.h"


@interface HDMyFamilyViewController ()

@end

@implementation HDMyFamilyViewController
@synthesize myfamilyTableView;
@synthesize activePopup;
@synthesize relationArray;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的家庭";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(workTableAction:)
                                                     name:@"ADDFAMILYIDCARDCOMPLETE" object:nil];
    }
    return self;
}


- (void)initExtendedData
{
    self.relationArray = [NSMutableArray array];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADDFAMILYIDCARDCOMPLETE" object:self];
}

- (void)workTableAction:(id)sender
{
    [self requetfamilypeople];
}

- (void)initMineTableView
{
    self.myfamilyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64) style:UITableViewStylePlain];
    [self.myfamilyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.myfamilyTableView.delegate = self;
    self.myfamilyTableView.dataSource = self;
    self.myfamilyTableView.showsHorizontalScrollIndicator = NO;
    self.myfamilyTableView.showsVerticalScrollIndicator= NO;
    self.myfamilyTableView.bounces = YES;
    self.myfamilyTableView.alwaysBounceVertical = NO;
    self.myfamilyTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.myfamilyTableView];
    
}


- (void)calculateBtnBtnAction:(id)sender
{
    NSLog(@"calculateBtnBtnAction");
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加手机号码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    [[alertView textFieldAtIndex:0] setPlaceholder:@"关系"];
    [[alertView textFieldAtIndex:1] setPlaceholder:@"手机号码"];
    [[alertView textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
    
    [alertView show];
}

- (void)addFamilyNumBtnAction:(id)sender
{
 
    if (self.activePopup)
    {
        self.activePopup = nil;
    }else
    {
        PopupListComponent *popupList = [[PopupListComponent alloc] init];
        NSArray* listItems = [NSArray arrayWithObjects:
                     [[PopupListComponentItem alloc] initWithCaption:@"添加身份证" image:nil itemId:1 showCaption:YES],
                     [[PopupListComponentItem alloc] initWithCaption:@"添加手机号码" image:nil itemId:2 showCaption:YES],
                     nil];
        
        popupList.textColor = [UIColor whiteColor];
        popupList.font =[UIFont systemFontOfSize:14.0];
        
        // Optional: store any object you want to have access to in the delegeate callback(s):
        // popupList.userInfo = @"Value to hold on to";
        
        UIView * btnView = (UIView *)sender;
        UIView * btnViewCopyFrame = [[UIView alloc] initWithFrame:CGRectMake(btnView.frame.origin.x, btnView.frame.origin.y -40, btnView.frame.size.width, btnView.frame.size.height)];
        
        [popupList showAnchoredTo:btnViewCopyFrame inView:self.view withItems:listItems withDelegate:self];
        
        self.activePopup = popupList;
    }
}

- (void)initAddFamilyNavigationItem
{
    UIButton *addFamilyNumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [addFamilyNumBtn setBackgroundImage:[UIImage imageNamed:@"mine_addfamily"] forState:UIControlStateNormal];
    
    addFamilyNumBtn.tag = 101;
    [addFamilyNumBtn setFrame:CGRectMake(0, 0, 40, 35)];
    [addFamilyNumBtn addTarget:self action:@selector(addFamilyNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addFamilyNumBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    //    UIView * rightNavItemView = [[UIView alloc] init];
    //    [rightNavItemView setFrame:CGRectMake(0, 0, 85, 40)
    //     ];
    //    [rightNavItemView setBackgroundColor:[UIColor clearColor]];
    //
    //    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [calculateBtn setBackgroundImage:[CommonDrawFunc retinaImageNamed:@"compute.png"] forState:UIControlStateNormal];
    //    [calculateBtn setFrame:CGRectMake(0, 0, 35, 35)];
    //    [calculateBtn addTarget:self action:@selector(calculateBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [findBtn setBackgroundImage:[CommonDrawFunc retinaImageNamed:@"search.png"] forState:UIControlStateNormal];
    //    [findBtn setFrame:CGRectMake(40, 0, 35, 35)];
    //    [findBtn addTarget:self action:@selector(findBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [rightNavItemView addSubview:calculateBtn];
    //    [rightNavItemView addSubview:findBtn];
    //
    //    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavItemView];
    //    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

- (void)loadUIData
{
    [self initMineTableView];
    [self initAddFamilyNavigationItem];
    
    [self requetfamilypeople];
}

- (void)requetfamilypeople
{
    //总参数封装
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalMember];
    
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    //发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];
}

#pragma mark -alertView 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString * relationName = [alertView textFieldAtIndex:0].text;
        NSString * phoneNum     = [alertView textFieldAtIndex:1].text;
        if ([relationName length] > 0 && [phoneNum length] >0)
        {
            //总参数封装
            NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
            [baseUrl appendString:@"/"];
            [baseUrl appendString:KHDMedicaleditrelation];
            
            NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
            [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
            [totalParamDic setObject:[DataEngine sharedDataEngine].userId forKey:@"userGlobalId"];
            [totalParamDic setObject:relationName forKey:@"relation"];
            [totalParamDic setObject:phoneNum forKey:@"phone"];
            //发送数据
            [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
        }
        
        else
        {
//            NSString * msgstr;
//            if ([relationName length] == 0) {
//                msgstr = @"关系不能为空！";
//            }
//            if ([phoneNum length] == 0) {
//                msgstr = @"手机号不能为空！";
//            }
//            
//            
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msgstr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alertView show];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加手机号码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
            [[alertView textFieldAtIndex:0] setPlaceholder:@"关系"];
            [[alertView textFieldAtIndex:1] setPlaceholder:@"手机号码"];
            [[alertView textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumberPad];
            [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
            
            [alertView show];
        }
        
    }
    
   // NSLog(@"buttonind =%ld,%@",buttonIndex,[alertView textFieldAtIndex:0].text);
}


- (void)rightBtnAction:(NSInteger)index
{
    NSLog(@"index = %ld",index);
    
    myFamilyItem * item = [self.relationArray objectAtIndex:index];
    
    //总参数封装
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalremovefamily];
    
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    [totalParamDic setObject:item.userGlobalId forKey:@"userGlobalId"];
    //发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:3];
    
}


#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.relationArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifierStr = @"BasicInforIdentifier";
    
    FamilyTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[FamilyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
    tableCell.rightBtn.tag = indexPath.row;
    tableCell.rightBtnDelegate = self;
    
    
    myFamilyItem * item = [self.relationArray objectAtIndex:indexPath.row];
    
    [tableCell.imageView setImage:[UIImage imageNamed:@"user_photo_default"]];
    tableCell.familyNickNameLabel.text      = item.name;
    tableCell.familyNameAndPhoneLabel.text  = item.phone;
    [tableCell.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    
//    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
//    if (tableCell == nil)
//    {
//        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
//    }
//    
//    
//    myFamilyItem * item = [self.relationArray objectAtIndex:indexPath.row];
//    
//    [tableCell.imageView setImage:[UIImage imageNamed:@"mine_familyicon_default"]];
//    tableCell.textLabel.text = item.relation;
//    
//    [tableCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return tableCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didSelectRow");

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId
{
    NSLog(@"User chose item with id = %d", itemId);
    
    
    if (itemId == 1)
    {
        HDAddFamilyWithIDViewController * familyWithIDVC = [[HDAddFamilyWithIDViewController alloc] init];
        [self.navigationController pushViewController:familyWithIDVC animated:YES];
        
        
    }else if (itemId == 2)
    {
        [self calculateBtnBtnAction:nil];
    }
    

    id anyObjectToPassToCallback = sender.userInfo;
    NSLog(@"popup userInfo = %@", anyObjectToPassToCallback);
    
    self.activePopup = nil;
}

- (void) popupListcompoentDidCancel:(PopupListComponent *)sender
{
    NSLog(@"Popup cancelled");
    self.activePopup = nil;
}


- (void)didSelectedTabBarItem
{
    NSLog(@"didSelectedTabBarItem =%@",self);
}

#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self && tag == 1 && [responseData isKindOfClass:[NSDictionary class]] )
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSArray * relationArrayList = [JSONFormatFunc arrayValueForKey:@"data" ofDict:responseData];
        if (code == 1)
        {
            [self.relationArray removeAllObjects];
            for (NSDictionary * dic in relationArrayList)
            {
                myFamilyItem * item = [[myFamilyItem alloc] init];
                item.birthday = [JSONFormatFunc strValueForKey:@"birthday" ofDict:dic];
                item.category = [JSONFormatFunc strValueForKey:@"category" ofDict:dic];
                item.idnumber = [JSONFormatFunc strValueForKey:@"idnumber" ofDict:dic];
                item.name     = [JSONFormatFunc strValueForKey:@"name" ofDict:dic];
                item.phone    = [JSONFormatFunc strValueForKey:@"phone" ofDict:dic];
                item.relation = [JSONFormatFunc strValueForKey:@"relation" ofDict:dic];
                item.status   = [JSONFormatFunc strValueForKey:@"status" ofDict:dic];
                item.userGlobalId = [JSONFormatFunc strValueForKey:@"userGlobalId" ofDict:dic];
                
                [self.relationArray addObject:item];
            }
            
            [self.myfamilyTableView reloadData];
        }else if (code == -302)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，请重新登录！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalAlreadLogout object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [DataEngine sharedDataEngine].deviceToken = @"";
            [DataEngine sharedDataEngine].isLogin = NO;
            [DataEngine sharedDataEngine].userId = @"";
            [DataEngine sharedDataEngine].selectedCityId = @"";
            [DataEngine sharedDataEngine].selectedCityName = @"";
            [DataEngine sharedDataEngine].selectedRegionId = @"";
            [DataEngine sharedDataEngine].selectedRegionName = @"";
            [[DataEngine sharedDataEngine] saveUserBaseInfoData];
        }
        
    }else if(vc == self && tag == 2 && [responseData isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"22 responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSString * msg =[JSONFormatFunc strValueForKey:@"msg" ofDict:responseData];
//        NSLog(@"msg = %@",msg);
        if (code > 0)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经添加成功，请等待对方审核！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else
        {
            NSString * faileMSG  = @"添加失败，请重新添加!";
            if ([msg length] > 0)
            {
                faileMSG = msg;
            }

            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:faileMSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }else if(vc == self && tag == 3 && [responseData isKindOfClass:[NSDictionary class]])
    {
         NSLog(@"33 responseData= %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
//        NSString * msg = [responseData objectForKey:@"msg"];
//        NSLog(@"msg = %@",msg);
        if(code > 0)
        {
            [self requetfamilypeople];
        }
        
    }

}

- (void)parseJsonDataInUI:(UIViewController *)vc jsonData:(id)jsonData withTag:(int)tag
{
    
}

- (void)httpResponseError:(UIViewController *)vc errorInfo:(NSError *)error withTag:(int)tag
{
    
}



@end
