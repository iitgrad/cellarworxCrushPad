//
//  CCWT.h
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWorkOrder.h"
#import "CCSCP.h"
#import "CCActivity.h"

@class CCLot;
@class CCVineyard;
@class CCSCP;

@interface CCWT : CCActivity {
	
	CCVineyard *vineyard;
	NSString *varietal;
	NSString *appellation;
	NSString *clone;
	
	NSString *regionCode;
	NSString *truckLicense;
	NSString *trailerLicense;
	NSString *clientname;
	NSString *clientcode;
	NSString *clientid;
	
	NSMutableArray *weights;
	NSInteger totalGross;
	NSInteger totalTare;
	NSInteger totalNetWeight;
	NSInteger totalBinCount;
	NSInteger theID;
	NSInteger tagID;
	
	float gallons;
	NSInteger number;
	CCSCP *createdFromSCP;	
	NSString *createdFromSCPID;
}

@property (nonatomic, retain) CCVineyard *vineyard;
@property (nonatomic, retain) NSString *varietal;
@property (nonatomic, retain) NSString *appellation;
@property (nonatomic, retain) NSString *clone;

@property (nonatomic, retain) NSString *regionCode;
@property (nonatomic, retain) NSString *truckLicense;
@property (nonatomic, retain) NSString *trailerLicense;
@property (nonatomic, retain) NSString *clientname;
@property (nonatomic, retain) NSString *clientcode;
@property (nonatomic, retain) NSString *clientid;
@property NSInteger number;
@property NSInteger tagID;
@property NSInteger theID;

@property (nonatomic, retain) NSMutableArray *weights;

@property NSInteger totalNetWeight;
@property NSInteger totalBinCount;
@property NSInteger totalGross;
@property NSInteger totalTare;
@property float gallons;
@property (nonatomic, assign) CCSCP *createdFromSCP;
@property (nonatomic, retain) NSString *createdFromSCPID;


-(id) initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot;
-(NSString *)dateString;
-(id)initWithSCP:(CCSCP *)fromSCP withLot:(CCLot *)parentLot;
-(id)initWithLot:(CCLot *)parentLot;
-(void) save;
-(BOOL) match:(NSString *)s;
-(void)delete;

-(NSString *)description;


@end
