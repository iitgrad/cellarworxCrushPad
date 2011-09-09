//
//  CCClient.h
//  Crush
//
//  Created by Kevin McQuown on 7/11/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCClient : NSObject {
	
	NSString *clientCode;
	NSString *clientID;
	NSString *clientName;
	BOOL staff;
}
@property (nonatomic, retain) NSString *clientCode;
@property (nonatomic, retain) NSString *clientID;
@property (nonatomic, retain) NSString *clientName;
@property BOOL staff;

-(id) initWithClientName:(NSString *)name clientCode:(NSString *)cc clientID:(NSString *)cID andStaff:(BOOL)isStaff;
-(id) initWithClient:(CCClient *)theClient;
-(id) initWithDictionary:(NSDictionary *)dict;

-(id) initWithNSUserDefaults;

+(id) defaultClient;

-(NSString *)description;

@end
