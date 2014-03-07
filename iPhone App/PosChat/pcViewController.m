//
//  pcViewController.m
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import "pcViewController.h"

@interface pcViewController ()

@end

@implementation pcViewController
@synthesize userid;
@synthesize locationManager;
@synthesize gobutton;
@synthesize currentAnnotation;
@synthesize comment;
@synthesize expiryTime;
@synthesize mover;
@synthesize mapView;
@synthesize placeholder;


- (IBAction)contact:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    CFStringRef addressBookMobile = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *targetNumber = (__bridge NSString*) ABMultiValueCopyValueAtIndex(addressBookMobile, ABMultiValueGetIndexForIdentifier(addressBookMobile, identifier));
    self.number.text = targetNumber;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

- (void)request_number
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Please enter you phone number" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    alert.tag = 11;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"number"];
	// Do any additional setup after loading the view, typically from a nib.
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:NO];
    [mapView setPitchEnabled:NO];
    [mapView setShowsUserLocation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [mapView setDelegate:self];
    [self updateExpiryTime:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [gobutton setHidden:YES];
    [self.view addGestureRecognizer:tap];
    comment.inputView = nil;

}

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3f animations:^ {
        mover.frame = CGRectMake(0, -120, 320, 480);
        placeholder.alpha = 0.0f;
    }];

}

- (void)mapView:(MKMapView *)sourcemapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentAnnotation = [sourcemapView viewForAnnotation:userLocation];
    currentAnnotation.canShowCallout = NO;
    
}

- (void)mapView:(MKMapView *)sourcemapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [gobutton sendActionsForControlEvents: UIControlEventTouchUpInside];
    [sourcemapView deselectAnnotation:[[sourcemapView selectedAnnotations] objectAtIndex:0] animated:NO];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [mapView setUserTrackingMode:MKUserTrackingModeNone];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [manager stopUpdatingLocation];

}
- (void)dismissKeyboard {
    [_number resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^ {
        mover.frame = CGRectMake(0, 0, 320, 480);
    }];
    if([comment.text isEqualToString:@""])
        placeholder.alpha = 1.0f;
    [comment resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.number.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)post:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"http://216.151.208.196/post.php?target=%@&source=%@&lat=%f&lon=%f&expiry=%f&comment=%@",_number.text,userid,locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,expiryTime.value,[comment.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (!data)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A connection to the server could not be establish. Check your internet connection" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSDictionary *success = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if([[success objectForKey:@"success"] intValue] == 1)
            [self cancelPost:nil];
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (IBAction)stepperChanged:(UIStepper*)sender
{
    int value = (int) [sender value];
    if (value == 1)
        _minutesLabel.text = [NSString stringWithFormat:@"%i minute",value];
    else
        _minutesLabel.text = [NSString stringWithFormat:@"%i minutes",value];
    [self updateExpiryTime:nil];

}
- (IBAction)updateExpiryTime:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.minute = [expiryTime value];
    components.hour = 0;
    NSDate *date = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *dateString = [format stringFromDate:date];
    _expiryTimeLabel.text = [NSString stringWithFormat:@"expires %@",dateString];
}

- (IBAction)cancelPost:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
