//
//  CCTankListController.h
//  Crush
//
//  Created by Kevin McQuown on 6/30/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCWorkOrder.h"
#import "CCTankPickerController.h"
#import "CCTankLoadingController.h"

@interface CCTankListController : UITableViewController  <UITableViewDelegate, UITableViewDataSource, TankPickerControllerDelegate, CCTankLoadingControllerDelegate> {

	CCWorkOrder *wo;
	
}

@property (nonatomic, retain) CCWorkOrder *wo;

-(id) initWithAssetReservations:(NSArray *)reservations forWO:(CCWorkOrder *)theWO;

@end
