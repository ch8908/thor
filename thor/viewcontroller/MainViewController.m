//
// Created by Huang ChienShuo on 8/20/13.
// Copyright (c) 2013 oSolve. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MapKit/MapKit.h>
#import <MMDrawerController/MMDrawerController.h>
#import <Bolts/BFTask.h>
#import "MainViewController.h"
#import "I18N.h"
#import "CoffeeShop.h"
#import "TRAnnotation.h"
#import "CoffeeShop+Strings.h"
#import "Views.h"
#import "CoffeeService.h"
#import "DetailViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "UINavigationItem+Util.h"
#import "UIImage+Util.h"
#import "UIColor+Constant.h"
#import "RNGridMenu.h"
#import "Pref.h"
#import "TRFilterState.h"
#import "CoffeeManager.h"
#import "System.h"
#import "BFExecutor.h"
#import "SearchShopViewController.h"


@interface MainViewController()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, RNGridMenuDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *coffeeShopsUseInTableView;
@property (nonatomic, strong) NSMutableArray *allCoffeeShops;
@property (nonatomic, strong) NSMutableDictionary *annotations;
@property (nonatomic, strong) UIButton *locateButton;
@property (nonatomic, assign) BOOL initUserLocation;
@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *zoomInButton;
@property (nonatomic, strong) UIButton *zoomOutButton;
@property (nonatomic, strong) TRFilterState *filterState;
@property (nonatomic, strong) SearchShopViewController *searchShopViewController;
@end

@implementation MainViewController

- (id) initWithMainView
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _coffeeShopsUseInTableView = [NSMutableArray array];
        _allCoffeeShops = [NSMutableArray array];
    }
    return self;
}

- (void) loadView
{
    [super loadView];

    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    _locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locateButton setImage:[UIImage imageNamed:@"image/button_locate_normal.png"]
                       forState:UIControlStateNormal];
    [self.locateButton setImage:[UIImage imageNamed:@"image/button_locate_pressed.png"]
                       forState:UIControlStateHighlighted];
    [self.locateButton setBackgroundImage:[UIImage imageWithColor:[UIColor filterButtonBgColorNormal]]
                                 forState:UIControlStateNormal];

    [self.locateButton setBackgroundImage:[UIImage imageWithColor:[UIColor filterButtonBgColorHighlighted]]
                                 forState:UIControlStateHighlighted];
    [self.locateButton addTarget:self action:@selector(setMapCenterUser)
                forControlEvents:UIControlEventTouchUpInside];

    _tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:self.tableViewController];
    self.tableViewController.tableView.delegate = self;
    self.tableViewController.tableView.dataSource = self;

    _tableView = self.tableViewController.tableView;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];

    _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setTitle:[I18N key:@"filter_button_title"] forState:UIControlStateNormal];
    [self.filterButton setBackgroundImage:[UIImage imageWithColor:[UIColor filterButtonBgColorNormal]]
                                 forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(filter)
                forControlEvents:UIControlEventTouchUpInside];

    [self.filterButton setBackgroundImage:[UIImage imageWithColor:[UIColor filterButtonBgColorHighlighted]]
                                 forState:UIControlStateHighlighted];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(onRefreshShops)
             forControlEvents:UIControlEventValueChanged];

    self.tableViewController.refreshControl = refreshControl;

    _zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zoomInButton setImage:[UIImage imageNamed:@"image/button_map_zoomin.png"]
                       forState:UIControlStateNormal];
    [self.zoomInButton sizeToFit];
    [self.zoomInButton addTarget:self action:@selector(zoomIn)
                forControlEvents:UIControlEventTouchUpInside];

    _zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zoomOutButton setImage:[UIImage imageNamed:@"image/button_map_zoomout.png"]
                        forState:UIControlStateNormal];
    [self.zoomOutButton sizeToFit];
    [self.zoomOutButton addTarget:self action:@selector(zoomOut)
                 forControlEvents:UIControlEventTouchUpInside];

    _filterState = [[TRFilterState alloc] init];

    _searchShopViewController = [[SearchShopViewController alloc] initWithMainViewController:self];

}


