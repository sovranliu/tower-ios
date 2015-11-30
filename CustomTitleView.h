//
//  CustomTitleView.h
//  DzhIPhone
//
//  Created by feng frank on 13-7-20.
//
//

#import <UIKit/UIKit.h>
#import "CMViewController.h"

@protocol CustomTitleViewOnClickDelegate <NSObject>
- (void)CustomTitleViewOnClick:(NSIndexPath*)indexPath withNamesArray:(NSArray *)array;
@end

@interface CustomTitleView : UIView<UITableViewDataSource,UITableViewDelegate>
{
	UITableView * titleTableView;
	NSArray		* cellNamesArray;
}
- (id)initWithFrame:(CGRect)frame withNameArray:(NSArray *)array;
@property(nonatomic,assign)id<CustomTitleViewOnClickDelegate>	delegate;
@end
