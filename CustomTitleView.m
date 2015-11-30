//
//  CustomTitleView.m
//  DzhIPhone
//
//  Created by feng frank on 13-7-20.
//
//

#import "CustomTitleView.h"

#define cellHeight 36.0

@implementation CustomTitleView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withNameArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		cellNamesArray = [[NSArray alloc] initWithArray:array];
		
		UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_family_down_bg"]];
		[imageView setFrame:CGRectMake(frame.size.width/2 - 163.0/2, 0, 163, cellHeight* [cellNamesArray count] + 7)];
		[self addSubview:imageView];
		
		titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 160.0/2, 6, 160, cellHeight* [cellNamesArray count]- 3) style:UITableViewStylePlain];
		[titleTableView setDataSource:self];
		[titleTableView setDelegate:self];
		[titleTableView setScrollEnabled:NO];
		[titleTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[titleTableView setSeparatorColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
		[titleTableView setBackgroundColor:[UIColor clearColor]];
		[titleTableView setUserInteractionEnabled:YES];
		
		[self addSubview:titleTableView];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return  [cellNamesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	cell.textLabel.textColor = [UIColor whiteColor];
	[cell.textLabel setFont:[UIFont systemFontOfSize:18.0]];
	cell.textLabel.text = [cellNamesArray objectAtIndex:indexPath.row];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (delegate && [delegate respondsToSelector:@selector(CustomTitleViewOnClick:withNamesArray:)])
		[delegate CustomTitleViewOnClick:indexPath withNamesArray:cellNamesArray];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.hidden = YES;
}

@end
