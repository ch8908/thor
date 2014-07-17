//
// Created by Huang ChienShuo on 1/21/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "LeftDrawerController.h"
#import "I18N.h"
#import "OSViewHelper.h"
#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UserStateMachine.h"
#import "UserLogoutState.h"
#import "SettingController.h"
#import "AboutViewController.h"
#import "AddShopViewController.h"
#import "CoffeeService.h"
#import "UIViewController+Beans.h"
#import "Beans.h"

enum {
    NewShopSection = 0,
    SettingSection,
    AboutSection,
    LogInOrLogOutSection,
    TotalSectionCount
};

CGFloat const DRAWER_CELL_HEIGHT = 50;

NSString *const LOG_IN_I18N_KEY = @"log_in_button_title";
NSString *const LOG_OUT_I18N_KEY = @"log_out_button_title";

@interface LeftDrawerController()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation LeftDrawerController
- (id) initLeftDrawerViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isLogin = NO;
    }
    return self;
}

- (void) loadView {
    [super loadView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                              style:UITableViewStylePlain];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMachineLoginSuccessNotification)
                                                 name:StateMachineLoginSuccessNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMachineLogoutNotification)
                                                 name:StateMachineLogoutNotification
                                               object:nil];

    [self.beans.coffeeService isLogin];

}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [OSViewHelper resize:self.tableView
           containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [OSViewHelper locate:self.tableView x:0 y:0];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topBarOffset, 0, 0, 0);
}

- (void) newShop {
    if (! self.isLogin) {
        [self showLoginOption];
        return;
    }
    AddShopViewController *controller = [[AddShopViewController alloc] initAddShopViewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.mm_drawerController.centerViewController presentViewController:navigationController
                                                                animated:YES completion:nil];
}

- (void) showLoginOption {
    NSString *login = [I18N key:LOG_IN_I18N_KEY];
    NSString *cancel = [I18N key:@"cancel"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                 initWithTitle:[I18N key:@"add_login_require_action_sheet_title"]
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:login
                                             otherButtonTitles:cancel, nil];
    [actionSheet showInView:self.mm_drawerController.view];
}

- (void) onMachineLoginSuccessNotification {
    self.isLogin = YES;
    [self.tableView reloadData];
}

- (void) onMachineLogoutNotification {
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return DRAWER_CELL_HEIGHT;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return TotalSectionCount;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row) {
        case NewShopSection: {
            cell.textLabel.text = [I18N key:@"add_shop_title"];
            break;
        }
        case LogInOrLogOutSection: {
            NSString *key = self.isLogin ? [I18N key:@"log_out_button_title"] : [I18N key:@"log_in_button_title"];
            cell.textLabel.text = key;
            break;
        }
        case SettingSection:
            cell.textLabel.text = [I18N key:@"setting_title"];
            break;
        case AboutSection:
            cell.textLabel.text = [I18N key:@"about_title"];
            break;
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case NewShopSection: {
            [self newShop];
            break;
        }
        case LogInOrLogOutSection: {
            if (self.isLogin) {
                [self confirmSignOut];
            }
            else {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initLogin]];
                [self.mm_drawerController presentViewController:navigationController
                                                       animated:YES completion:nil];
            }
            break;
        }
        case SettingSection: {
            SettingController *controller = [[SettingController alloc] initSettingController];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.mm_drawerController.centerViewController presentViewController:navigationController
                                                                        animated:YES
                                                                      completion:nil];
            [self.mm_drawerController closeDrawerAnimated:YES
                                               completion:nil];

        }
        case AboutSection: {
            AboutViewController *aboutViewController = [[AboutViewController alloc] initAbout];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
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

- (void) confirmSignOut {
    NSString *signOut = [I18N key:LOG_OUT_I18N_KEY];
    NSString *cancel = [I18N key:@"cancel"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                 initWithTitle:[I18N key:@"log_out_action_sheet_title"]
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:signOut
                                             otherButtonTitles:cancel, nil];
    [actionSheet showInView:self.mm_drawerController.view];
}

#pragma Action Sheet delegete

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[I18N key:LOG_OUT_I18N_KEY]]) {
        [self.beans.coffeeService triggerSignOut];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[I18N key:LOG_IN_I18N_KEY]]) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initLogin]];
        [self.navigationController presentViewController:navigationController
                                                animated:YES completion:nil];
    }
}

@end