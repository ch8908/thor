//
// Created by Huang ChienShuo on 1/23/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import "AddShopViewController.h"
#import "Views.h"
#import "I18N.h"
#import "CoffeeService.h"
#import "SubmitInfo.h"
#import "MKMapView+ZoomLevel.h"

CGFloat PADDING_HORIZONTAL = 10;
NSInteger INPUT_ADDRESS_TEXT_FIELD_TAG = 1;


@interface AddShopViewController()<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property MKMapView* mapView;
@property (nonatomic) BOOL initUserLocation;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLGeocoder* geocoder;
@property (nonatomic) UIImageView* centerPin;
@property (nonatomic) UITextView* addressTextViewFromMapCenter;
@property (nonatomic) UILabel* addressFromMapCenterTitle;
@property (nonatomic) UILabel* inputAddressTitle;
@property (nonatomic) UITextField* inputAddressTextField;
@property (nonatomic) UIActivityIndicatorView* indicatorViewForMap;
@property (nonatomic) UILabel* inputPhoneTitle;
@property (nonatomic) UITextField* inputPhoneTextField;
@property (nonatomic) UILabel* inputNameTitle;
@property (nonatomic) UITextField* inputNameTextField;
@property (nonatomic) CGFloat viewAndKeyboardOffset;
@property (nonatomic) UISwitch* wifiFreeSwitch;
@property (nonatomic) UISwitch* powerOutletSwitch;
@property (nonatomic) UILabel* wifiFreeTitle;
@property (nonatomic) UILabel* powerOutletTitle;
@property (nonatomic) UIButton* zoomInButton;
@property (nonatomic) UIButton* zoomOutButton;
@property (nonatomic) UIBarButtonItem* submitButton;
@property (nonatomic) UIBarButtonItem* cancelButton;
@end

@implementation AddShopViewController

- (id) initAddShopViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.showsUserLocation = YES;

        _scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.alwaysBounceVertical = YES;

        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];

        _geocoder = [[CLGeocoder alloc] init];
        _centerPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/icon_map_center_pin.png"]];

        _addressTextViewFromMapCenter = [[UITextView alloc] init];
        self.addressTextViewFromMapCenter.editable = NO;
        self.addressTextViewFromMapCenter.backgroundColor = [UIColor clearColor];
        self.addressTextViewFromMapCenter.textColor = [UIColor blackColor];
        self.addressTextViewFromMapCenter.font = [UIFont systemFontOfSize:14];

        _addressFromMapCenterTitle = [self titleLabelWithTitle:[I18N key:@"address_above_title"]];

        _inputAddressTitle = [self titleLabelWithTitle:[I18N key:@"input_address_title"]];
        _inputAddressTextField = [self inputTextFieldWithPlaceholder:[I18N key:@"input_address_placeholder"]];
        self.inputAddressTextField.tag = INPUT_ADDRESS_TEXT_FIELD_TAG;

        _indicatorViewForMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

        _inputPhoneTitle = [self titleLabelWithTitle:[I18N key:@"input_phone_title"]];
        _inputPhoneTextField = [self inputTextFieldWithPlaceholder:[I18N key:@"input_phone_placeholder"]];

        _inputNameTitle = [self titleLabelWithTitle:[I18N key:@"input_name_title"]];
        _inputNameTextField = [self inputTextFieldWithPlaceholder:[I18N key:@"input_name_placeholder"]];

        _wifiFreeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        _powerOutletSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];

        _wifiFreeTitle = [self switchLabelWithTitle:[I18N key:@"wifi_free_title"]];
        _powerOutletTitle = [self switchLabelWithTitle:[I18N key:@"power_outlet_title"]];

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

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAddShopSuccessNotification)
                                                     name:AddShopSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAddShopFailedNotification:)
                                                     name:AddShopFailedNotification
                                                   object:nil];
    }
    return self;
}

- (UILabel*) switchLabelWithTitle:(NSString*) title
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = title;
    return label;
}

- (UILabel*) titleLabelWithTitle:(NSString*) title
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

