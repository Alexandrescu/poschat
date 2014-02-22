//
//  pcFriendsViewController.m
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import "pcFriendsViewController.h"
#import "pcMapViewController.h"
@interface pcFriendsViewController ()

@end

@implementation pcFriendsViewController

@synthesize history = _history;

- (NSMutableArray*)history
{
    if(!_history)
        _history = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"history" ofType:@"plist"]];
    return _history;
}

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

        detailViewController.number = [[_history objectAtIndex:myIndexPath.row] valueForKey:@"number"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
    _history = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObject:@"9385403" forKey:@"number"], nil];
    [[_history objectAtIndex:0] setObject:@"2014-02-22T23:26:18Z" forKey:@"expires"];
    [_history writeToFile:@"history.plist" atomically: YES];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"pcCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDate *expired = [[self.history objectAtIndex:indexPath.row] valueForKey:@"expires"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yy, HH:mm"];

    cell.textLabel.text = [[self.history objectAtIndex:indexPath.row] valueForKey:@"number"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Expired %@",[format stringFromDate:expired]];
    if ([expired timeIntervalSinceNow] < 0.0)
    {
        cell.userInteractionEnabled = NO;
        cell.imageView.image = [UIImage imageNamed:@"expired"];
    }
    else
        cell.imageView.image = [UIImage imageNamed:@"map-pin-red-hi.png"];

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
