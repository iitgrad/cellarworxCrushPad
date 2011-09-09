//
//  CCActivity.h
//  Crush
//
//  Created by Kevin McQuown on 6/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLot.h"
#import "CCDatabaseObject.h"

@class CCClient;
@class CCWineStructure;
@class CCLot;
@interface CCActivity : CCDatabaseObject {
	float derivedTankGallons;
	float derivedToppingGallons;
	NSInteger derivedBarrelCount;
	float derivedVolume;
	BOOL inventoryAdjusted;
	float cost;
	float startingCost;
	float endingCost;
	NSString *endingWineState;
	NSMutableDictionary *costBreakOut;
	
	NSString *lot;
	NSDate *date;

	CCWineStructure *structure;
	CCLot *inLot;
	CCClient *client;

}
@property float startingCost;
@property float endingCost;
@property float derivedTankGallons;
@property float derivedToppingGallons;
@property NSInteger derivedBarrelCount;
@property float derivedVolume;
@property BOOL inventoryAdjusted;
@property float cost;
@property (nonatomic, retain) NSMutableDictionary *costBreakOut;
@property (readwrite,assign) CCLot *inLot;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *lot;
@property (nonatomic, retain) NSString *endingWineState;
@property (nonatomic, retain) CCClient *client;
@property (nonatomic, retain) CCWineStructure *structure;

-(id)initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)theLot;
-(id)initWithLot:(CCLot *)theLot;

@end
