//
//  pcFriendsViewController.h
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pcFriendsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property (strong,nonatomic) NSArray *list;
-(void)refresh;
-(IBAction)dismiss:(id)sender;
@end