- (void) viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitleViewWithTitle:[I18N key:@"places_title"] animated:NO];

    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image/button_drawer_icon.png"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(onSlideMenuButtonPress)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];


    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image/icon_search.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(onSearchButtonClick)];
    [self.navigationItem setRightBarButtonItem:searchBarButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSearchDistanceChangedNotification:)
                                                 name:SearchDistanceChangedNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSearchShopSuccessNotification:)
                                                 name:SearchShopSuccessNotification object:nil];

}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.searchShopViewController.view setNeedsLayout];
    [self.searchShopViewController.view layoutIfNeeded];

    // for different screen
    CGFloat tableViewY = 280;
    if ([Views screenHeight] > SCREEN_HEIGHT_3_5_INCH)
    {
        tableViewY = 320;
    }

    [Views resize:self.tableView
    containerSize:CGSizeMake([Views widthOfView:self.view], [Views heightOfView:self.view] - tableViewY - self.bottomBarOffset)];

    UIToolbar *blurBg = [[UIToolbar alloc] initWithFrame:self.tableView.bounds];
    blurBg.translucent = YES;
    blurBg.barStyle = UIBarStyleDefault;
    self.tableView.backgroundView = blurBg;

    [Views locate:self.tableView y:tableViewY];

    [self.locateButton sizeToFit];
    [Views locate:self.locateButton x:5
                y:[Views yOfView:self.tableView] - [Views heightOfView:self.locateButton] - 5];

    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:26];
    [self.filterButton sizeToFit];

    [Views locate:self.filterButton x:[Views widthOfView:self.mapView] - [Views widthOfView:self.filterButton] - 5
                y:[Views yOfView:self.tableView] - [Views heightOfView:self.filterButton] - 5];

    [Views locate:self.zoomOutButton x:[Views widthOfView:self.view] - [Views widthOfView:self.zoomInButton] - 10
                y:[Views yOfView:self.filterButton] - [Views heightOfView:self.zoomOutButton]];

    [Views locate:self.zoomInButton x:[Views xOfView:self.zoomOutButton]
                y:[Views yOfView:self.zoomOutButton] - [Views heightOfView:self.zoomInButton] - 5];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.locateButton];
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.zoomInButton];
    [self.view addSubview:self.zoomOutButton];
}

#pragma Notification callback

- (void) onSearchShopSuccessNotification:(NSNotification *) notification
{
    CoffeeShop *coffeeShop = notification.object;

    if ([self.coffeeShopsUseInTableView containsObject:coffeeShop])
    {
        [self openAnnotationWithShop:coffeeShop];
        return;
    }

    [self.allCoffeeShops addObject:coffeeShop];

    [self reloadFilteredCoffeeShopsWithCompletion:^{
        [self openAnnotationWithShop:coffeeShop];
    }];
}

- (void) onSearchDistanceChangedNotification:(NSNotification *) notification
{
    NSNumber *distance = notification.object;
    [self listCoffeeShopsWithCoordinate:self.mapView.userLocation.coordinate distance:distance];
}

- (void) onSearchButtonClick
{
    [self.mm_drawerController addChildViewController:self.searchShopViewController];
    [self.mm_drawerController.view insertSubview:self.searchShopViewController.view
                                    aboveSubview:self.mm_drawerController.centerViewController.view];
    [self.searchShopViewController searchBarBecomeFirstResponder];
}

#pragma RNGridMenu delegate

- (void) gridMenu:(RNGridMenu *) gridMenu willDismissWithSelectedItem:(RNGridMenuItem *) item atIndex:(NSInteger) itemIndex
{
    if (itemIndex == 0)
    {
        self.filterState.needWifi = !self.filterState.needWifi;
    }
    else if (itemIndex == 1)
    {
        self.filterState.needPower = !self.filterState.needPower;
    }

    [self reloadFilteredCoffeeShopsWithCompletion:nil];
}

- (void) filter
{
    RNGridMenuItem *wifiItem = [[RNGridMenuItem alloc] initWithImage:[self wifiItemImage]
                                                               title:@"Wifi"];

    RNGridMenuItem *powerItem = [[RNGridMenuItem alloc] initWithImage:[self powerItemImage]
                                                                title:@"Power"];
    NSArray *items = @[
      wifiItem,
      powerItem
    ];

    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, items.count)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self.navigationController
                      center:CGPointMake([Views widthOfView:self.view] / 2.f, [Views heightOfView:self.view] / 2.f)];
}

