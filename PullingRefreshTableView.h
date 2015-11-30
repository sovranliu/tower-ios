//
//  PullingRefreshTableView.h
//  PullingTableView
//
//  Created by danal on 3/6/12.If you want use it,please leave my name here
//  Copyright (c) 2012 danal Luo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PullingRefreshTableViewDelegate;
@class LoadingView;
@interface PullingRefreshTableView : UITableView {
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}
@property (weak,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic, strong) NSString* dateFormatString;
@property (nonatomic, strong) NSDate *refreshDate;
@property (nonatomic, strong) NSDate *loadDate;
@property (nonatomic, strong) LoadingView *headerView;
@property (nonatomic, strong) LoadingView *footerView;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isEnableHeaderPull) BOOL enableHeaderPull;
@property (nonatomic,getter = isEnableFooterPull) BOOL enableFooterPull;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate;
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedLoading;
- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;
- (void)launchRefreshing;
- (void)flashMessage:(NSString *)msg;
- (void)setArrowImage:(UIImage *)arrowImage arrowDownImage:(UIImage *)arrowDownImage;

@end



@protocol PullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView;

@optional
//Implement this method if enableHeaderPull is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date 
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;
- (void)pullingTableView:(PullingRefreshTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

//Usage example
/*
_tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:aPullingDelegate];
[self.view addSubview:_tableView];
_tableView.autoScrollToNextPage = NO;
_tableView.delegate = self;
_tableView.dataSource = self;
*/
