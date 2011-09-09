//
//  CCVineyardController.h
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class CCVineyard;

@protocol CCVineyardControllerDelegate;

@interface CCVineyardController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, MKReverseGeocoderDelegate>{

	IBOutlet MKMapView *map;
	IBOutlet UISearchBar *searchBar;
	CCVineyard *vineyard;
	NSArray *vineyards;
	IBOutlet UILabel *vineyardName;
	id<CCVineyardControllerDelegate> delegate;
	UISegmentedControl *segmentedControl;
}
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) CCVineyard *vineyard;
@property (nonatomic, retain) NSArray *vineyards;
@property (nonatomic, retain) IBOutlet UILabel *vineyardName;
@property (nonatomic, assign) id<CCVineyardControllerDelegate> delegate;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;

-(id) initWithVineyards:(NSArray *)vyds centerVineyard:(CCVineyard *)centerVineyard;
-(IBAction) setLocation;

@end

@protocol CCVineyardControllerDelegate

-(void)setNewLocation:(CLLocationCoordinate2D)loc;

@end