- (UITextField*) inputTextFieldWithPlaceholder:(NSString*) placeHolder
{
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - PADDING_HORIZONTAL * 2, 36)];
    textField.font = [UIFont systemFontOfSize:12];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.textColor = [UIColor blackColor];
    textField.placeholder = placeHolder;
    textField.delegate = self;
    return textField;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:self.cancelButton];

    self.submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                      target:self
                                                                      action:@selector(onSubmit)];
    [self.navigationItem setRightBarButtonItem:self.submitButton];

    [self.navigationItem setTitle:[I18N key:@"add_shop_title"]];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.mapView containerSize:CGSizeMake(self.view.bounds.size.width, 120)];
    [Views locate:self.mapView y:self.topBarOffset];

    [Views alignCenterMiddle:self.centerPin containerFrame:self.mapView.bounds];

    // zoom in, zoom out buttons
    [Views locate:self.zoomOutButton x:self.mapView.bounds.size.width - self.zoomOutButton.bounds.size.width - 3
                y:self.mapView.bounds.size.height - self.zoomOutButton.bounds.size.height];
    [Views locate:self.zoomInButton x:self.zoomOutButton.frame.origin.x - self.zoomInButton.bounds.size.width - 3
                y:self.zoomOutButton.frame.origin.y];

    [self.addressFromMapCenterTitle sizeToFit];
    [Views locate:self.addressFromMapCenterTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.mapView] + 10];

    [Views resize:self.indicatorViewForMap containerSize:CGSizeMake(24, 24)];
    [Views alignCenter:self.indicatorViewForMap withTarget:self.addressFromMapCenterTitle];
    [Views locate:self.indicatorViewForMap x:[Views rightOf:self.addressFromMapCenterTitle] + 3];

    [Views resize:self.addressTextViewFromMapCenter
    containerSize:CGSizeMake(self.view.bounds.size.width - PADDING_HORIZONTAL * 2, 40)];
    [Views locate:self.addressTextViewFromMapCenter x:PADDING_HORIZONTAL
                y:[Views bottomOf:self.addressFromMapCenterTitle]];

    // scroll view
    [Views resize:self.scrollView
    containerSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - [Views bottomOf:self.addressTextViewFromMapCenter])];
    [Views locate:self.scrollView y:[Views bottomOf:self.addressTextViewFromMapCenter]];

    [self.inputAddressTitle sizeToFit];
    [Views locate:self.inputAddressTitle x:PADDING_HORIZONTAL y:10];

    [Views locate:self.inputAddressTextField x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputAddressTitle] + 5];

    [self.inputNameTitle sizeToFit];
    [Views locate:self.inputNameTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputAddressTextField] + 5];

    [Views locate:self.inputNameTextField x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputNameTitle]];

    [self.inputPhoneTitle sizeToFit];
    [Views locate:self.inputPhoneTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputNameTextField] + 5];

    [Views locate:self.inputPhoneTextField x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputPhoneTitle]];

    [self.wifiFreeTitle sizeToFit];
    [Views locate:self.wifiFreeTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.inputPhoneTextField] + 10];
    [Views alignCenter:self.wifiFreeSwitch withTarget:self.wifiFreeTitle];
    [Views locate:self.wifiFreeSwitch x:[Views rightOf:self.wifiFreeTitle]];

    [self.powerOutletTitle sizeToFit];
    [Views locate:self.powerOutletTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.self.wifiFreeTitle] + 20];
    [Views alignCenter:self.powerOutletSwitch withTarget:self.powerOutletTitle];
    [Views locate:self.powerOutletSwitch x:[Views rightOf:self.powerOutletTitle]];

    [self.mapView addSubview:self.centerPin];
    [self.mapView addSubview:self.zoomInButton];
    [self.mapView addSubview:self.zoomOutButton];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.addressFromMapCenterTitle];
    [self.view addSubview:self.addressTextViewFromMapCenter];
    [self.view addSubview:self.indicatorViewForMap];

    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.inputAddressTitle];
    [self.scrollView addSubview:self.inputAddressTextField];
    [self.scrollView addSubview:self.inputPhoneTitle];
    [self.scrollView addSubview:self.inputPhoneTextField];
    [self.scrollView addSubview:self.inputNameTitle];
    [self.scrollView addSubview:self.inputNameTextField];
    [self.scrollView addSubview:self.wifiFreeTitle];
    [self.scrollView addSubview:self.powerOutletTitle];
    [self.scrollView addSubview:self.wifiFreeSwitch];
    [self.scrollView addSubview:self.powerOutletSwitch];
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSubmit
{
    [self.view endEditing:YES];
    self.submitButton.enabled = NO;

    SubmitInfo* info = [[SubmitInfo alloc] init];
    info.name = self.inputNameTextField.text;
    info.phone = self.inputPhoneTitle.text;
    info.is_wifi_free = self.wifiFreeSwitch.isOn;
    info.power_outlets = self.powerOutletSwitch.isOn;
    info.latitude = self.mapView.centerCoordinate.latitude;
    info.longitude = self.mapView.centerCoordinate.longitude;
    info.address = self.addressTextViewFromMapCenter.text;
    info.website_rul = @"http://tw.yahoo.com";
    info.hours = @"111";
    info.shopDescription = @"description";

    [[CoffeeService sharedInstance] submitShopInfo:info];

    [self showIndicatorOnNavigationBar];
}

- (void) showIndicatorOnNavigationBar
{
    self.navigationItem.title = @"";
    [self.navigationItem setTitleView:[self getIndicatorView]];
}

- (UILabel*) navigationBarTitleLabelWithString:(NSString*) title
{
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel;
}

