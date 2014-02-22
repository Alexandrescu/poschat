//
//  pcLeftSegue.m
//  PosChat
//
//  Created by Robert Bastian on 22/02/2014.
//  Copyright (c) 2014 Robert Bastian. All rights reserved.
//

#import "pcLeftSegue.h"

@implementation pcLeftSegue

-(void)perform
{

    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];

    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom

    [destinationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController presentViewController:destinationController animated:NO completion:nil];
}

@end
