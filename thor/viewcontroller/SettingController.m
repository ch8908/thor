//
// Created by Huang ChienShuo on 2/16/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "SettingController.h"
#import "I18N.h"
#import "Pref.h"
#import "Views.h"
#import "ThorUis.h"
#import "DistancePickViewController.h"


enum
{
    SearchDistance = 0,
    TotalSettingCount
};

@interface SettingController()<UITableViewDelegate, UITableViewDataSource>
@property UITableView *tableView;
@end

@implementation SettingController

- (id) initSettingController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(onDone)];
    [self.navigationItem setLeftBarButtonItem:doneButton];
}

- (void) onDone
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.tableView containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [Views locate:self.tableView x:0 y:0];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.topBarOffset, 0, 0, 0)];
    [self.view addSubview:self.tableView];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return TotalSettingCount;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"SettingCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row)
    {
        case SearchDistance:
        {
            cell.textLabel.text = [I18N key:@"search_distance_title"];
            NSNumber *number = [[[Pref sharedInstance] searchDistance] getNumber];
            cell.detailTextLabel.text = [ThorUis searchDistanceString:number];
            number;
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DistancePickViewController *distancePickViewController = [[DistancePickViewController alloc] init];
    [self.navigationController pushViewController:distancePickViewController animated:YES];
}


@end