- (UIView*) getIndicatorView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.backgroundColor = [UIColor clearColor];
    [indicatorView sizeToFit];

    UILabel* titleLabel = [self navigationBarTitleLabelWithString:[I18N key:@"submiting_message"]];

    [Views alignCenterMiddle:titleLabel containerFrame:view.frame];
    [Views alignMiddle:indicatorView containerHeight:view.bounds.size.height];
    [Views locate:indicatorView x:titleLabel.frame.origin.x - indicatorView.bounds.size.width - 3];

    [view addSubview:indicatorView];
    [view addSubview:titleLabel];

    [indicatorView startAnimating];
    return view;
}

- (void) onAddShopFailedNotification:(NSNotification*) notification
{
    [self showNavigationTitleWithString:[I18N key:@"submit_failed"]];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[I18N key:@"submit_failed"]
                                                        message:[I18N key:@"submit_again_message"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:[I18N key:@"try_again"], nil];
    [alertView show];
}

- (void) onAddShopSuccessNotification
{
    [self showNavigationTitleWithString:[I18N key:@"submit_success"]];
}

- (void) showNavigationTitleWithString:(NSString*) message
{
    self.submitButton.enabled = YES;

    UILabel* titleView = [self navigationBarTitleLabelWithString:message];
    [self.navigationItem setTitleView:titleView];

    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitle:[I18N key:@"add_shop_title"]];
    });
}

- (void) zoomOut
{
    NSUInteger nextZoomLevel = self.mapView.zoomLevel - 1;
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:nextZoomLevel
                             animated:YES];
}

- (void) zoomIn
{
    NSUInteger nextZoomLevel = self.mapView.zoomLevel + 1;
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:nextZoomLevel
                             animated:YES];
}

- (void) locationManager:(CLLocationManager*) manager didUpdateLocations:(NSArray*) locations
{
    if (self.initUserLocation)
    {
        return;
    }
    MKCoordinateRegion mapRegion;
    mapRegion.center = manager.location.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;

    // Set delegate right now, prevent first location show in USA, CA (that's mapView default location)
    self.mapView.delegate = self;

    [self.mapView setRegion:mapRegion animated:NO];
    self.initUserLocation = YES;
}

- (void) mapView:(MKMapView*) mapView regionWillChangeAnimated:(BOOL) animated
{
    [self.indicatorViewForMap startAnimating];
}

- (void) mapView:(MKMapView*) mapView regionDidChangeAnimated:(BOOL) animated
{
    CLLocation* location = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude
                                                      longitude:self.mapView.centerCoordinate.longitude];

    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray* placemarks, NSError* error) {
                            [self.indicatorViewForMap stopAnimating];
                            if (error)
                            {
                                return;
                            }
                            CLPlacemark* placemark = [placemarks lastObject];
                            if (placemark)
                            {
                                [self setAddressWithPlacemark:placemark];
                            }
                        }];
}

- (void) setAddressWithPlacemark:(CLPlacemark*) placemark
{
    NSString* addressString = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    NSString* newAddress = [addressString stringByReplacingOccurrencesOfString:@"\n"
                                                                    withString:@" "];
    self.addressTextViewFromMapCenter.text = newAddress;
}

- (void) setLocationWithPlacemark:(CLPlacemark*) placemark
{
    MKCoordinateSpan currentSpan = self.mapView.region.span;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    mapRegion.span.latitudeDelta = currentSpan.latitudeDelta < 0.01 ? currentSpan.latitudeDelta : 0.01;
    mapRegion.span.longitudeDelta = currentSpan.longitudeDelta < 0.01 ? currentSpan.longitudeDelta : 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField*) textField
{
    if (INPUT_ADDRESS_TEXT_FIELD_TAG != textField.tag)
    {
        return;
    }
    [self.indicatorViewForMap startAnimating];
    NSString* queryAddressString = textField.text;
    [self.geocoder geocodeAddressString:queryAddressString
                      completionHandler:^(NSArray* placemarks, NSError* error) {
                          [self.indicatorViewForMap stopAnimating];
                          if (error)
                          {
                              return;
                          }
                          CLPlacemark* placemark = [placemarks lastObject];
                          if (placemark)
                          {
                              [self setLocationWithPlacemark:placemark];
                          }
                      }];
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void) keyboardWillHide:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        [Views locate:self.view y:self.view.frame.origin.y];
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y + self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

- (void) keyboardWillShow:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect convertFrame = [self.view convertRect:self.inputPhoneTextField.frame fromView:self.scrollView];

    CGFloat diff = endFrame.origin.y - (convertFrame.origin.y + convertFrame.size.height + self.view.frame.origin.y);
    if (diff > 0)
    {
        return;
    }
    self.viewAndKeyboardOffset = (CGFloat) fabs(diff) + 5;
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y - self.viewAndKeyboardOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
}

@end