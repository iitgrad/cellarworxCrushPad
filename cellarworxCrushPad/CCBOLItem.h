//
//  CCBOLItem.h
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCDatabaseObject.h"
@class CCLot;
@class CCBOL;
@interface CCBOLItem : CCDatabaseObject {

	NSString *alcoholLevel;
	NSString *type;
	float gallons;
	float gallonsPerCase;
	float bottlesPerCase;
	NSInteger caseCount;
	float palletCount;
	NSInteger casesPerPallet;
	NSInteger partialPalletCount;
	NSString *qtyType;
	CCLot *lot;
	NSString *lotString;
	CCBOL *bol;
	
}
@property (retain) NSString *alcoholLevel;
@property (retain) NSString *type;
@property float gallons;
@property float gallonsPerCase;
@property NSInteger caseCount;
@property NSInteger partialPalletCount;
@property (retain) NSString *qtyType;
@property (nonatomic, assign) CCLot *lot;
@property (nonatomic, retain) NSString *lotString;
@property (nonatomic, assign) CCBOL *bol;
@property float palletCount;
@property float bottlesPerCase;
@property NSInteger casesPerPallet;

-(id) initWithBOL:(CCBOL *)theBOL;
-(id) initWithDictionary:(NSDictionary *)dictionary forBOL:(CCBOL *)theBOL;

-(NSString *)save;
-(void)delete;

@end
