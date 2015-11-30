//
//  HDMineInfoViewController.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-17.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "HDMineInfoViewController.h"
#import "MineInfoTableViewCell.h"
#import "UIView+Positioning.h"
#import "HDMedicalBankViewController.h"
#import "JSONFormatFunc.h"
#import "UIImageView+WebCache.h"

@interface HDMineInfoViewController ()

@end

@implementation HDMineInfoViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title      = @"我的信息";
        self.showNav    = YES;
        self.resident   = YES;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHDMedicalselectedBank object:nil];
}

- (void)initExtendedData
{
    self.mineInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.bankName = @" ";
    
    for (int i = 0 ; i < 8; i++) {
        [self.mineInfoArray addObject:@" "];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasSelectedBankAction:)
                                                 name:KHDMedicalselectedBank object:nil];
    
}

- (void)loadUIData
{
    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    
    [self initMineinofTableView];
    
    


    // 请求
   //
    [self requestURL];
    
    
//    	public final static String[] BANK_NAMES = {"中国银行", "招商银行", "农业银行", "建设银行", "工商银行"};
    
    
    
    
}

- (void)requestURL
{
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalloadUserInfo];
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpGet:self urlStr:baseUrl userInfo:totalParamDic withReqTag:3];
}
- (void)hasSelectedBankAction:(NSNotification *)text
{
    self.bankName = text.userInfo[@"bankName"];
    [self.mineInfoArray replaceObjectAtIndex:3 withObject:self.bankName];
    [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)initMineinofTableView
{
    self.mineInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49 - 10) style:UITableViewStylePlain];
    [self.mineInfoTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.mineInfoTableView.delegate = self;
    self.mineInfoTableView.dataSource = self;
    self.mineInfoTableView.showsHorizontalScrollIndicator = NO;
    self.mineInfoTableView.showsVerticalScrollIndicator= NO;
    self.mineInfoTableView.bounces = YES;
    self.mineInfoTableView.alwaysBounceVertical = NO;
    self.mineInfoTableView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.mineInfoTableView];
    
    
    // 提交按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setFrame:CGRectMake(25, kScreenH - 49 - 60, kScreenW/2.0 - 50, 30)];
    [self.view addSubview:sureBtn];
    [sureBtn.layer setCornerRadius:3.0];
    
    // 提交按钮
    UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setTitle:@"注  销" forState:UIControlStateNormal];
    [exitBtn setBackgroundColor:[UIColor colorWithRed:31/255.0 green:119/255.0 blue:194.0/255.0 alpha:1.0]];
    [exitBtn addTarget:self action:@selector(exitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setFrame:CGRectMake(sureBtn.right + 50, kScreenH - 49 - 60, kScreenW/2.0 - 50, 30)];
    [self.view addSubview:exitBtn];
    [exitBtn.layer setCornerRadius:3.0];
}

- (void)sureBtnAction:(id)sender
{
    NSLog(@"sureBtnAction");
    
    // 1 请求参数
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalsaveUserInfo];
    
    
    NSLog(@"array =%@",[self.mineInfoArray objectAtIndex:3]);
    
    // 参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:[self.mineInfoArray objectAtIndex:1] forKey:@"name"];
    [totalParamDic setObject:[self.mineInfoArray objectAtIndex:2] forKey:@"idnumber"];
    [totalParamDic setObject:[self.mineInfoArray objectAtIndex:3] forKey:@"bankName"];
    [totalParamDic setObject:[self.mineInfoArray objectAtIndex:4] forKey:@"bankRegion"];
    [totalParamDic setObject:[self.mineInfoArray objectAtIndex:5] forKey:@"bankNumber"];
    [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
    
    // 发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:1];

}

- (void)exitBtnAction:(id)sender
{
      NSLog(@"exitBtnAction");
    
    NSString * token = [DataEngine sharedDataEngine].deviceToken;
    
    //总参数封装
    NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
    [totalParamDic setObject:token forKey:@"token"];
    
    NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
    [baseUrl appendString:@"/"];
    [baseUrl appendString:KHDMedicalLogout];
    
    //发送数据
    [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:2];
}

