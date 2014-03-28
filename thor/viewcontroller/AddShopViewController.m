//
// Created by Huang ChienShuo on 1/23/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import <Bolts/BFTask.h>
#import "AddShopViewController.h"
#import "Views.h"
#import "I18N.h"
#import "CoffeeService.h"
#import "SubmitInfo.h"
#import "MKMapView+ZoomLevel.h"
#import "NSString+Util.h"
#import "UINavigationItem+Util.h"
#import "TextFieldCell.h"
#import "SwitchCell.h"
#import "UIColor+Constant.h"

CGFloat const PADDING_HORIZONTAL = 10;

/*
    Best Practice: Managing Text Fields and Text Views
    https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/ManageTextFieldTextViews/ManageTextFieldTextViews.html
 */
enum
{
    AddressFieldTag = 0,
    NameFieldTag,
    PhoneNumberFieldTag,
    WebsiteUrlFieldTag,
    DescriptionFieldTag,
    HoursFiendTag,
    WifiAvailableTag,
    PowerAvailableTag,
};

enum
{
    SectionRequiredInfo = 0,
    SectionOfOptionalInfo,
    TotalSections,
};

enum
{
    RequiredAddressRow = 0,
    RequiredNameRow,
    TotalCountOfRequiredRows,
};

enum
{
    OptionalPhoneNumberRow = 0,
    OptionalWebsiteUrl,
    OptionalDescription,
    OptionalHours,
    OptionalWifiAvailable,
    OptionalPowerAvailable,
    TotalCountOfOptionalRows,
};

@interface AddShopViewController()<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL initUserLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UIImageView *centerPin;
@property (nonatomic, strong) UITextView *addressTextViewFromMapCenter;
@property (nonatomic, strong) UILabel *addressFromMapCenterTitle;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorViewForMap;
@property (nonatomic, assign) CGFloat viewAndKeyboardOffset;
@property (nonatomic, strong) UIButton *zoomInButton;
@property (nonatomic, strong) UIButton *zoomOutButton;
@property (nonatomic, strong) UIBarButtonItem *submitButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) SubmitInfo *submitInfo;
@property (nonatomic, strong) UITextField *activeField;
@end

@implementation AddShopViewController

- (id) initAddShopViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _submitInfo = [[SubmitInfo alloc] init];

        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void) loadView
{
    [super loadView];

    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.showsUserLocation = YES;

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    _centerPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/icon_map_center_pin.png"]];

    _addressTextViewFromMapCenter = [[UITextView alloc] init];
    self.addressTextViewFromMapCenter.editable = NO;
    self.addressTextViewFromMapCenter.backgroundColor = [UIColor clearColor];
    self.addressTextViewFromMapCenter.textColor = [UIColor blackColor];
    self.addressTextViewFromMapCenter.font = [UIFont systemFontOfSize:14];

    _addressFromMapCenterTitle = [self titleLabelWithTitle:[I18N key:@"address_above_title"]];
    [self.addressFromMapCenterTitle sizeToFit];

    _indicatorViewForMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

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

    [self.mapView addSubview:self.centerPin];
    [self.mapView addSubview:self.zoomInButton];
    [self.mapView addSubview:self.zoomOutButton];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.addressFromMapCenterTitle];
    [self.view addSubview:self.addressTextViewFromMapCenter];
    [self.view addSubview:self.indicatorViewForMap];
    [self.view addSubview:self.tableView];
}

