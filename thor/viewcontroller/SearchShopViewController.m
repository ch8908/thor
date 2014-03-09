//
// Created by Huang ChienShuo on 3/9/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import "SearchShopViewController.h"
#import "Views.h"
#import "UIColor+Constant.h"
#import "System.h"
#import "UIImage+Util.h"


@interface SearchShopViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIView *searchBarView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation SearchShopViewController

- (id) initWithMainViewController:(UIViewController *) mainViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _mainViewController = mainViewController;

        _searchBarView = [[UIView alloc] init];
        self.searchBarView.backgroundColor = [UIColor whiteColor];

        _searchBar = [[UISearchBar alloc] init];
        if ([System isMinimumiOS7])
        {
            [self.searchBar setBarTintColor:[UIColor whiteColor]];
            self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        }

        _searchResults = [NSMutableArray array];

//        UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
//                                                                                               contentsController:self];
//
//        self.searchBar.delegate = self;
//        searchDisplayController.searchResultsDataSource = self;
//        searchDisplayController.searchResultsDelegate = self;
//
//        NSLog(@">>>>> 0 self:%@", self.searchDisplayController);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onTapBg:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapRecognizer];

    //Find textField and set keyboard appearance
    UIView *subView = self.searchBar.subviews[0];
    for (UIView *searchTextField in subView.subviews)
    {
        if ([searchTextField isKindOfClass:[UITextField class]])
        {
            [(UITextField *) searchTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
        }
    }

    [self.searchResults addObjectsFromArray:@[@"shop1, shop2, shop3"]];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.searchBarView containerSize:[self searchViewSize]];

    [Views resize:self.searchBar containerSize:CGSizeMake([Views widthOfView:self.searchBarView],
                                                          [Views heightOfView:self.searchBarView] - [Views statusBarHeight])];
    [Views alignParentBottom:self.searchBar withParent:self.searchBarView];

    [Views locate:self.searchBarView x:0 y:-[Views heightOfView:self.searchBarView]];

    UIImage *searchFieldBackgroundImage = [UIImage imageWithRect:CGRectMake(0, 0, [Views widthOfView:self.searchBar], [Views heightOfView:self.searchBar] - 14)
                                                           color:[UIColor lightGrayColor]];

    [self.searchBar setSearchFieldBackgroundImage:searchFieldBackgroundImage
                                         forState:UIControlStateNormal];

    [self.searchBarView addSubview:self.searchBar];
    [self.view addSubview:self.searchBarView];
}

- (CGSize) searchViewSize
{
    return CGSizeMake([Views screenWidth],
                      [Views statusBarHeight] + [Views heightOfView:self.mainViewController.navigationController.navigationBar]);
}

- (void) onTapBg:(UITapGestureRecognizer *) recognizer
{
    [self.searchBar resignFirstResponder];
}

- (void) searchBarBecomeFirstResponder
{
    [self.searchBar becomeFirstResponder];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:duration delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [Views locate:preventCircularRef.searchBarView
                                     y:-[Views heightOfView:preventCircularRef.searchBarView]];
                         preventCircularRef.view.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         [preventCircularRef.view removeFromSuperview];
                         [preventCircularRef removeFromParentViewController];
                     }];
}

- (void) keyboardWillShow:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    self.view.backgroundColor = [UIColor clearColor];
    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:duration delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         preventCircularRef.view.backgroundColor = [UIColor searchViewBgColor];
                         [Views locate:preventCircularRef.searchBarView y:0];
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@">>>>> self:%@", self.searchDisplayController);

    [self.searchDisplayController setActive:YES animated:YES];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.searchResults.count;
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
    return cell;
}


@end