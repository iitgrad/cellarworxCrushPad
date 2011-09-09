//
//  CCSCP.h
//  Crush
//
//  Created by Kevin McQuown on 6/21/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWorkOrder.h"

typedef enum {
	CCTankPositionTop = 0,
	CCTankPositionBottom
} CCTankPositions;

@class CCLot;
@class CCAssetReservation;
@class CCVineyard;

@interface CCSCP : CCWorkOrder {


	NSString *estTons;
	NSString *varietal;
	NSString *varietalType;
	NSString *appellation;
	NSString *clone;
	NSString *regionCode;
	NSString *specialInstructions;
	NSString *crushing;
	NSNumber *daysInTank;
	NSString *colorCoding;
	NSString *type;
	
	UIColor *color1;
	UIColor *color2;
	float actualTons;
	int	processingSpeed;  // Tons per hour
	
	CCVineyard *vineyard;
	
	BOOL handSorting;
	BOOL onTable;
	
	NSInteger sulphurPPM;
	NSNumber *wholeClusterPercentage;
	CCTankPositions tankPosition;
	
	NSMutableArray *weighTags;
	
}
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *daysInTank;
@property (nonatomic, retain) NSString *estTons;
@property (nonatomic, retain) CCVineyard *vineyard;
@property (nonatomic, retain) NSString *varietal;
@property (nonatomic, retain) NSString *varietalType;
@property (nonatomic, retain) NSString *appellation;
@property (nonatomic, retain) NSString *clone;
@property (nonatomic, retain) NSString *regionCode;
@property (nonatomic, retain) NSString *specialInstructions;
@property (nonatomic, retain) NSString *crushing;
@property (nonatomic, retain) NSString *colorCoding;
@property (nonatomic, retain) NSMutableArray *weighTags;

@property NSInteger sulphurPPM;

@property (nonatomic, retain) UIColor *color1;
@property (nonatomic, retain) UIColor *color2;
@property float actualTons;
@property int processingSpeed;

@property BOOL handSorting;
@property BOOL onTable;
@property CCTankPositions tankPosition;

@property (nonatomic, retain) NSNumber *wholeClusterPercentage;

-(CCSCP *)initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot;
-(id)initWithLot:(CCLot *)forLot;
-(float)averageBinWeight;
-(void) saveWithPushNotification:(BOOL)sendPushNotification;
-(NSString *) description;

@end
