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
    _mapView.showsUserLocation = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetch:(id)sender
{
    NSString *str=@"http://216.151.208.196/fetch.php?user=389294hys89a";
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    NSDictionary *response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if(!error)
    {
        if ([[response objectForKey:@"valid"] intValue] == 1)
        {
            MKCoordinateSpan span;
            span.latitudeDelta = 0.002;
            span.longitudeDelta = 0.002;

            // define starting point for map
            CLLocationCoordinate2D start;
            start.latitude = [[response objectForKey:@"lat"] floatValue];
            start.longitude = [[response objectForKey:@"long"] floatValue];

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
    
}
@end
