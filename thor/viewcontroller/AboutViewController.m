//
// Created by Huang ChienShuo on 3/14/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "AboutViewController.h"
#import "Views.h"
#import "I18N.h"
#import "ThorUis.h"

enum
{
    AboutCoffee = 0,
    AboutOpenSource,
    AboutVersion,
    AboutTotalCount,
};

CGFloat const ABOUT_CELL_HEIGHT = 44;

@interface AboutViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AboutViewController

- (id) initAbout
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(onDone)];
    [self.navigationItem setLeftBarButtonItem:doneButton];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.tableView containerSize:self.view.frame.size];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.topBarOffset, 0, 0, 0)];
    [self.view addSubview:self.tableView];
}

- (void) onDone
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return AboutTotalCount;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return ABOUT_CELL_HEIGHT;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"AboutCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row)
    {
        case AboutCoffee:
            cell.textLabel.text = [I18N key:@"about_coffee_title", [ThorUis bundleDisplayName]];
            break;
        case AboutOpenSource:
            cell.textLabel.text = [I18N key:@"about_open_source_title"];
            break;
        case AboutVersion:
            cell.textLabel.text = [I18N key:@"about_version"];
            cell.detailTextLabel.text = [ThorUis currentVersion];
            break;
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end