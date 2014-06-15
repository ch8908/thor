//
// Created by Huang ChienShuo on 3/9/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import <Bolts/BFExecutor.h>
#import "SearchShopViewController.h"
#import "OSViewHelper.h"
#import "UIColor+Constant.h"
#import "System.h"
#import "UIImage+Util.h"
#import "NSString+Util.h"
#import "CoffeeService.h"
#import "CoffeeShop.h"
#import "UIViewController+Beans.h"
#import "Beans.h"


CGFloat const SEARCH_TABLE_VIEW_PADDING = 40;
CGFloat const SEARCH_BAR_DURATION = 0.2;
CGFloat const SEARCH_RESULT_CELL_HEIGHT = 40;

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

- (id) initWithMainViewController:(UIViewController *) mainViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _mainViewController = mainViewController;
        _searchResults = [NSMutableArray array];
    }

    return self;
}

- (void) loadView {
    [super loadView];

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
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    if ([System isMinimumiOS7]) {
        [self.searchBar setBarTintColor:[UIColor whiteColor]];
        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    }

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onTapBg:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.backgroundMaskView addGestureRecognizer:singleTapRecognizer];

    //Find textField and set keyboard appearance
    UIView *subView = self.searchBar.subviews[0];
    for (UIView *searchTextField in subView.subviews) {
        if ([searchTextField isKindOfClass:[UITextField class]]) {
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

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.initComplete) {
        self.initComplete = YES;

        [self.backgroundMaskView setFrame:self.view.frame];

        [OSViewHelper resize:self.searchBarView containerSize:[self searchViewSize]];
        [OSViewHelper locate:self.searchBarView y:-[OSViewHelper heightOfView:self.searchBarView]];

        [OSViewHelper resize:self.searchBar containerSize:CGSizeMake([OSViewHelper widthOfView:self.searchBarView],
                                                                     [OSViewHelper heightOfView:self.searchBarView] - [OSViewHelper statusBarHeight])];

        [OSViewHelper alignParentBottom:self.searchBar withParent:self.searchBarView];

        [OSViewHelper resize:self.tableView containerWidth:[OSViewHelper widthOfView:self.view]];
        [OSViewHelper locate:self.tableView x:0 y:0];

        UIImage *searchFieldBackgroundImage = [UIImage imageWithRect:CGRectMake(0, 0, [OSViewHelper widthOfView:self.searchBar], [OSViewHelper heightOfView:self.searchBar] - 14)
                                                               color:[UIColor lightGrayColor]];

        [self.searchBar setSearchFieldBackgroundImage:searchFieldBackgroundImage
                                             forState:UIControlStateNormal];


        [self.searchBarView addSubview:self.searchBar];

        [self.view addSubview:self.backgroundMaskView];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.searchBarView];
    }
}

- (CGSize) searchViewSize {
    return CGSizeMake([OSViewHelper screenWidth],
                      [OSViewHelper statusBarHeight] + [OSViewHelper heightOfView:self.mainViewController.navigationController.navigationBar]);
}

- (void) onTapBg:(UITapGestureRecognizer *) recognizer {
    [self closeSearchController];
}

- (void) closeSearchController {
    [self.searchBar resignFirstResponder];
    [self hideSearchControllerWithAnimation];
}

- (void) searchBarBecomeFirstResponder {
    [self.searchBar becomeFirstResponder];
    [self showSearchControllerWithAnimation];
}

