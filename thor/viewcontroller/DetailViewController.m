//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Bolts/BFTask.h>
#import <Bolts/BFExecutor.h>
#import "AbstractUIViewController.h"
#import "DetailViewController.h"
#import "CoffeeService.h"
#import "OSViewHelper.h"
#import "CoffeeShopDetail.h"
#import "I18N.h"
#import "CoffeeShop.h"
#import "CoffeeShop+Strings.h"
#import "NSString+Util.h"
#import "ExternalApp.h"
#import "UIViewController+Beans.h"
#import "Beans.h"


NSString *const LAUNCH_APPLE_MAP_DIRECTION_I18N_KEY = @"apple_map_navigation";
NSString *const LAUNCH_GOOGLE_MAP_DIRECTION_I18N_KEY = @"google_map_navigation";

enum {
    ShopName = 0,
    ShopAddress,
    ShopDescription,
    ShopHour,
    ShopWebSite,
    ShopWifiPower,
    ShopDetailTotalCount
};

@interface DetailViewController()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) CoffeeShopDetail *coffeeShopDetail;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BFTask *fetchTask;
@end

@implementation DetailViewController

- (id) initDetailViewControllerWithId:(NSNumber *) id {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _id = id;
    }

    return self;
}

- (void) loadView {
    [super loadView];

    _shopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/image_placeholder.png"]];
    self.shopImageView.clipsToBounds = YES;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.shopImageView.bounds.size.height)
                                              style:UITableViewStyleGrouped];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.view addSubview:self.shopImageView];
    [self.view addSubview:self.tableView];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *navigateButton = [[UIBarButtonItem alloc] initWithTitle:[I18N key:@"navigate_to_title"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(navigateTo)];
    [self.navigationItem setRightBarButtonItem:navigateButton];

    __weak DetailViewController *preventCircularRef = self;

    self.fetchTask = [self.beans.coffeeService fetchDetailWithShopId:self.id];
    [self.fetchTask
      continueWithExecutor:[BFExecutor mainThreadExecutor]
                 withBlock:^id(BFTask *task) {
                     preventCircularRef.fetchTask = nil;
                     if (task.error) {
                         return nil;
                     }
                     if (task.isCancelled) {
                         return nil;
                     }
                     preventCircularRef.coffeeShopDetail = task.result;
                     [preventCircularRef.tableView reloadData];
                     return nil;
                 }];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [OSViewHelper alignCenter:self.shopImageView containerWidth:self.view.bounds.size.width];
    [OSViewHelper locate:self.shopImageView y:self.topBarOffset];

    [OSViewHelper locate:self.tableView y:[OSViewHelper bottomOf:self.shopImageView]];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void) navigateTo {
    if (![ExternalApp supportGoogleMap]) {
        [self launchNativeNavigation];
        return;
    }

    NSString *appleMap = [I18N key:LAUNCH_APPLE_MAP_DIRECTION_I18N_KEY];
    NSString *googleMap = [I18N key:LAUNCH_GOOGLE_MAP_DIRECTION_I18N_KEY];
    NSString *cancel = [I18N key:@"cancel"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                 initWithTitle:[I18N key:@"choose_navigation"]
                                                      delegate:self
                                             cancelButtonTitle:cancel
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:appleMap, googleMap, nil];
    [actionSheet showInView:self.view];
}

- (void) launchNativeNavigation {
    CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(self.coffeeShopDetail.coffeeShop.latitude, self.coffeeShopDetail.coffeeShop.longitude);
    [ExternalApp openNativeNavigation:toLocation address:self.coffeeShopDetail.address];
}

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[I18N key:LAUNCH_APPLE_MAP_DIRECTION_I18N_KEY]]) {
        [self launchNativeNavigation];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[I18N key:LAUNCH_GOOGLE_MAP_DIRECTION_I18N_KEY]]) {
        CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(self.coffeeShopDetail.coffeeShop.latitude, self.coffeeShopDetail.coffeeShop.longitude);
        [ExternalApp openGoogleMapDirection:toLocation];
    }
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return ShopDetailTotalCount;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"DetailCell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row) {
        case ShopName:
            cell.textLabel.text = [I18N key:@"shop_name_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.coffeeShop.name;
            break;
        case ShopAddress:
            cell.textLabel.text = [I18N key:@"address_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.address;
            break;
        case ShopDescription: {
            cell.textLabel.text = [I18N key:@"desctiption_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.shopDescription]) {
                cell.detailTextLabel.text = self.coffeeShopDetail.shopDescription;
            }
            break;
        }
        case ShopHour: {
            cell.textLabel.text = [I18N key:@"hour_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.hours]) {
                cell.detailTextLabel.text = self.coffeeShopDetail.hours;
            }
            break;
        }
        case ShopWebSite: {
            cell.textLabel.text = [I18N key:@"website_title"];
            if (![NSString isEmptyAfterTrim:self.coffeeShopDetail.websiteUrl]) {
                cell.detailTextLabel.text = self.coffeeShopDetail.websiteUrl;
            }
            break;
        }
        case ShopWifiPower:
            cell.textLabel.text = [I18N key:@"wifi_power_title"];
            cell.detailTextLabel.text = self.coffeeShopDetail.coffeeShop.infoString;
            break;
        default:
            return nil;
    }

    return cell;
}

@end