- (UILabel *) titleLabelWithTitle:(NSString *) title
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self.locationManager startUpdatingLocation];

    self.view.backgroundColor = [UIColor whiteColor];

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(onCancel)];
    [self.navigationItem setLeftBarButtonItem:self.cancelButton];

    self.submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                      target:self
                                                                      action:@selector(onSubmit)];
    [self.navigationItem setRightBarButtonItem:self.submitButton];

    [self.navigationItem setTitleViewWithTitle:[I18N key:@"add_shop_title"] animated:NO];

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
    [Views resize:self.mapView containerSize:CGSizeMake(self.view.bounds.size.width, 120)];
    [Views locate:self.mapView y:self.topBarOffset];

    [Views alignCenterMiddle:self.centerPin containerFrame:self.mapView.bounds];

    // zoom in, zoom out buttons
    [Views locate:self.zoomOutButton x:self.mapView.bounds.size.width - self.zoomOutButton.bounds.size.width - 3
                y:self.mapView.bounds.size.height - self.zoomOutButton.bounds.size.height];
    [Views locate:self.zoomInButton x:self.zoomOutButton.frame.origin.x - self.zoomInButton.bounds.size.width - 3
                y:self.zoomOutButton.frame.origin.y];

    [Views locate:self.addressFromMapCenterTitle x:PADDING_HORIZONTAL y:[Views bottomOf:self.mapView] + 10];

    [Views resize:self.indicatorViewForMap containerSize:CGSizeMake(24, 24)];
    [Views alignCenter:self.indicatorViewForMap withTarget:self.addressFromMapCenterTitle];
    [Views locate:self.indicatorViewForMap x:[Views rightOf:self.addressFromMapCenterTitle] + 3];

    [Views resize:self.addressTextViewFromMapCenter
    containerSize:CGSizeMake(self.view.bounds.size.width - PADDING_HORIZONTAL * 2, 40)];
    [Views locate:self.addressTextViewFromMapCenter x:PADDING_HORIZONTAL
                y:[Views bottomOf:self.addressFromMapCenterTitle]];

    [Views resize:self.tableView containerSize:CGSizeMake([Views widthOfView:self.view],
                                                          [Views heightOfView:self.view] - [Views bottomOf:self.addressTextViewFromMapCenter])];
    [Views locate:self.tableView y:[Views bottomOf:self.addressTextViewFromMapCenter]];
}

- (void) onCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSubmit
{
    [self.activeField resignFirstResponder];
    self.submitButton.enabled = NO;

    self.submitInfo.address = self.addressTextViewFromMapCenter.text;
    self.submitInfo.latitude = self.mapView.centerCoordinate.latitude;
    self.submitInfo.longitude = self.mapView.centerCoordinate.longitude;

    __weak AddShopViewController *preventCircularRef = self;
    [[[CoffeeService sharedInstance] submitShopInfo:self.submitInfo]
                     continueWithBlock:^id(BFTask *task) {
                         preventCircularRef.submitButton.enabled = YES;

                         if (task.error)
                         {
                             // Set UI Warning
                             UITextField *nameTextField = (UITextField *) [preventCircularRef.view viewWithTag:NameFieldTag];
                             [nameTextField setBackgroundColor:[UIColor requiredFieldWarningColor]];

                             [preventCircularRef showFailedAlertWithMessage:task.error.localizedDescription];
                             return nil;
                         }
                         [preventCircularRef showNavigationTitleWithString:[I18N key:@"submit_success"]];
                         return nil;
                     }];

    [self showIndicatorOnNavigationBar];
}

- (void) showIndicatorOnNavigationBar
{
    self.navigationItem.title = @"";
    [self.navigationItem setTitleView:[self getIndicatorView] animated:YES];
}

- (UILabel *) navigationBarTitleLabelWithString:(NSString *) title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel;
}

- (UIView *) getIndicatorView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.backgroundColor = [UIColor clearColor];
    [indicatorView sizeToFit];

    UILabel *titleLabel = [self navigationBarTitleLabelWithString:[I18N key:@"submiting_message"]];

    [Views alignCenterMiddle:titleLabel containerFrame:view.frame];
    [Views alignMiddle:indicatorView containerHeight:view.bounds.size.height];
    [Views locate:indicatorView x:titleLabel.frame.origin.x - indicatorView.bounds.size.width - 3];

    [view addSubview:indicatorView];
    [view addSubview:titleLabel];

    [indicatorView startAnimating];
    return view;
}

