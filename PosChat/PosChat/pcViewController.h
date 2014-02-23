//
//  pcViewController.h
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface pcViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIStepper *expiryTime;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiryTimeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *autoupdate;
@property (strong, nonatomic) IBOutlet UITextField *number;
@property (strong, nonatomic) IBOutlet UIButton *gobutton;
@property (strong, nonatomic) IBOutlet UITextField *comment;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKAnnotationView *currentAnnotation;


- (IBAction)post:(id)sender;
- (IBAction)stepperChanged:(UIStepper*)sender;
- (IBAction)updateExpiryTime:(id)sender;
- (IBAction)cancelPost:(id)sender;
- (IBAction)contact:(id)sender;

@end