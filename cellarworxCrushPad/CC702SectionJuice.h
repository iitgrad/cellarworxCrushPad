//
//  CC702SectionJuice.h
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CC702Section.h"

@interface CC702SectionJuice : CC702Section {
	
	float totalTonsAdded;
	float totalTonsFermented;
	float totalInventoryAdjustments;
	NSMutableArray *tonsAdded;
	NSMutableArray *tonsFermented;
	NSMutableArray *inventoryAdjustments;

}
@property (retain) NSMutableArray *tonsAdded;
@property (retain) NSMutableArray *tonsFermented;
@property (retain) NSMutableArray *inventoryAdjustments;
@property float totalTonsAdded;
@property float totalTonsFermented;
@property float totalInventoryAdjustments;

@end
