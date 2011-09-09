//
//  CCFermProtocol.m
//  Crush
//
//  Created by Kevin McQuown on 8/3/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCFermProtocol.h"
#import "CCAsset.h"
#import "CrushHelper.h"

@implementation CCFermProtocol
@synthesize lotNumber;
@synthesize morningPODuration, noonPODuration, eveningPODuration;
@synthesize asset;
@synthesize morningStrength, morningActivity;
@synthesize noonStrength, noonActivity;
@synthesize eveningStrength, eveningActivity;
@synthesize active;
@synthesize dryice;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
	NSDictionary *strengthsEnum=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:None],@"NONE",
								 [NSNumber numberWithInt:Light],@"LIGHT",
								 [NSNumber numberWithInt:Medium],@"MEDIUM",
								 [NSNumber numberWithInt:Heavy],@"HEAVY",nil];
	
	active=NO;
	self.lotNumber=[[NSString alloc] initWithString:[dictionary objectForKey:@"LOTNUMBER"]];
	self.asset=[[CCAsset alloc] initWithDictionary:[dictionary objectForKey:@"asset"]];
	self.morningPODuration=0;
	self.noonPODuration=0;
	self.eveningPODuration=0;
	self.dryice=YES;
	
	if ([[[dictionary objectForKey:@"fermprot"] objectForKey:@"status"] isEqualToString:@"ACTIVE"])
	{
		NSDictionary *dict=[[dictionary objectForKey:@"fermprot"] objectForKey:@"data"];
		
		if ([[dict objectForKey:@"DRYICE"] isEqualToString:@"YES"])
			self.dryice=YES;
		else 
			self.dryice=NO;
		
		if ([[dict objectForKey:@"POAM"] intValue] == 0)
		{
			morningActivity=punchDown;
			morningStrength=(punchDownStrengths)[[strengthsEnum objectForKey:[dict objectForKey:@"PDAM"]]intValue];
			active=YES;
		}
		else {
			morningPODuration=[[dict objectForKey:@"POAM"] intValue];
			if (morningPODuration>0)
			{
				morningActivity=pumpOver;
				active=YES;				
			}
		}
		if ([[dict objectForKey:@"PONOON"] intValue] == 0)
		{
			noonActivity=punchDown;
			noonStrength=(punchDownStrengths)[[strengthsEnum objectForKey:[dict objectForKey:@"PDNOON"]]intValue];
			active=YES;
		}
		else {
			noonPODuration=[[dict objectForKey:@"PONOON"] intValue];
			if (noonPODuration>0)
			{
				noonActivity=pumpOver;
				active=YES;				
			}
		}
		if ([[dict objectForKey:@"POPM"] intValue] == 0)
		{
			eveningActivity=punchDown;
			eveningStrength=(punchDownStrengths)[[strengthsEnum objectForKey:[dict objectForKey:@"PDPM"]]intValue];
			active=YES;
		}
		else {
			eveningPODuration=[[dict objectForKey:@"POPM"] intValue];
			if (eveningPODuration>0)
			{
				eveningActivity=pumpOver;
				active=YES;				
			}
		}
	}
	[strengthsEnum release];
	return self;
}

-(NSString *)description:(timeSlots)timeSlot
{
	
	NSArray *strengthsDescription=[[[NSArray alloc] initWithObjects: @"None",@"Light",@"Medium",@"Heavy",nil] autorelease];
	
	if (!active) return [NSString stringWithString:@"Not Active"];
	switch (timeSlot) {
		case Morning:
		{
			if (self.morningActivity==pumpOver & self.morningPODuration>0)
			{
				NSString *desc=[NSString stringWithFormat:@"Pump Over - %d",self.morningPODuration];
				return desc;
			}
			else {
				if (morningStrength==None)
				{
					NSString *desc=[NSString stringWithFormat:@"None"];
					return desc;
				}
				else {
					NSString *desc=[NSString stringWithFormat:@"Punch Down - %@", [strengthsDescription objectAtIndex:morningStrength]] ;
					return desc;
				}
			}

		}
			break;
		case Noon:
		{
			if (self.noonActivity==pumpOver & self.noonPODuration>0)
			{
				NSString *desc=[NSString stringWithFormat:@"Pump Over - %d",self.noonPODuration];
				return desc;
			}
			else {
				if (noonStrength==None)
				{
					NSString *desc=[NSString stringWithFormat:@"None"];
					return desc;
				}
				else {
					NSString *desc=[NSString stringWithFormat:@"Punch Down - %@", [strengthsDescription objectAtIndex:noonStrength]] ;
					return desc;
				}
			}
			
		}
			break;
		case Evening:
		{
			if (self.eveningActivity==pumpOver & self.eveningPODuration>0)
			{
				NSString *desc=[NSString stringWithFormat:@"Pump Over - %d",self.eveningPODuration];
				return desc;
			}
			else {
				if (eveningStrength==None)
				{
					NSString *desc=[NSString stringWithFormat:@"None"];
					return desc;
				}
				else {
					NSString *desc=[NSString stringWithFormat:@"Punch Down - %@", [strengthsDescription objectAtIndex:eveningStrength]] ;
					return desc;
				}
			}
		}
			break;
		default:
			break;
	}
	return @"";
}
-(NSString *)save
{	
	NSArray *strength=[[NSArray alloc] initWithObjects:@"NONE",@"LIGHT",@"MEDIUM",@"HEAVY",nil];
	NSString *ampod=[NSString stringWithFormat:@"%d",morningPODuration];
	NSString *noonpod=[NSString stringWithFormat:@"%d",noonPODuration];
	NSString *pmpod=[NSString stringWithFormat:@"%d",eveningPODuration];

	NSString *di;
	if (dryice) {
		di=[NSString stringWithString:@"YES"];
	}
	else {
		di=[NSString stringWithString:@"NO"];
	}
	
	NSString *status=nil;
	if (active) {
		status=[NSString stringWithString:@"ACTIVE"];
	}
	else {
		status=[NSString stringWithString:@"CLOSED"];
	}

	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						self.lotNumber,@"LOTNUMBER",
						self.asset.name,@"VESSELNAME",
						status,@"STATUS",
						di,@"DRYICE",
						[strength objectAtIndex:morningStrength],@"PDAM",
						[strength objectAtIndex:noonStrength],@"PDNOON",
						[strength objectAtIndex:eveningStrength],@"PDPM",
						ampod,@"POAM",
						noonpod,@"PONOON",
						pmpod,@"POPM",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_fermprotocol"];
	NSLog(@"%@",[result description]);
	[dict release];
	[strength release];
	return [result description];
}

-(void) dealloc
{
    
    [lotNumber release];
    [asset release];
    [super dealloc];
}

@end
