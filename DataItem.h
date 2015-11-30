//
//  DataItem.h
//  HDMedical
//
//  Created by David on 15-1-2.
//  Copyright (c) 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject

@end

// 首页咨询
@interface DetailNewsData : NSObject
@property(nonatomic,strong)NSString * newsID;
@property(nonatomic,strong)NSString * imgurl;
@property(nonatomic,strong)NSString * otime;
@property(nonatomic,strong)NSString * source;
@property(nonatomic,strong)NSString * summary;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * url;

@end


// 首页广告AdItem
@interface AdvertItem : DataItem
@property(nonatomic,strong)NSString * newsID;
@property(nonatomic,strong)NSString * imgurl;

@end

// 医生服务类型
@interface dactorServiceItem : DataItem
@property(nonatomic,strong)NSString * inquiry;
@property(nonatomic,strong)NSString * reserve;
@end


// 医生列表
@interface dactorItem : DataItem
@property(nonatomic,strong)NSString * userGlobalId;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * photo;
@property(nonatomic,strong)NSString * department;
@property(nonatomic,strong)NSString * level;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSArray * services;
@property(nonatomic,strong)NSString * docDescription;
@property(nonatomic,strong)NSString * resume;
@property(nonatomic,strong)NSString * goodNum;
@property(nonatomic,strong)NSString * badNum;
@end


//医生评价
@interface pjdoctorItem : DataItem
@property(nonatomic,strong)NSString * attitude;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * date;
@property(nonatomic,strong)NSString * username;
@end

//疾病名称
@interface sickItem : DataItem
@property(nonatomic,strong)NSString * caption;
@property(nonatomic,strong)NSString * sickdescription;
@property(nonatomic,strong)NSString * url;
@end

// 体检套餐
@interface tjtcItem : DataItem
@property(nonatomic,strong)NSString * detail;
@property(nonatomic,strong)NSString * tcid;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSMutableArray * timeArray;
@property(nonatomic,strong)NSString * imgURL;
@end

// 家庭成员
@interface myFamilyItem : DataItem
@property(nonatomic,strong)NSString * birthday;
@property(nonatomic,strong)NSString * category;
@property(nonatomic,strong)NSString * idnumber;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * relation;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * userGlobalId;
@end

// 我的预约
@interface myYuyueItem : DataItem
@property(nonatomic,strong)NSString * date;
@property(nonatomic,strong)NSDictionary * doctor;
@property(nonatomic,strong)NSDictionary * examination;
@property(nonatomic,strong)NSString * myId;
@property(nonatomic,strong)NSString * span;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * type;
@end

// 消息中心
@interface myMessageCenterItem : DataItem
@property(nonatomic,strong)NSString * messageId;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,assign)BOOL  hasRead;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * time;
@property(nonatomic,strong)NSDictionary * info;
@end

// 我的问诊
@interface myAskDocItem : DataItem
@property(nonatomic,strong)NSString * doctor;
@property(nonatomic,strong)NSString * myid;
@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * time;
@property(nonatomic,strong)NSString * topic;
@property(nonatomic,strong)NSString * user;
@end

// 我的钱包
@interface myMoneyItem : DataItem
@property(nonatomic,strong)NSString * myId;
@property(nonatomic,strong)NSString * amount;
@property(nonatomic,strong)NSString * bank;
@property(nonatomic,strong)NSString * time;
@end

// 我的hmtl5
@interface myhtml5Item : DataItem
@property(nonatomic,strong)NSString * caption;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSString * url;
@end

// 我的处方
@interface myChufanItem : DataItem
@property(nonatomic,strong)NSString * caption;
@property(nonatomic,strong)NSString * url;
@end

