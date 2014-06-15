//
// Created by Huang ChienShuo on 2/22/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "DistancePickViewController.h"
#import "OSViewHelper.h"
#import "ThorUis.h"
#import "Pref.h"
#import "UIViewController+Beans.h"
#import "Beans.h"

@interface DistancePickViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *distanceOptions;
@property (nonatomic, strong) NSNumber *selectedDistance;
@end

@implementation DistancePickViewController

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _distanceOptions = @[@1, @3, @5, @10, @30, @50];
        _selectedDistance = [[self.beans.pref searchDistance] getNumber];
    }

    return self;
}

- (void) loadView {
    [super loadView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    NSNumber *savedDistance = [[self.beans.pref searchDistance] getNumber];
    if (![savedDistance isEqualToNumber:self.selectedDistance]) {
        [[self.beans.pref searchDistance] setNumber:self.selectedDistance];
        [[NSNotificationCenter defaultCenter] postNotificationName:SearchDistanceChangedNotification
                                                            object:self.selectedDistance];
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [OSViewHelper resize:self.tableView
           containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [OSViewHelper locate:self.tableView x:0 y:0];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.topBarOffset, 0, 0, 0)];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return self.distanceOptions.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"DistanceCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    NSNumber *distance = self.distanceOptions[(NSUInteger) indexPath.row];
    cell.textLabel.text = [ThorUis searchDistanceString:distance];
    if ([distance isEqualToNumber:self.selectedDistance]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger index = [self.distanceOptions indexOfObject:self.selectedDistance];
    if (index != NSNotFound) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedDistance = self.distanceOptions[(NSUInteger) indexPath.row];
}

@end