//
//  DataEngine.h
//  LeCakeIphone
//
//  Created by David on 14-10-27.
//  Copyright (c) 2014年 NX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMViewController.h"

@interface DataEngine : NSObject

// 是否登陆
@property(nonatomic,assign) BOOL  isLogin;

@property(nonatomic,strong) NSString * deviceToken;
// 用户名
@property(nonatomic,strong) NSString * userId;

// 电话
@property(nonatomic,strong) NSString * phoneNum;
// 操作指引
@property(nonatomic,assign) BOOL  isFirstInstruction;
// 用户选择的区域
//@property(nonatomic,strong) NSString * selectedRegion;
@property(nonatomic,strong) NSString * selectedCityId;
@property(nonatomic,strong) NSString * selectedCityName;
@property(nonatomic,strong) NSString * selectedRegionId;
@property(nonatomic,strong) NSString * selectedRegionName;

// app启动广告图片URL
@property(nonatomic,strong) NSString * advImgURLStr;

//
//// 选中的银行
//@property(nonatomic,assign)int currentBank;

// 单态实例
+(DataEngine *)sharedDataEngine;

// 保存注册登录基本用户数据
- (void)saveUserBaseInfoData;

// http get请求
- (void)reqAsyncHttpGet:(id)target urlStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo withReqTag:(int)tag;

// http post请求
- (void)reqAsyncHttpPost:(id)target urlStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo withReqTag:(int)tag;

// http json请求
- (void)reqJsonHttp:(id)target urlStr:(NSString *)jsonURL withReqTag:(int)tag;

// http post 上传图片 文件等
- (void)reqAsyncHttpPost:(id)target urlStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo withFileData:(NSData *)fileData withReqTag:(int)tag;


@end