- (void) showSearchControllerWithAnimation {
    CGRect targetFrame = CGRectMake(0, 0, [OSViewHelper widthOfView:self.searchBarView], [OSViewHelper heightOfView:self.searchBarView]);

    CGFloat tableViewHeight = [OSViewHelper heightOfView:self.view] - [OSViewHelper heightOfRect:self.keyboardFrame] - [OSViewHelper heightOfView:self.searchBarView] - SEARCH_TABLE_VIEW_PADDING;
    if (self.searchResults.count == 0) {
        tableViewHeight = 0;
    }
    CGRect tableViewFrame = CGRectMake(0, [OSViewHelper heightOfView:self.searchBarView], [OSViewHelper widthOfView:self.tableView], tableViewHeight);

    self.view.backgroundColor = [UIColor clearColor];

    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:SEARCH_BAR_DURATION delay:0.0f
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

- (void) hideSearchControllerWithAnimation {
    __weak SearchShopViewController *preventCircularRef = self;

    CGRect targetFrame = CGRectMake(0, -[OSViewHelper heightOfView:self.searchBarView], [OSViewHelper widthOfView:self.searchBarView], [OSViewHelper heightOfView:self.searchBarView]);

    CGRect tableViewFrame = CGRectMake(0, 0, [OSViewHelper widthOfView:self.tableView], 0);

    [UIView animateWithDuration:SEARCH_BAR_DURATION delay:0.0f
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

- (void) keyboardWillHide:(NSNotification *) notification {
    NSLog(@">>>>>> keyboardWillHide");
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    self.keyboardFrame = endFrame;
    NSLog(@">>>>>> keyboardWillShow");
}

#pragma UISearchBar delegate

- (void) searchBar:(UISearchBar *) searchBar textDidChange:(NSString *) searchText {
    self.searchTextGlobal = [searchText stringByTrim];
    if ([NSString isEmpty:self.searchTextGlobal]) {
        [self.searchResults removeAllObjects];
        if ([OSViewHelper heightOfView:self.tableView] > 0.0f) {
            [self collapseTableView];
        }
        return;
    }

    __weak SearchShopViewController *preventCircularRef = self;
    [[self.beans.coffeeService autoCompleteResultWithSearchText:self.searchTextGlobal]
                               continueWithExecutor:[BFExecutor mainThreadExecutor]
                                   withSuccessBlock:^id(BFTask *task) {
                                       AutoCompleteResult *autoCompleteResult = task.result;
                                       if (![autoCompleteResult.searchText isEqualToString:preventCircularRef.searchTextGlobal]) {
                                           return nil;
                                       }
                                       [preventCircularRef.searchResults removeAllObjects];
                                       [preventCircularRef.searchResults addObjectsFromArray:autoCompleteResult.candidates];
                                       [preventCircularRef.tableView reloadData];
                                       if ([OSViewHelper heightOfView:preventCircularRef.tableView] < 1.0f) {
                                           [preventCircularRef expandTableView];
                                       }
                                       return nil;
                                   }];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar {
    [self.searchBar resignFirstResponder];
}

- (void) collapseTableView {
    __weak SearchShopViewController *preventCircularRef = self;
    CGRect tableViewFrame = CGRectMake(0, [OSViewHelper heightOfView:self.searchBarView], [OSViewHelper widthOfView:self.tableView], 0);
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [preventCircularRef.tableView setFrame:tableViewFrame];
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void) expandTableView {
    CGFloat tableViewHeight = [OSViewHelper heightOfView:self.view] - [OSViewHelper heightOfRect:self.keyboardFrame] - [OSViewHelper heightOfView:self.searchBarView] - SEARCH_TABLE_VIEW_PADDING;
    CGRect tableViewFrame = CGRectMake(0, [OSViewHelper heightOfView:self.searchBarView], [OSViewHelper widthOfView:self.tableView], tableViewHeight);
    __weak SearchShopViewController *preventCircularRef = self;
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [preventCircularRef.tableView setFrame:tableViewFrame];
                     }
                     completion:^(BOOL finished) {

                     }];
}

#pragma UITableViewDataSource method

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return self.searchResults.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"SearchCandidateCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }

    CoffeeShop *coffeeShop = self.searchResults[(NSUInteger) indexPath.row];
    cell.textLabel.text = coffeeShop.name;
    return cell;
}

#pragma UITableViewDelegate method

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return SEARCH_RESULT_CELL_HEIGHT;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CoffeeShop *coffeeShop = self.searchResults[(NSUInteger) indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:SearchShopSuccessNotification object:coffeeShop];

    self.searchBar.text = @"";
    [self.searchResults removeAllObjects];
    [self closeSearchController];
}

@end