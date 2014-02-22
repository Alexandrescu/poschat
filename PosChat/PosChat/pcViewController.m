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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:NO];
    [_mapView setPitchEnabled:NO];
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [_mapView setDelegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [_number resignFirstResponder];
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

- (IBAction)fetch:(id)sender
{
    NSString *uid=@"adsf";
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://216.151.208.196/fetch.php?user=%@",uid]]];
    NSError *error=nil;
    NSDictionary *response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if(!error)
    {
        if ([[response objectForKey:@"Valid"] intValue] == 1)
        {
            MKCoordinateSpan span;
            span.latitudeDelta = 0.002;
            span.longitudeDelta = 0.002;

            // define starting point for map
            CLLocationCoordinate2D start;
            start.latitude = [[response objectForKey:@"Lat"] floatValue];
            start.longitude = [[response objectForKey:@"Long"] floatValue];

            // create region, consisting of span and location
            MKCoordinateRegion region;
            region.span = span;
            region.center = start;
            
            // move the map to our location
            [_mapView setRegion:region animated:YES];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Location expired" message:@"Your friend's location is no longer available" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }
}

- (IBAction)post:(id)sender
{
    NSString *targetNum = _number.text;
    int expires = _expiryTime.value;
    [self cancelPost:nil];
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
