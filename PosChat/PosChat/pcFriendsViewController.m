//
//  pcFriendsViewController.m
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import "pcFriendsViewController.h"
#import "pcMapViewController.h"
#import "pcViewController.h"
#import <UIKit/UIKit.h>

@interface pcFriendsViewController ()

@end

@implementation pcFriendsViewController
@synthesize list;
@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"locateFriend"])
    {
        pcMapViewController *detailViewController = [segue destinationViewController];

        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];

        detailViewController.sourceid = [[list objectForKey:[NSString stringWithFormat:@"%d",myIndexPath.row]] objectForKey:@"0"];
    }
    else
    {
        pcViewController *detailViewController = [segue destinationViewController];
    }}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [standardDefaults stringForKey:@"number"];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://216.151.208.196/fetch.php?target=%@",userid]]];
    NSError *error=nil;
    list =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    UISwipeGestureRecognizer * swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
    [swipeRecognizer setDelegate:self];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [tableView addGestureRecognizer:swipeRecognizer];
}

- (void) onSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"pcCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *element = [list objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    int unixExpires = ([[element objectForKey:@"1"] intValue]+60*[[element objectForKey:@"2"] intValue]);
    NSDate *expires = [NSDate dateWithTimeIntervalSince1970:unixExpires];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, HH:mm"];

    UILabel *num = (UILabel *)[cell viewWithTag:100];
    UILabel *exp = (UILabel *)[cell viewWithTag:101];
    UILabel *note = (UILabel *)[cell viewWithTag:102];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:103];
    num.text = [element objectForKey:@"0"];
    if (unixExpires < [[NSDate date] timeIntervalSince1970])
    {
        cell.userInteractionEnabled = NO;
        imageView.image = [UIImage imageNamed:@"expired@2x.png"];
        exp.text = [NSString stringWithFormat:@"Expired\n%@",[format stringFromDate:expires]];

    }
    else
    {
        imageView.image = [UIImage imageNamed:@"active@2x.png"];
        exp.text = [NSString stringWithFormat:@"Expires\n%@",[format stringFromDate:expires]];
    }
    note.text = [element objectForKey:@"3"];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



@end
