//
//  MessageTableViewCell.h
//  HDMedical
//
//  Created by David on 15-9-22.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * redImageView;
@property(nonatomic,strong)UILabel * tilteLable;
@property(nonatomic,strong)UILabel * timeLable;
@property(nonatomic,assign)int messageType;
@end