- (void) showFailedAlertWithMessage:(NSString *) message
{
    [self showNavigationTitleWithString:[I18N key:@"submit_failed"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[I18N key:@"submit_failed"]
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:[I18N key:@"try_again"], nil];
    [alertView show];
}

- (void) showNavigationTitleWithString:(NSString *) message
{
    [self.navigationItem setTitleViewWithTitle:message animated:YES];

    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitleViewWithTitle:[I18N key:@"add_shop_title"] animated:YES];
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

- (void) locationManager:(CLLocationManager *) manager didUpdateLocations:(NSArray *) locations
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

- (void) mapView:(MKMapView *) mapView regionWillChangeAnimated:(BOOL) animated
{
    [self.indicatorViewForMap startAnimating];
}

- (void) mapView:(MKMapView *) mapView regionDidChangeAnimated:(BOOL) animated
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude
                                                      longitude:self.mapView.centerCoordinate.longitude];

    __weak AddShopViewController *preventCircularRef = self;
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            [preventCircularRef.indicatorViewForMap stopAnimating];
                            if (error)
                            {
                                return;
                            }
                            CLPlacemark *placemark = [placemarks lastObject];
                            if (placemark)
                            {
                                [preventCircularRef setAddressWithPlacemark:placemark];
                            }
                        }];
}

- (void) setAddressWithPlacemark:(CLPlacemark *) placemark
{
    NSString *addressString = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    NSString *newAddress = [addressString stringByReplacingOccurrencesOfString:@"\n"
                                                                    withString:@" "];
    self.addressTextViewFromMapCenter.text = newAddress;
}

- (void) setLocationWithPlacemark:(CLPlacemark *) placemark
{
    MKCoordinateSpan currentSpan = self.mapView.region.span;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    mapRegion.span.latitudeDelta = currentSpan.latitudeDelta < 0.01 ? currentSpan.latitudeDelta : 0.01;
    mapRegion.span.longitudeDelta = currentSpan.longitudeDelta < 0.01 ? currentSpan.longitudeDelta : 0.01;
    [self.mapView setRegion:mapRegion animated:YES];
}

#pragma UITextFieldDelegate

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string
{
    if ([string stringByTrim].length > 0)
    {
        UITextField *nameTextField = (UITextField *) [self.view viewWithTag:NameFieldTag];
        [nameTextField setBackgroundColor:[UIColor inputFieldBgColor]];
    }
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField
{
    self.activeField = textField;
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *) textField
{
    self.activeField = nil;

    switch (textField.tag)
    {
        case NameFieldTag:
            self.submitInfo.name = textField.text;
            break;
        case PhoneNumberFieldTag:
            self.submitInfo.phone = textField.text;
            break;
        case WebsiteUrlFieldTag:
            self.submitInfo.websiteUrl = textField.text;
            break;
        case HoursFiendTag:
            self.submitInfo.hours = textField.text;
            break;
        case DescriptionFieldTag:
            self.submitInfo.shopDescription = textField.text;
            break;
        default:
            break;
    }

    if (textField.tag != AddressFieldTag)
    {
        return;
    }

    [self.indicatorViewForMap startAnimating];

    __weak AddShopViewController *preventCircularRef = self;

    NSString *queryAddressString = textField.text;
    [self.geocoder geocodeAddressString:queryAddressString
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          [preventCircularRef.indicatorViewForMap stopAnimating];
                          if (error)
                          {
                              return;
                          }
                          CLPlacemark *placemark = [placemarks lastObject];
                          if (placemark)
                          {
                              [preventCircularRef setLocationWithPlacemark:placemark];
                          }
                      }];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma  UIKeyboardNotification

- (void) keyboardWillHide:(NSNotification *) notification
{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];

    CGFloat offset = self.viewAndKeyboardOffset;
    [UIView animateWithDuration:duration animations:^{
        [Views locate:self.view y:self.view.frame.origin.y];
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y + offset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    }];
    self.viewAndKeyboardOffset = 0;
}

- (void) keyboardWillShow:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, kbSize.height, 0)];
}

- (void) onSwitch:(UISwitch *) sender
{
    if (WifiAvailableTag == sender.tag)
    {
        self.submitInfo.isWifiFree = sender.isOn;
    }
    else if (PowerAvailableTag == sender.tag)
    {
        self.submitInfo.powerOutlets = sender.isOn;
    }
}

