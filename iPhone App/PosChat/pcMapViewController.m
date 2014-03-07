//
//  pcMapViewController.m
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import "pcMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface pcMapViewController ()

@end

@implementation pcMapViewController
@synthesize sourceid;
@synthesize entryid;
@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([sourceid isEqualToString:@"01604633272"])
        self.title = @"Andrei A";
    else
        self.title = self.sourceid;
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://216.151.208.196/locate.php?source=%@&id=%@",sourceid,entryid]]];
    NSError *error=nil;
    NSArray *response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    double lat = [[response objectAtIndex:0] doubleValue];
    double lon = [[response objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D track;
    track.latitude = lat;
    track.longitude = lon;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = track;

    MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
    newAnnotation.coordinate = track;
    ;
    newAnnotation.title = [response objectAtIndex:2];
    //newAnnotation.subtitle = [response objectAtIndex:2];
    [self.map setRegion:region animated:TRUE];
    [self.map regionThatFits:region];

	// Do any additional setup after loading the view.
    [map addAnnotations:[NSArray arrayWithObjects:newAnnotation, nil]];
    [map selectAnnotation:newAnnotation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
