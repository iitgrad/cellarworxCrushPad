//
//  CC702Event.h
//  Crush
//
//  Created by Kevin McQuown on 6/24/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CCWorkOrder.h"
#include "CCActivity.h"

@interface CC702Event : NSObject {
	
	NSString *activity;
	float startingVolume;
	float changeInVolume;
	float endingVolume;
	int previousState;
	int newState;
	CCActivity *workOrder;

}
@property (retain) NSString *activity;
@property float startingVolume;
@property float changeInVolume;
@property float endingVolume;
@property (retain) CCActivity *workOrder;
@property int previousState;
@property int newState;

-(id) initWithActivity:(NSString *)theActivity
		 previousState:(int)ps
			  newState:(int)ns
	 theStartingVolume:(float)sv  
		theChangeInVolume:(float)cv 
		 fromWorkOrder:(CCWorkOrder *)wo;

-(NSString *) description;

@end