#pragma UITableViewDataSourceDelegate

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
    switch (section)
    {
        case SectionRequiredInfo:
            return [I18N key:@"required_section_title"];
        case SectionOfOptionalInfo:
            return [I18N key:@"optional_section_title"];
        default:
            break;
    }
    return nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
    return TotalSections;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    switch (section)
    {
        case SectionRequiredInfo:
            return TotalCountOfRequiredRows;
        case SectionOfOptionalInfo:
            return TotalCountOfOptionalRows;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if ([self isSwitchCell:indexPath])
    {
        static NSString *CellIdentifier = @"SwitchCell";

        SwitchCell *cell = (SwitchCell *)
          [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil)
        {
            cell = [[SwitchCell alloc] initWithReuseIdentifier:CellIdentifier];
            [cell.switchButton addTarget:self action:@selector(onSwitch:)
                        forControlEvents:UIControlEventValueChanged];
        }

        switch (indexPath.row)
        {
            case OptionalWifiAvailable:
                cell.titleLabel.text = [I18N key:@"wifi_free_title"];
                cell.switchButton.tag = WifiAvailableTag;
                [cell.switchButton setOn:self.submitInfo.isWifiFree];
                break;
            case OptionalPowerAvailable:
                cell.titleLabel.text = [I18N key:@"power_outlet_title"];
                cell.switchButton.tag = PowerAvailableTag;
                [cell.switchButton setOn:self.submitInfo.powerOutlets];
                break;
            default:
                break;
        }
        return cell;
    }


    static NSString *CellIdentifier = @"TextFieldCell";

    TextFieldCell *cell = (TextFieldCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[TextFieldCell alloc] initTextFieldCellWithReuseIdentifier:CellIdentifier];
        cell.inputField.delegate = self;
    }

    cell.inputField.keyboardType = UIKeyboardTypeDefault;

    if (SectionRequiredInfo == indexPath.section)
    {
        switch (indexPath.row)
        {
            case RequiredNameRow:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_name_title"];
                cell.inputField.placeholder = [I18N key:@"input_name_placeholder"];
                cell.inputField.tag = NameFieldTag;
                cell.inputField.text = self.submitInfo.name;
                break;
            case RequiredAddressRow:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_address_title"];
                cell.inputField.placeholder = [I18N key:@"input_address_placeholder"];
                cell.inputField.tag = AddressFieldTag;
                break;
            default:
                break;
        }
    }
    else if (SectionOfOptionalInfo == indexPath.section)
    {
        switch (indexPath.row)
        {
            case OptionalPhoneNumberRow:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_phone_title"];
                cell.inputField.placeholder = [I18N key:@"input_phone_placeholder"];
                cell.inputField.tag = PhoneNumberFieldTag;
                cell.inputField.text = self.submitInfo.phone;
                cell.inputField.keyboardType = UIKeyboardTypePhonePad;
                break;
            case OptionalWebsiteUrl:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_website_url_title"];
                cell.inputField.placeholder = [I18N key:@"input_website_url_placeholder"];
                cell.inputField.tag = WebsiteUrlFieldTag;
                cell.inputField.text = self.submitInfo.websiteUrl;
                cell.inputField.keyboardType = UIKeyboardTypeURL;
                break;
            case OptionalHours:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_hours_title"];
                cell.inputField.placeholder = [I18N key:@"input_hours_placeholder"];
                cell.inputField.text = self.submitInfo.hours;
                cell.inputField.tag = HoursFiendTag;
                break;
            case OptionalDescription:
                cell.inputFieldTitleLabel.text = [I18N key:@"input_description_title"];
                cell.inputField.placeholder = [I18N key:@"input_description_placeholder"];
                cell.inputField.text = self.submitInfo.shopDescription;
                cell.inputField.tag = DescriptionFieldTag;
                break;
            default:
                break;
        }
    }
    return cell;
}

- (BOOL) isSwitchCell:(NSIndexPath *) indexPath
{
    return SectionOfOptionalInfo == indexPath.section &&
      (OptionalWifiAvailable == indexPath.row || OptionalPowerAvailable == indexPath.row);
}

#pragma UITableViewDelegate

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if ([self isSwitchCell:indexPath])
    {
        return [SwitchCell cellHeight];
    }
    return [TextFieldCell cellHeight];
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end