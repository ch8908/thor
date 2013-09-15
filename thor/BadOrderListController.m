//
// Created by Huang ChienShuo on 8/30/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BadOrderListController.h"
#import "BadOrderItem.h"
#import "OrderDetailController.h"
#import "I18N.h"

CGFloat headerViewHeight = 80;

@interface BadOrderListController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) UITableView* badOrderList;
@property (nonatomic) NSMutableArray* badOrderItems;
@property (nonatomic, strong) UIView* summarizeView;
@end

@implementation BadOrderListController
@synthesize badOrderList = _badOrderList;
@synthesize badOrderItems = _badOrderItems;
@synthesize summarizeView = _summarizeView;

- (id) initBadMenuWithTitle:(NSString*) title
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationItem.title = title;
        _badOrderList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _badOrderList.dataSource = self;
        _badOrderList.delegate = self;
        [self.view addSubview:_badOrderList];

        UIBarButtonItem* addNewPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(newPost)];
        [self.navigationItem setRightBarButtonItem:addNewPostButton];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.badOrderItems = [[NSMutableArray alloc] init];
    [self fetchItem];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.badOrderList.frame = tableViewFrame;

    [self headerForSummarize];

}

- (UIView*) headerForSummarize
{
    self.summarizeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight)];
    self.summarizeView.backgroundColor = [UIColor grayColor];
    UILabel* titleLabel = [[UILabel alloc] init];

    NSUInteger badOrderCount = self.badOrderItems.count;
    if (badOrderCount == 0)
    {
        titleLabel.text = [I18N key:@"no_bad_order_title"];
    }
    else if (self.badOrderItems.count == 1)
    {
        titleLabel.text = [I18N key:@"has_bad_order_title", [NSString stringWithFormat:@"%d", badOrderCount]];
    }
    else
    {
        titleLabel.text = [I18N key:@"has_bad_orders_title", [NSString stringWithFormat:@"%d", badOrderCount]];
    }

    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [titleLabel sizeToFit];
    [self.summarizeView addSubview:titleLabel];

    return self.summarizeView;
}

- (void) newPost
{

}

- (CGFloat) tableView:(UITableView*) tableView heightForHeaderInSection:(NSInteger) section
{
    return section == 0 ? headerViewHeight : 0;
}


- (UIView*) tableView:(UITableView*) tableView viewForHeaderInSection:(NSInteger) section
{
    if (section == 0)
    {
        return self.summarizeView ? self.summarizeView : [self headerForSummarize];
    }
    return nil;
}


- (CGFloat) tableView:(UITableView*) tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 60;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.badOrderItems.count;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    static NSString* CellIdentifier = @"Cell";

    UITableViewCell* cell = (UITableViewCell*)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    BadOrderItem* item = self.badOrderItems[(NSUInteger) indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.comment;
    return cell;
}

- (void) fetchItem
{
    for (int i = 0; i < 7; ++i)
    {
        BadOrderItem* item = [[BadOrderItem alloc] initBadOrderItemWithName:[NSString stringWithFormat:@"Order %d", i]
                                                                    orderId:@"asdfaiif2"
                                                                    comment:[NSString stringWithFormat:@"Comment %d", i]
                                                              imageFileName:@"" poster:@"Kros" score:-10];
        [self.badOrderItems addObject:item];
    }

    [self.badOrderList reloadData];
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    BadOrderItem* item = self.badOrderItems[(NSUInteger) indexPath.row];
    OrderDetailController* menuDetailController = [[OrderDetailController alloc] initWithOrderDetailWithItem:item];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:[I18N key:@"back"]
                                                                   style:UIBarButtonItemStyleBordered target:nil
                                                                  action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [self.navigationController pushViewController:menuDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end