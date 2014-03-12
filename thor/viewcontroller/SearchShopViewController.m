//
// Created by Huang ChienShuo on 3/9/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import <Bolts/BFExecutor.h>
#import "SearchShopViewController.h"
#import "Views.h"
#import "UIColor+Constant.h"
#import "System.h"
#import "UIImage+Util.h"
#import "NSString+Util.h"
#import "CoffeeService.h"
#import "CoffeeShop.h"


CGFloat SEARCH_TABLE_VIEW_PADDING = 40;

NSString *SearchShopSuccessNotification = @"SearchShopSuccessNotification";

@interface SearchShopViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIView *backgroundMaskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *searchBarView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL initComplete;
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, copy) NSString *searchTextGlobal;
@end

@implementation SearchShopViewController

- (id) initWithMainViewController:(UIViewController *) mainViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _mainViewController = mainViewController;

        _backgroundMaskView = [[UIView alloc] init];
        self.backgroundMaskView.backgroundColor = [UIColor clearColor];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        _searchBarView = [[UIView alloc] init];
        self.searchBarView.backgroundColor = [UIColor whiteColor];
        self.searchBarView.clipsToBounds = YES;

        _searchBar = [[UISearchBar alloc] init];
        self.searchBar.delegate = self;
        if ([System isMinimumiOS7])
        {
            [self.searchBar setBarTintColor:[UIColor whiteColor]];
            self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        }

        _searchResults = [NSMutableArray array];
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onTapBg:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.backgroundMaskView addGestureRecognizer:singleTapRecognizer];

    //Find textField and set keyboard appearance
    UIView *subView = self.searchBar.subviews[0];
    for (UIView *searchTextField in subView.subviews)
    {
        if ([searchTextField isKindOfClass:[UITextField class]])
        {
            [(UITextField *) searchTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!self.initComplete)
    {
        self.initComplete = YES;

        [self.backgroundMaskView setFrame:self.view.frame];

        [Views resize:self.searchBarView containerSize:[self searchViewSize]];
        [Views locate:self.searchBarView y:-[Views heightOfView:self.searchBarView]];

        [Views resize:self.searchBar containerSize:CGSizeMake([Views widthOfView:self.searchBarView],
                                                              [Views heightOfView:self.searchBarView] - [Views statusBarHeight])];

        [Views alignParentBottom:self.searchBar withParent:self.searchBarView];

        [Views resize:self.tableView containerWidth:[Views widthOfView:self.view]];
        [Views locate:self.tableView x:0 y:0];

        UIImage *searchFieldBackgroundImage = [UIImage imageWithRect:CGRectMake(0, 0, [Views widthOfView:self.searchBar], [Views heightOfView:self.searchBar] - 14)
                                                               color:[UIColor lightGrayColor]];

        [self.searchBar setSearchFieldBackgroundImage:searchFieldBackgroundImage
                                             forState:UIControlStateNormal];


        [self.searchBarView addSubview:self.searchBar];

        [self.view addSubview:self.backgroundMaskView];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.searchBarView];
    }
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

    CGRect targetFrame = CGRectMake(0, -[Views heightOfView:self.searchBarView], [Views widthOfView:self.searchBarView], [Views heightOfView:self.searchBarView]);

    CGRect tableViewFrame = CGRectMake(0, 0, [Views widthOfView:self.tableView], 0);

    NSLog(@">>>>>> keyboardWillHide:%@", NSStringFromCGRect(targetFrame));

    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:duration delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         preventCircularRef.backgroundMaskView.backgroundColor = [UIColor clearColor];

                         [preventCircularRef.searchBarView setFrame:targetFrame];

                         [preventCircularRef.tableView setFrame:tableViewFrame];
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

    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    self.keyboardFrame = endFrame;

    CGRect targetFrame = CGRectMake(0, 0, [Views widthOfView:self.searchBarView], [Views heightOfView:self.searchBarView]);
    NSLog(@">>>>>> keyboardWillShow:%@", NSStringFromCGRect(targetFrame));

    CGFloat tableViewHeight = [Views heightOfView:self.view] - [Views heightOfRect:endFrame] - [Views heightOfView:self.searchBarView] - SEARCH_TABLE_VIEW_PADDING;
    if (self.searchResults.count == 0)
    {
        tableViewHeight = 0;
    }
    CGRect tableViewFrame = CGRectMake(0, [Views heightOfView:self.searchBarView], [Views widthOfView:self.tableView], tableViewHeight);

    self.view.backgroundColor = [UIColor clearColor];
    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:duration delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         // Change background color
                         preventCircularRef.backgroundMaskView.backgroundColor = [UIColor searchViewBgColor];

                         // Move searchBar
                         [preventCircularRef.searchBarView setFrame:targetFrame];

                         // Move tableView
                         [preventCircularRef.tableView setFrame:tableViewFrame];
                     }
                     completion:^(BOOL finished) {

                     }];
}

#pragma UISearchBar delegate

- (void) searchBar:(UISearchBar *) searchBar textDidChange:(NSString *) searchText
{
    self.searchTextGlobal = [searchText stringByTrim];
    if ([NSString isEmpty:self.searchTextGlobal])
    {
        [self.searchResults removeAllObjects];
        if ([Views heightOfView:self.tableView] > 0.0f)
        {
            [self collapseTableView];
        }
        return;
    }

    __weak SearchShopViewController *preventCircularRef = self;
    [[[CoffeeService sharedInstance] autoCompleteResultWithSearchText:self.searchTextGlobal]
                     continueWithExecutor:[BFExecutor mainThreadExecutor]
                         withSuccessBlock:^id(BFTask *task) {
                             AutoCompleteResult *autoCompleteResult = task.result;
                             if (![autoCompleteResult.searchText isEqualToString:preventCircularRef.searchTextGlobal])
                             {
                                 return nil;
                             }
                             [preventCircularRef.searchResults removeAllObjects];
                             [preventCircularRef.searchResults addObjectsFromArray:autoCompleteResult.candidates];
                             [preventCircularRef.tableView reloadData];
                             if ([Views heightOfView:preventCircularRef.tableView] < 1.0f)
                             {
                                 [preventCircularRef expandTableView];
                             }
                             return nil;
                         }];
}

- (void) collapseTableView
{
    __weak SearchShopViewController *preventCircularRef = self;
    CGRect tableViewFrame = CGRectMake(0, [Views heightOfView:self.searchBarView], [Views widthOfView:self.tableView], 0);
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [preventCircularRef.tableView setFrame:tableViewFrame];
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void) expandTableView
{
    CGFloat tableViewHeight = [Views heightOfView:self.view] - [Views heightOfRect:self.keyboardFrame] - [Views heightOfView:self.searchBarView] - SEARCH_TABLE_VIEW_PADDING;
    CGRect tableViewFrame = CGRectMake(0, [Views heightOfView:self.searchBarView], [Views widthOfView:self.tableView], tableViewHeight);
    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [preventCircularRef.tableView setFrame:tableViewFrame];
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar
{

}

#pragma UITableViewDataSource method

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.searchResults.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"SearchCandidateCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }

    CoffeeShop *coffeeShop = self.searchResults[(NSUInteger) indexPath.row];
    cell.textLabel.text = coffeeShop.name;
    return cell;
}

#pragma UITableViewDelegate method

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return 40;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CoffeeShop *coffeeShop = self.searchResults[(NSUInteger) indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:SearchShopSuccessNotification object:coffeeShop];
    [self.searchBar resignFirstResponder];
}

@end