#pragma mark -列表处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 特殊处理下，快速修改
    NSString *cellIdentifierStr =[NSString stringWithFormat:@"BasicInforIdentifier%ld",indexPath.row];
    
    MineInfoTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (tableCell == nil)
    {
        tableCell = [[MineInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
    }
//    
//    tableCell.nameTitle.text = @"";
//    tableCell.nameContent.text = @"";
    
    
    switch (indexPath.row) {
        case 0:
            tableCell.nameTitle.text = @"手机号码:";
            tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:0];
            break;
        case 1:
            tableCell.nameTitle.text = @"姓名:";
            tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:1];
            break;
        case 2:
            tableCell.nameTitle.text = @"身份证:";
            tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:2];
            break;
        case 3:
            tableCell.nameTitle.text = @"银行:";
            
            if (![self.bankName isEqualToString:@" "])
            {
                tableCell.nameContent.text = self.bankName;
            }else
            {
                tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:3];
            }
            
            break;
        case 4:
            tableCell.nameTitle.text = @"开户支行:";
            tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:4];
            break;
        case 5:
            tableCell.nameTitle.text = @"银行卡号:";
            tableCell.nameContent.text = [self.mineInfoArray objectAtIndex:5];
            break;
        case 6:
        {
            tableCell.nameTitle.text = @"身份证正面:";
            UIImageView * frontImageView = [[UIImageView alloc] init];
            frontImageView.tag = 1;
            [frontImageView setImageWithURL:[NSURL URLWithString:[self.mineInfoArray objectAtIndex:6]]];
            [frontImageView setFrame:CGRectMake(100, 0, 120, 60)];
            [tableCell addSubview:frontImageView];
        }

            break;
        case 7:
        {
            tableCell.nameTitle.text = @"身份证反面:";
            UIImageView * backImageView = [[UIImageView alloc] init];
            backImageView.tag = 2;
            [backImageView setImageWithURL:[NSURL URLWithString:[self.mineInfoArray objectAtIndex:7]]];
            [backImageView setFrame:CGRectMake(100, 0, 120, 60)];
            [tableCell addSubview:backImageView];
        }

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
    
    self.selectedIndexPath = indexPath;
    
    if (indexPath.row == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不能更改！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
//        [[alertView textFieldAtIndex:0] setPlaceholder:@"手机号码"];
//        alertView.tag = 1;
        [alertView show];
    }else if(indexPath.row == 1)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加/编辑姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[alertView textFieldAtIndex:0] setPlaceholder:@"姓名"];
        alertView.tag = 2;
        [alertView show];
    }else if(indexPath.row == 2)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加/编辑身份证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[alertView textFieldAtIndex:0] setPlaceholder:@"身份证"];
        alertView.tag = 3;
        [alertView show];
    }else if(indexPath.row == 3)
    {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加/编辑性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
//        [[alertView textFieldAtIndex:0] setPlaceholder:@"性别"];
//        alertView.tag = 4;
//        [alertView show];
        
        NSString * bankName =  [self.mineInfoArray objectAtIndex:3];
        
        HDMedicalBankViewController * bankVC = [[HDMedicalBankViewController alloc] init];
        if ([bankName length] > 0)
            bankVC.bankName = bankName;
        [self.navigationController pushViewController:bankVC animated:YES];
        
    }else if(indexPath.row == 4)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加/编辑开户支行" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[alertView textFieldAtIndex:0] setPlaceholder:@"开户支行"];
        alertView.tag = 4;
        [alertView show];

    }else if (indexPath.row == 5)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"添加/编辑银行卡号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[alertView textFieldAtIndex:0] setPlaceholder:@"银行卡号"];
        alertView.tag = 5;
        [alertView show];
    }
    else if (indexPath.row == 6)
    {
        [self pickImageFromAlbum];
    }else if (indexPath.row == 7)
    {
        [self pickImageFromAlbum];
    }

    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -UIImagePickerController 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    UIImage *bigImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(480.0, 240.0)];
