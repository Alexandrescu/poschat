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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:[[alertView textFieldAtIndex:0] text] forKey:@"number"];
    [standardDefaults synchronize];
}

- (void)request_number
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Please enter you phone number" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardDefaults stringForKey:@"number"] == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Please enter you phone number" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    standardDefaults = [NSUserDefaults standardUserDefaults];
    userid = [standardDefaults stringForKey:@"number"];
	// Do any additional setup after loading the view, typically from a nib.
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:NO];
    [_mapView setPitchEnabled:NO];
    [_mapView setShowsUserLocation:YES];

    [_mapView setDelegate:self];
    [self updateExpiryTime:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [gobutton setHidden:YES];
    [self.view addGestureRecognizer:tap];
    _comment.inputView = nil;

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentAnnotation = [mapView viewForAnnotation:userLocation];
    currentAnnotation.canShowCallout = NO;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [gobutton sendActionsForControlEvents: UIControlEventTouchUpInside];
    [mapView deselectAnnotation:[[mapView selectedAnnotations] objectAtIndex:0] animated:NO];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [manager stopUpdatingLocation];

}
- (void)dismissKeyboard {
    [_number resignFirstResponder];
    [_comment resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.number.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)post:(id)sender
{
    int expires = _expiryTime.value;
    NSLog(@"%@,%@",_number.text,_comment.text);
    NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://216.151.208.196/post.php?target=%@&source=%@&lat=%f&lon=%f&expiry=%d&comment=%@",_number.text,userid,locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,expires,_comment.text]]];
    [self cancelPost:nil];
    /*NSArray *success = [NSArray arrayWithObject:result];
    if([[success objectAtIndex:0] intValue] == 1)
        [self cancelPost:nil];
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }*/
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
    components.minute = [_expiryTime value];
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
