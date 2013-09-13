//
// Created by Huang ChienShuo on 8/20/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "ViewParams.h"
#import "FacebookDaemon.h"
#import "Place.h"
#import "Beans.h"
#import "BadOrderListController.h"
#import "I18N.h"

@interface MainViewController()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) UITableView* placeListTableView;
@property (nonatomic, strong) NSMutableArray* placeArray;
@end

@implementation MainViewController
@synthesize placeListTableView = _placeListTableView;
@synthesize mapView = _mapView;
@synthesize placeArray = _placeArray;

- (id) initWithMainView
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationItem.title = [I18N key:@"places_title"];

        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;


        _placeListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _placeListTableView.dataSource = self;
        _placeListTableView.delegate = self;
        [self.view addSubview:_mapView];
        [self.view addSubview:_placeListTableView];

        UIBarButtonItem* loginButton = [[UIBarButtonItem alloc] initWithTitle:[I18N key:@"login"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(login)];
        [self.navigationItem setRightBarButtonItem:loginButton];
    }

    return self;
}

- (void) login
{

}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect mapViewFrame = CGRectMake(0, 0, [ViewParams screenWidth], 200);
    self.mapView.frame = mapViewFrame;

    CGRect tableViewFrame = CGRectMake(0,
                                       mapViewFrame.origin.y + mapViewFrame.size.height,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - mapViewFrame.size.height);
    self.placeListTableView.frame = tableViewFrame;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.placeArray = [[NSMutableArray alloc] init];
    NSArray* list = [[[Beans sharedInstance] facebookDaemon] queryPlace];
    [self refreshPlaceTableView:list];
}

- (void) mapView:(MKMapView*) mapView didUpdateUserLocation:(MKUserLocation*) userLocation
{
    MKCoordinateRegion mapRegion;
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = 121.533916;
    coordinate.latitude = 25.01517;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void) refreshPlaceTableView:(NSArray*) placeList
{
    [self.placeArray addObjectsFromArray:placeList];
    [self.placeArray addObject:placeList[0]];
    [self.placeListTableView reloadData];
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.placeArray.count;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    static NSString* CellIdentifier = @"Cell";

    UITableViewCell* cell = (UITableViewCell*)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    Place* place = self.placeArray[(NSUInteger) indexPath.row];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.address;
    return cell;
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    Place* place = self.placeArray[(NSUInteger) indexPath.row];
    BadOrderListController* badMenuController = [[BadOrderListController alloc] initBadMenuWithTitle:place.name];
    [self.navigationController pushViewController:badMenuController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end