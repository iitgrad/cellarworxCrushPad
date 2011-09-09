//
//  CCFermProtocol.h
//  Crush
//
//  Created by Kevin McQuown on 8/3/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCAsset;
typedef enum
{
	Morning=0,
	Noon=1,
	Evening=2
} timeSlots;
typedef enum
{
	None=0,
	Light=1,
	Medium=2,
	Heavy=3
} punchDownStrengths;
typedef enum
{
	pumpOver=0,
	punchDown=1
} activity;

@interface CCFermProtocol : NSObject {
	
	NSString *lotNumber;
	CCAsset *asset;
	activity morningActivity;
	activity noonActivity;
	activity eveningActivity;
	punchDownStrengths morningStrength;
	punchDownStrengths noonStrength;
 	punchDownStrengths eveningStrength;
	
	NSUInteger morningPODuration;
	NSUInteger noonPODuration;
	NSUInteger eveningPODuration;
	
	BOOL dryice;
	BOOL active;

}
@property (nonatomic, retain) NSString *lotNumber;
@property (nonatomic) NSUInteger morningPODuration;
@property (nonatomic) NSUInteger noonPODuration;
@property (nonatomic) NSUInteger eveningPODuration;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL dryice;
@property (nonatomic, retain) CCAsset *asset;
@property (nonatomic) punchDownStrengths morningStrength;
@property (nonatomic) activity morningActivity;
@property (nonatomic) punchDownStrengths noonStrength;
@property (nonatomic) activity noonActivity;
@property (nonatomic) punchDownStrengths eveningStrength;
@property (nonatomic) activity eveningActivity;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSString *) description:(timeSlots)timeSlot;
-(NSString *)save;

@end
