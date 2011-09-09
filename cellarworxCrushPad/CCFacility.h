//
//  CCFacility.h
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CCFacility : NSObject {

    int dbid;
    NSString *name;
    CLLocationCoordinate2D coordinate;

    BOOL bonded;
    NSString *bondNumber;
    NSString *address1;
    NSString *address2;
    NSString *city;
    NSString *state;
    NSString *zip;
    NSString *phone1;
    NSString *phone2;    
}

@property int dbid;
@property (retain) NSString *name;
@property CLLocationCoordinate2D coordinate;
@property BOOL bonded;
@property (retain) NSString *bondNumber;
@property (retain) NSString *address1;
@property (retain) NSString *address2;
@property (retain) NSString *city;
@property (retain) NSString *state;
@property (retain) NSString *zip;
@property (retain) NSString *phone1;
@property (retain) NSString *phone2;    

-(id) initWithDictionary:(NSDictionary *)dictionary;

@end
