//
//  ChooseDocTableViewCell.m
//  HDMedical
//
//  Created by DEV_00 on 15-9-1.
//  Copyright (c) 2015年 HD. All rights reserved.
//

#import "ChooseDocTableViewCell.h"
#import "UIView+Positioning.h"
#import "CommonDefine.h"
#import "UIImage+ResizeImage.h"

@implementation ChooseDocTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creat];
    }
    return self;
}
- (void)creat
{

    
    if (self.leftImgView == nil) {
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        [self addSubview:self.leftImgView];
    }
    
    if (self.tipImgView == nil)
    {
        self.tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
        [self addSubview:self.tipImgView];
    }
    
    if (self.tilteLable == nil)
    {
        self.tilteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [self.tilteLable setBackgroundColor:[UIColor clearColor]];
        [self.tilteLable setX:self.leftImgView.x +self.leftImgView.width + 15];
        [self.tilteLable setY:self.leftImgView.y - 10];
        [self.tilteLable setTextAlignment:NSTextAlignmentLeft];
        [self.tilteLable setTextColor:[UIColor blackColor]];
        [self.tilteLable setFont:[UIFont systemFontOfSize:18.0]];
        
        [self addSubview:self.tilteLable];
    }
    
    
    if(self.ksBtn == nil)
    {
        self.ksBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ksBtn setFrame:CGRectMake(0, 0, 200, 25)];
        [self.ksBtn setX:self.tilteLable.right ];
        [self.ksBtn setCenterY:self.tilteLable.centerY];
        [self addSubview:self.ksBtn];
    }
    
    
    if (self.zcLable == nil)
    {
        self.zcLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [self.zcLable setBackgroundColor:[UIColor clearColor]];
        [self.zcLable setX:self.ksBtn.right];
        [self.zcLable setCenterY:self.ksBtn.centerY];
        [self.zcLable setTextAlignment:NSTextAlignmentLeft];
        [self.zcLable setTextColor:[UIColor lightGrayColor]];
        [self.zcLable setFont:[UIFont systemFontOfSize:12.0]];
        
        [self addSubview:self.zcLable];
    }
    
    if (self.askView == nil)
    {
        self.askView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:self.askView];
    }
    
    if (self.yuView == nil)
    {
        self.yuView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.yuView setX:self.askView.right + 3];
        [self.yuView setCenterY:self.zcLable.centerY];
        [self addSubview:self.yuView];
    }
    
    if (self.detailLabel == nil)
    {
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 100 - 20, 40)];
        [self.detailLabel setX:self.leftImgView.x +self.leftImgView.width + 15];
        [self.detailLabel setY:self.leftImgView.bottom - 40];
        
        [self.detailLabel setTextAlignment:NSTextAlignmentLeft];
        [self.detailLabel setTextColor:[UIColor lightGrayColor]];
        [self.detailLabel setFont:[UIFont systemFontOfSize:14.0]];
        self.detailLabel.numberOfLines = 2;
        [self addSubview:self.detailLabel];
    }
    
    [self setAccessoryType:UITableViewCellAccessoryNone];
    
}


- (void)setDocNameText:(NSString *)text
{
    [self.tilteLable setText:text];
    CGSize docNameMaxSize = CGSizeMake(80, MAXFLOAT);
    CGRect  docNameRect = [self.tilteLable.text boundingRectWithSize:docNameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    
    [self.tilteLable setFrame:CGRectMake(self.tilteLable.frame.origin.x, self.tilteLable.frame.origin.y, docNameRect.size.width, 40)];
}


- (void)setksText:(NSString *)text
{
    [self.ksBtn setTitle:text forState:UIControlStateNormal];
    [self.ksBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self.ksBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    CGSize ksMaxSize = CGSizeMake(160, 25);
    CGRect ksRect = [self.ksBtn.titleLabel.text boundingRectWithSize:ksMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    [self.ksBtn setFrame:CGRectMake(self.tilteLable.right + 3, self.ksBtn.frame.origin.y, ksRect.size.width + 20, 25)];
    
    [self.ksBtn setBackgroundImage:[UIImage resizeImage:@"askdoctor_ks"] forState:UIControlStateNormal];
}

- (void)setzcText:(NSString *)text
{
    [self.zcLable setText:text];
    CGSize zcMaxSize = CGSizeMake(60, MAXFLOAT);
    CGRect  zcRect = [self.zcLable.text boundingRectWithSize:zcMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    
    [self.zcLable setFrame:CGRectMake(self.ksBtn.right+2, self.zcLable.frame.origin.y, zcRect.size.width, 25)];
}

- (void)setaskViewImg:(NSString *)imgName
{
    [self.askView setImage:[UIImage imageNamed:imgName]];
    [self.askView setX:kScreenW - 50];
    [self.askView setCenterY:self.zcLable.centerY];
}

- (void)setyuViewImg:(NSString *)imgName
{
    [self.yuView setImage:[UIImage imageNamed:imgName]];
    [self.yuView setX:kScreenW - 25];
    [self.yuView setCenterY:self.zcLable.centerY];
}

- (void)setdetailLabelText:(NSString *)text
{
    [self.detailLabel setText:text];
    
    CGRect  titleRect = [self.detailLabel.text boundingRectWithSize:CGSizeMake(kScreenW - 100 - 20,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    [self.detailLabel setFrame:CGRectMake(self.tilteLable.frame.origin.x, self.tilteLable.frame.origin.y +self.tilteLable.frame.size.height, titleRect.size.width, titleRect.size.height)];
}


@end
