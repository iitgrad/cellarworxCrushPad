//
//  CCClient.m
//  Crush
//
//  Created by Kevin McQuown on 7/11/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCClient.h"


@implementation CCClient
@synthesize clientCode, clientID, clientName, staff;

-(id) initWithDictionary:(NSDictionary *)dict
{
	self=[super init];
	self.clientID=[dict objectForKey:@"CLIENTID"];
	self.clientCode=[dict objectForKey:@"CLIENTCODE"];
	self.clientName=[dict objectForKey:@"CLIENTNAME"];
	staff=NO;
	return self;	
}

-(id) initWithClientName:(NSString *)name clientCode:(NSString *)cc clientID:(NSString *)cID andStaff:(BOOL)isStaff
{
	self=[super init];
	self.clientID=cID;
	self.clientName=name;
	self.clientCode=cc;
	staff=isStaff;
	return self;
}

-(id) initWithClient:(CCClient *)theClient
{
	self=[super init];
	self.clientID=theClient.clientID;
	self.clientName=theClient.clientName;
	self.clientCode=theClient.clientCode;
	staff=theClient.staff;
	return self;
	
}
-(id) initWithNSUserDefaults
{
	return [self initWithClientName:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientname"]
						 clientCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"]
						   clientID:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"]
						andStaff:[[[NSUserDefaults standardUserDefaults] objectForKey:@"staff"]boolValue]];
}
+(id) defaultClient
{
	CCClient *theClient=[[[CCClient alloc] initWithNSUserDefaults] autorelease];
	return theClient;
}
-(NSString *)description
{
	return [NSString stringWithFormat:@"Name:%@ Code:%@ ID:%@",self.clientName,self.clientCode,self.clientID];
}
-(void) dealloc
{
	[clientID release];
	[clientCode release];
	[clientName release];
	[super dealloc];
}

@end
