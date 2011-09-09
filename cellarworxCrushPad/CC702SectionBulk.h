//
//  CC702SectionBulk.h
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC702Section.h"

@interface CC702SectionBulk : CC702Section {

	float totalFermented;
	float totalChangeInAlcohol;
	float totalLossesDueToEvaporation;
	float totalLossesDueToRacking;
	float totalLossesDueToDumping;
	float totalBottled;
	
	NSMutableArray *fermented;
	NSMutableArray *changeInAlcohol;
	NSMutableArray *lossesDueToEvaporation;
	NSMutableArray *lossesDueToRacking;
	NSMutableArray *lossesDueToDumping;
	NSMutableArray *bottled;
}
@property float totalFermented;
@property float totalChangeInAlcohol;
@property float totalLossesDueToEvaporation;
@property float totalLossesDueToRacking;
@property float totalLossesDueToDumping;
@property float totalBottled;

@property (retain) NSMutableArray *fermented;
@property (retain) NSMutableArray *changeInAlcohol;
@property (retain) NSMutableArray *lossesDueToEvaporation;
@property (retain) NSMutableArray *lossesDueToRacking;
@property (retain) NSMutableArray *lossesDueToDumping;
@property (retain) NSMutableArray *bottled;
@end