- (UIImage *) wifiItemImage
{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    if (self.filterState.needWifi)
    {
        return [UIImage imageWithRect:rect
                                color:[UIColor whiteColor]];
    }
    return [UIImage imageWithRect:rect
                            color:[UIColor grayColor]];
}

- (UIImage *) powerItemImage
{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    if (self.filterState.needPower)
    {
        return [UIImage imageWithRect:rect
                                color:[UIColor whiteColor]];
    }
    return [UIImage imageWithRect:rect
                            color:[UIColor grayColor]];
}

#pragma mapView Zoom method

- (void) zoomOut
{

}

- (void) zoomIn
{

}

- (void) listCoffeeShopsWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    NSNumber *distance = [[[Pref sharedInstance] searchDistance] getNumber];
    [self listCoffeeShopsWithCoordinate:coordinate distance:distance];
}

- (void) listCoffeeShopsWithCoordinate:(CLLocationCoordinate2D) coordinate distance:(NSNumber *) distance
{
    __weak MainViewController *preventCircularRef = self;
    [[[CoffeeService sharedInstance] fetchShopsWithCenter:coordinate searchDistance:distance]
                     continueWithExecutor:[BFExecutor mainThreadExecutor]
                                withBlock:^id(BFTask *task) {
                                    if (task.error)
                                    {
                                        [preventCircularRef endRefreshShops];
                                        return nil;
                                    }
                                    if (task.isCancelled)
                                    {
                                        [preventCircularRef endRefreshShops];
                                        return nil;
                                    }

                                    [preventCircularRef endRefreshShops];
                                    [preventCircularRef.allCoffeeShops removeAllObjects];
                                    [preventCircularRef.allCoffeeShops addObjectsFromArray:task.result];

                                    [preventCircularRef reloadFilteredCoffeeShopsWithCompletion:nil];
                                    return nil;
                                }];
}

- (void) onRefreshShops
{
    [self.navigationItem setTitleViewWithTitle:@"Refresh" animated:YES];
    [self listCoffeeShopsWithCoordinate:self.mapView.userLocation.coordinate];
}

- (void) endRefreshShops
{
    if (self.tableViewController.refreshControl.refreshing)
    {
        [self.navigationItem setTitleViewWithTitle:[I18N key:@"places_title"] animated:YES];
    }
    else
    {
        [self.navigationItem setTitleViewWithTitle:[I18N key:@"places_title"] animated:NO];
    }
    [self.tableViewController.refreshControl endRefreshing];
}

- (void) reloadFilteredCoffeeShopsWithCompletion:(void (^)(void)) completion
{
    __weak MainViewController *preventCircularRef = self;
    [[[CoffeeManager sharedInstance] allShops:self.allCoffeeShops
                                  filterState:self.filterState]
                     continueWithExecutor:[BFExecutor mainThreadExecutor]
                                withBlock:^id(BFTask *task) {
                                    [preventCircularRef.coffeeShopsUseInTableView removeAllObjects];
                                    [preventCircularRef.coffeeShopsUseInTableView addObjectsFromArray:task.result];
                                    [preventCircularRef removeAllAnnotations];
                                    [preventCircularRef showCoffeeShopOnMap];
                                    [preventCircularRef.tableView reloadData];
                                    if (completion)
                                    {
                                        completion();
                                    }
                                    return nil;
                                }];
}

- (void) removeAllAnnotations
{
    [self.mapView removeAnnotations:[self.annotations allValues]];
}

