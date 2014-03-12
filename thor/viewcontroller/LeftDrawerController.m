//
// Created by Huang ChienShuo on 1/21/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "LeftDrawerController.h"
#import "I18N.h"
#import "Views.h"
#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "LogStateMachine.h"
#import "LogoutState.h"
#import "SettingController.h"

enum
{
    LogInLogOut = 0,
    Setting,
    TotalCount
};

@interface LeftDrawerController()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property UITableView *tableView;
@end

@implementation LeftDrawerController
- (id) initLeftDrawerViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMachineLoginSuccessNotification)
                                                     name:MachineLoginSuccessNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMachineLogoutNotification)
                                                     name:MachineLogoutNotification
                                                   object:nil];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.tableView containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [Views locate:self.tableView x:0 y:0];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topBarOffset, 0, 0, 0);

    [self.view addSubview:self.tableView];
}

- (void) onMachineLoginSuccessNotification
{
    [self.tableView reloadData];
}

- (void) onMachineLogoutNotification
{
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return 50;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return TotalCount;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row)
    {
        case LogInLogOut:
        {
            NSString *key = [[LogStateMachine sharedInstance] isLogin] ? [I18N key:@"log_out_button_title"] : [I18N key:@"log_in_button_title"];
            cell.textLabel.text = key;
            break;
        }
        case Setting:
            cell.textLabel.text = [I18N key:@"setting_title"];
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row)
    {
        case LogInLogOut:
        {
            if ([[LogStateMachine sharedInstance] isLogin])
            {
                [self confirmSignOut];
            }
            else
            {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initLogin]];
                [self.mm_drawerController presentViewController:navigationController
                                                       animated:YES completion:nil];
            }
            break;
        }
        case Setting:
        {
            SettingController *controller = [[SettingController alloc] initSettingController];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.mm_drawerController.centerViewController presentViewController:navigationController
                                                                        animated:YES
                                                                      completion:nil];
            [self.mm_drawerController closeDrawerAnimated:YES
                                               completion:nil];

        }
        default:
            break;
    }
}

- (void) confirmSignOut
{
    NSString *signOut = [I18N key:@"log_out_button_title"];
    NSString *cancel = [I18N key:@"cancel"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                 initWithTitle:[I18N key:@"log_out_action_sheet_title"]
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:signOut
                                             otherButtonTitles:cancel, nil];
    [actionSheet showInView:self.mm_drawerController.view];
}

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        [[LogStateMachine sharedInstance] changeState:[[LogoutState alloc] init]];
    }
}

@end