//
//  RootViewController.h
//  Crush
//
//  Created by Kevin McQuown on 8/6/10.
//  Copyright Deck 5 Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
