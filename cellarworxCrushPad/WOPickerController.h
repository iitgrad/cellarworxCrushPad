//
//  WOPickerController.h
//  Crush
//
//  Created by Kevin McQuown on 7/28/10.
//  Copyright (c) 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWT.h"
@protocol WOPickerControllerDelegate

-(void) addWeighTag:(CCWT *)wt;
-(void) removeWeighTag:(CCWT *)wt;

@end

@class CCSCP;
@interface WOPickerController : UITableViewController {
    
    NSArray *allWorkOrders;
	NSMutableSet *checkedWorkOrders;
	CCSCP *scp;
	id <WOPickerControllerDelegate> delegate;
}
@property (nonatomic, retain) NSArray *allWorkOrders;
@property (nonatomic, retain) NSMutableSet *checkedWorkOrders;
@property (nonatomic, retain) CCSCP *scp;
@property (nonatomic, assign) id <WOPickerControllerDelegate> delegate;


- (id)initWithStyle:(UITableViewStyle)style allWorkOrders:(NSArray *)awo checkedWorkOrders:(NSArray *)cwo forSCP:(CCSCP *)theSCP;

@end