//    [self saveImage:bigImage WithName:@"salesImageBig.jpg"];
//    
//    UIImage * getImg = [self getImageWithName:@"salesImageBig.jpg"];
    
    UIImageView * smallImageView = [[UIImageView alloc] initWithImage:bigImage];
    [smallImageView setFrame:CGRectMake(100, 0, 120, 60)];
    
    UITableViewCell * identifyCellzhen = [self.mineInfoTableView cellForRowAtIndexPath:self.selectedIndexPath];
    [identifyCellzhen addSubview:smallImageView];
    
    

    if (self.selectedIndexPath.row == 6)
    {
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
        [baseUrl appendString:@"/"];
        [baseUrl appendString:KHDMedicalidcardfront];
        
        NSData * imgData = UIImagePNGRepresentation(bigImage);
        
        //总参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
//        [totalParamDic setObject:imgData forKey:@"image"];
        
//        //发送数据
//        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:4];
        //发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withFileData:imgData withReqTag:4];
        
    }else if (self.selectedIndexPath.row == 7)
    {
        NSMutableString * baseUrl = [NSMutableString stringWithString:KHDMedicalTalkBaseURL];
        [baseUrl appendString:@"/"];
        [baseUrl appendString:KHDMedicalidcardback];
        
        NSData * imgData = UIImagePNGRepresentation(bigImage);
        
        //总参数封装
        NSMutableDictionary * totalParamDic =[[NSMutableDictionary alloc] initWithCapacity:1];
        [totalParamDic setObject:[DataEngine sharedDataEngine].deviceToken forKey:@"token"];
        //[totalParamDic setObject:imgData forKey:@"image"];
        
//        //发送数据
//        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withReqTag:4];
        //发送数据
        [[DataEngine sharedDataEngine] reqAsyncHttpPost:self urlStr:baseUrl userInfo:totalParamDic withFileData:imgData withReqTag:4];
    }

    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (UIImage *)getImageWithName:(NSString *)imageName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    return [UIImage imageWithContentsOfFile:fullPathToFile];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark -alertView 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 1 && buttonIndex == 1)
    {
        NSString * phoneNum = [alertView textFieldAtIndex:0].text;
        if ([phoneNum length] >0)
        {
            [self.mineInfoArray replaceObjectAtIndex:0 withObject:phoneNum];
            [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }else if ( alertView.tag == 2 && buttonIndex == 1)
    {
        NSString * phoneNum = [alertView textFieldAtIndex:0].text;
        if ([phoneNum length] >0)
        {
            [self.mineInfoArray replaceObjectAtIndex:1 withObject:phoneNum];
            [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if ( alertView.tag == 3 && buttonIndex == 1)
    {
        NSString * phoneNum = [alertView textFieldAtIndex:0].text;
        if ([phoneNum length] >0)
        {
            [self.mineInfoArray replaceObjectAtIndex:2 withObject:phoneNum];
            [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if ( alertView.tag == 4 && buttonIndex == 1)
    {
        NSString * phoneNum = [alertView textFieldAtIndex:0].text;
        if ([phoneNum length] >0)
        {
            [self.mineInfoArray replaceObjectAtIndex:4 withObject:phoneNum];
            [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if ( alertView.tag == 5 && buttonIndex == 1)
    {
        NSString * phoneNum = [alertView textFieldAtIndex:0].text;
        if ([phoneNum length] >0)
        {
            [self.mineInfoArray replaceObjectAtIndex:5 withObject:phoneNum];
            [self.mineInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if (alertView.tag == 6)
    {
        
        NSString * fixedName = [self.mineInfoArray objectAtIndex:1];
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:fixedName, @"name",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalNameFixed object:userInfo];
        
        if (![[DataEngine sharedDataEngine].phoneNum isEqualToString:fixedName])
            [DataEngine sharedDataEngine].phoneNum = fixedName;
        
        [self.navigationController popViewControllerAnimated:YES];
    }

    
    // NSLog(@"buttonind =%ld,%@",buttonIndex,[alertView textFieldAtIndex:0].text);
}


#pragma mark - UIReflash work
- (void)reflashTargetUI:(UIViewController *)vc responseData:(id)responseData withTag:(int)tag
{
    if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 1)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        if (code == 1 )
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提交成功！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 6;
            [alertView show];
        }
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 2)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        if(code == 1)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KHDMedicalAlreadLogout object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            [DataEngine sharedDataEngine].deviceToken = @"";
            [DataEngine sharedDataEngine].isLogin = NO;
            [DataEngine sharedDataEngine].userId = @"";
            
            [DataEngine sharedDataEngine].selectedCityId = @"";
            [DataEngine sharedDataEngine].selectedCityName = @"";
            [DataEngine sharedDataEngine].selectedRegionId = @"";
            [DataEngine sharedDataEngine].selectedRegionName = @"";
            
            // 保存本地，记录登陆状态
            [[DataEngine sharedDataEngine] saveUserBaseInfoData];

        }else if (code == -302) // 尚未登录，可能被踢出
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
    }
    else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 3)
    {
        NSLog(@"responseData= %@",responseData);
        
        int code = [[responseData objectForKey:@"code"] intValue];
        NSDictionary *dic = [JSONFormatFunc dictionaryValueForKey:@"data" ofDict:responseData];
        if(code == 1)
        {
            
            NSString * bankName = [JSONFormatFunc strValueForKey:@"bankName" ofDict:dic];
             NSString * bankNumber = [JSONFormatFunc strValueForKey:@"bankNumber" ofDict:dic];
             NSString * bankRegion = [JSONFormatFunc strValueForKey:@"bankRegion" ofDict:dic];
             NSString * birthday = [JSONFormatFunc strValueForKey:@"birthday" ofDict:dic];
             NSString * category = [JSONFormatFunc strValueForKey:@"category" ofDict:dic];
             NSString * idcardback = [JSONFormatFunc strValueForKey:@"idcardback" ofDict:dic];
            NSString * idcardfront = [JSONFormatFunc strValueForKey:@"idcardfront" ofDict:dic];
            NSString * idnumber = [JSONFormatFunc strValueForKey:@"idnumber" ofDict:dic];
            NSString * name = [JSONFormatFunc strValueForKey:@"name" ofDict:dic];
            NSString * phone = [JSONFormatFunc strValueForKey:@"phone" ofDict:dic];
            NSString * relation = [JSONFormatFunc strValueForKey:@"relation" ofDict:dic];
            NSString * status = [JSONFormatFunc strValueForKey:@"status" ofDict:dic];
            NSString * type = [JSONFormatFunc strValueForKey:@"type" ofDict:dic];
            NSString * userGlobalId = [JSONFormatFunc strValueForKey:@"userGlobalId" ofDict:dic];
            
            [self.mineInfoArray replaceObjectAtIndex:0 withObject:phone];
            [self.mineInfoArray replaceObjectAtIndex:1 withObject:name];
            [self.mineInfoArray replaceObjectAtIndex:2 withObject:idnumber];
            [self.mineInfoArray replaceObjectAtIndex:3 withObject:bankName];
            [self.mineInfoArray replaceObjectAtIndex:4 withObject:bankRegion];
            [self.mineInfoArray replaceObjectAtIndex:5 withObject:bankNumber];
            [self.mineInfoArray replaceObjectAtIndex:6 withObject:idcardfront];
            [self.mineInfoArray replaceObjectAtIndex:7 withObject:idcardback];
            
            
            [self.mineInfoTableView reloadData];
            
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
        
        
        
    }else if (vc == self&& [responseData isKindOfClass:[NSDictionary class]] && tag == 4)
    {
        NSLog(@"responseData= %@",responseData);
        int code = [[responseData objectForKey:@"code"] intValue];
//        NSString * msg = [responseData objectForKey:@"msg"];
//        NSLog(@"msg = %@",msg);
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
