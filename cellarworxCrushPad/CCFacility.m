//
//  CCFacility.m
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CCFacility.h"
#import "CrushHelper.h"


@implementation CCFacility

@synthesize dbid;
@synthesize name;
@synthesize coordinate;
@synthesize bonded;
@synthesize bondNumber;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize phone1;
@synthesize phone2;

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    
    self.name=[CrushHelper nillIfNull:[dictionary objectForKey:@"NAME"]];
    self.bondNumber=[CrushHelper nillIfNull:[dictionary objectForKey:@"BONDNUMBER"]];
    self.address1=[CrushHelper nillIfNull:[dictionary objectForKey:@"ADDRESS1"]];
    self.address2=[CrushHelper nillIfNull:[dictionary objectForKey:@"ADDRESS2"]];
    self.city=[CrushHelper nillIfNull:[dictionary objectForKey:@"CITY"]];
    self.state=[CrushHelper nillIfNull:[dictionary objectForKey:@"STATE"]];
    self.zip=[CrushHelper nillIfNull:[dictionary objectForKey:@"ZIP"]];
    phone1=nil;
    phone2=nil;
    
    dbid=[[CrushHelper nillIfNull:[dictionary objectForKey:@"LOCATION_ID"]] intValue];
    CLLocationDegrees latitude=[[CrushHelper nillIfNull:[dictionary objectForKey:@"LAT"]] floatValue];
    CLLocationDegrees longitude=[[CrushHelper nillIfNull:[dictionary objectForKey:@"LONG"]] floatValue];
    
    coordinate.latitude=latitude;
    coordinate.longitude=longitude;
    
    return self;
}
-(void) dealloc
{
    [name release];
    [bondNumber release];
    [address1 release];
    [address2 release];
    [city release];
    [state release];
    [zip release];
    [phone1 release];
    [phone2 release];
    [super dealloc];
}
@end