- (void) showCoffeeShopOnMap
{
    if (self.annotations)
    {
        self.annotations = nil;
    }
    self.annotations = [[NSMutableDictionary alloc] init];
    for (CoffeeShop *coffeeShop in self.coffeeShopsUseInTableView)
    {
        TRAnnotation *annotation = [[TRAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(coffeeShop.latitude, coffeeShop.longitude)
                                                                         id:coffeeShop.id
                                                                       name:coffeeShop.name
                                                                       info:coffeeShop.infoString];
        [self.mapView addAnnotation:annotation];
        [self.annotations setObject:annotation forKey:coffeeShop.id];
    }
}

- (void) onSlideMenuButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma MKMapViewDelegate method

- (void) mapView:(MKMapView *) mapView didUpdateUserLocation:(MKUserLocation *) userLocation
{
    if (self.initUserLocation)
    {
        return;
    }
    MKCoordinateRegion mapRegion;
    mapRegion.center = userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;

    [self setOffsetRegion:mapRegion];

    self.initUserLocation = YES;
    [self listCoffeeShopsWithCoordinate:userLocation.coordinate];
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    MKPinAnnotationView *mapPin = nil;
    if ([self isUserLocationAnnotation:annotation])
    {
        return nil;
    }

    static NSString *defaultPinID = @"defaultPin";
    mapPin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (mapPin == nil )
    {
        mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:defaultPinID];
        mapPin.canShowCallout = YES;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        mapPin.rightCalloutAccessoryView = infoButton;
    }
    else
        mapPin.annotation = annotation;

    return mapPin;
}

- (void) mapView:(MKMapView *) mapView annotationView:(MKAnnotationView *) view calloutAccessoryControlTapped:(UIControl *) control
{
    if (![view.annotation isKindOfClass:[TRAnnotation class]])
    {
        return;
    }
    TRAnnotation *annotation = (TRAnnotation *) view.annotation;
    DetailViewController *detailViewController = [[DetailViewController alloc] initDetailViewControllerWithId:annotation.id];
    DetailViewController *controller = detailViewController;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) mapView:(MKMapView *) mapView didSelectAnnotationView:(MKAnnotationView *) view
{
    if ([self isUserLocationAnnotation:view.annotation])
    {
        return;
    }
    [self setMapCenterToCoordinate:view.annotation.coordinate];
    [self selectCellWithAnnotation:(TRAnnotation *) view.annotation];
}

- (BOOL) isUserLocationAnnotation:(id<MKAnnotation>) annotation
{
    return annotation == self.mapView.userLocation;
}

- (void) selectCellWithAnnotation:(TRAnnotation *) annotation
{
    NSNumber *id = annotation.id;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    CoffeeShop *selectedShop = self.coffeeShopsUseInTableView[(NSUInteger) selectedIndexPath.row];

    if ([selectedShop.id isEqualToNumber:id])
    {
        return;
    }

    NSInteger index = NSNotFound;
    for (NSUInteger i = 0; i < self.coffeeShopsUseInTableView.count; i++)
    {
        CoffeeShop *shop = self.coffeeShopsUseInTableView[i];
        if ([shop.id isEqualToNumber:id])
        {
            index = i;
            break;
        }
    }

    if (index == NSNotFound)
    {
        return;
    }

    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                            inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma UITableViewDataSource method

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.coffeeShopsUseInTableView.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = (UITableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    }

    CoffeeShop *coffeeShop = self.coffeeShopsUseInTableView[(NSUInteger) indexPath.row];
    cell.textLabel.text = coffeeShop.name;
    cell.detailTextLabel.text = [coffeeShop distanceStringWithCenter:self.mapView.userLocation.coordinate];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    CoffeeShop *shop = self.coffeeShopsUseInTableView[(NSUInteger) indexPath.row];
    [self openAnnotationWithShop:shop];
}

- (void) openAnnotationWithShop:(CoffeeShop *) coffeeShop
{
    TRAnnotation *shopAnnotation = [self.annotations objectForKey:coffeeShop.id];
    if (shopAnnotation)
    {
        [self.mapView selectAnnotation:shopAnnotation animated:YES];
    }
}

- (void) setMapCenterUser
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self setOffsetRegion:mapRegion];
}

- (void) setOffsetRegion:(MKCoordinateRegion) mapRegion
{
    mapRegion.center.latitude -= mapRegion.span.latitudeDelta * 0.30;
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void) setMapCenterToCoordinate:(CLLocationCoordinate2D) coordinate
{
    MKCoordinateSpan currentSpan = self.mapView.region.span;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    mapRegion.span.latitudeDelta = currentSpan.latitudeDelta < 0.01 ? currentSpan.latitudeDelta : 0.01;
    mapRegion.span.longitudeDelta = currentSpan.longitudeDelta < 0.01 ? currentSpan.longitudeDelta : 0.01;

    [self setOffsetRegion:mapRegion];
}

@end