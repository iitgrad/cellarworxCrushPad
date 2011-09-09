//
//  CCVineyardController.m
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCVineyardController.h"
#import "CCVineyard.h"

#define klatitudeDelta 0.4;
#define klongitudeDelta 0.4;
#define klatitudeDeltaZoom 0.003;
#define klongitudeDeltaZoom 0.004;

@implementation CCVineyardController
@synthesize map, searchBar, vineyard, vineyards, vineyardName, delegate, segmentedControl;

-(id) initWithVineyards:(NSArray *)vyds centerVineyard:(CCVineyard *)centerVineyard
{
	self=[super initWithNibName:@"CCVineyardController" bundle:nil];
	self.map=[[MKMapView alloc] init];
	self.title=vineyard.name;
	self.vineyard=[[CCVineyard alloc] initWithVineyard:centerVineyard];
	self.vineyards=[[NSArray alloc] initWithArray:vyds];
	
	NSArray *buttonNames=[[NSArray alloc] initWithObjects:@"Zoom",@"Normal",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
	[buttonNames release];
	[segmentedControl setEnabled:YES forSegmentAtIndex:1];
	segmentedControl.momentary=NO;
	segmentedControl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex=1;
	segmentedControl.enabled=NO;
	[segmentedControl addTarget:self action:@selector(segmentTouched:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView=segmentedControl;
	
	return self;
}

-(void) segmentTouched:(id) sender
{
	MKCoordinateRegion region;
	region.center.latitude=self.vineyard.coordinate.latitude;
	region.center.longitude=self.vineyard.coordinate.longitude;
	if (segmentedControl.selectedSegmentIndex==1)
	{
		region.span.latitudeDelta=klatitudeDelta;
		region.span.longitudeDelta=klongitudeDelta;		
	}
	else {
		region.span.latitudeDelta=klatitudeDeltaZoom;
		region.span.longitudeDelta=klongitudeDeltaZoom;		
	}	
	[map setRegion:region animated:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
	self.map.mapType=MKMapTypeStandard;

	for (CCVineyard *v in vineyards)
	{
		[map addAnnotation:v];
	}
	
	self.vineyardName.text=self.vineyard.name;
	
	MKCoordinateRegion region;
	region.center.latitude=self.vineyard.coordinate.latitude;
	region.center.longitude=self.vineyard.coordinate.longitude;
	region.span.latitudeDelta=klatitudeDelta;
	region.span.longitudeDelta=klongitudeDelta;			

	segmentedControl.enabled=YES;
	
	[map setRegion:region animated:YES];
	
	UIBarButtonItem	*mapTypeButton = [[UIBarButtonItem alloc] initWithTitle:@"Hybrid" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMapType)];
	self.navigationItem.rightBarButtonItem=mapTypeButton;
}

-(void)toggleMapType
{
	if (self.map.mapType==MKMapTypeStandard)
	{
		self.map.mapType=MKMapTypeHybrid;
	}
	else {
		self.map.mapType=MKMapTypeStandard;
	}

}
-(void)setLocation
{
	[self.navigationController popViewControllerAnimated:YES];
	[self.delegate setNewLocation:map.centerCoordinate];
}
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSLog(@"%@",@"Found Placemark");
}
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"%@",@"Reverse Geocoder failed with Error");
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSLog(@"%@",@"annotation view asked for");
	
	MKPinAnnotationView *view=(MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:@"Annotations"];
	if (view!=nil)
	{
		return view;
	}

	view=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotations"] autorelease];		
	view.canShowCallout=YES;
	view.animatesDrop=YES;
	return view;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	MKCoordinateRegion reg=[map region];
	
	NSLog(@"Lat: %9.6f  Long: %9.6f (%7.4f,%7.4f)",reg.center.latitude,reg.center.longitude, reg.span.latitudeDelta, reg.span.longitudeDelta);	
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [map release];
    [searchBar release];
    [vineyard release];
    [vineyards release];
    [vineyardName release];
    [segmentedControl release];
    [super dealloc];
}


@end
