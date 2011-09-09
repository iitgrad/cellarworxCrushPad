//
//  CCVineyard.h
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CCVineyard : NSObject <MKAnnotation> {
	
	NSString *name;
	CLLocationCoordinate2D coordinate;
	
	NSString *dbid;
	NSString *clientid;
	NSString *gateCode;
	NSString *appellation;
	NSString *region;
	
	
	BOOL organic;
	BOOL biodynamic;
	
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *clientid;
@property (nonatomic, retain) NSString *dbid;
@property (nonatomic, retain) NSString *gateCode;
@property (nonatomic, retain) NSString *appellation;
@property (nonatomic, retain) NSString *region;

@property (nonatomic) BOOL organic;
@property (nonatomic) BOOL biodynamic;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithName:(NSString *)n;
-(id) initWithDictionary:(NSDictionary *)dict;
-(id) initWithVineyard:(CCVineyard *)v;
-(void) setNewLocation:(CLLocationCoordinate2D)loc;

-(NSString *)save;
-(NSString *)remove;

@end
