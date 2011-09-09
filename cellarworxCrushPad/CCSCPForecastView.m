//
//  CCSCPForecastView.m
//  Crush
//
//  Created by Kevin McQuown on 9/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSCPForecastView.h"
#import "CCSCP.h"
#import "CrushHelper.h"
#import "QuartzCore/QuartzCore.h"

@implementation CCSCPForecastView
@synthesize whites;
@synthesize reds;
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake((frame.size.width-frame.size.width*.8)/2, 
												(frame.size.height-frame.size.height*.8)/2,
												frame.size.width*.8,
												frame.size.height*.8)]) {
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
			NSDateComponents *dc=[[NSDateComponents alloc] init];
			[dc setDay:1];
			NSArray *scps=[CrushHelper fetchOutstandingSCPs];
			whites=[[NSMutableDictionary alloc] init];
			reds=[[NSMutableDictionary alloc] init];
			NSInteger weekDayOfToday=[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
			
			for (CCSCP *s in scps) {
				NSDateComponents *components=[[NSCalendar currentCalendar] components:NSDayCalendarUnit 
																			 fromDate:[NSDate date] 
																			   toDate:s.date
																			  options:0];
				NSInteger scpWeekDay=[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:s.date] weekday];
				NSString *dayCount;
				if ([components day]==0) {
					if (scpWeekDay!=weekDayOfToday) {
						dayCount=[NSString stringWithFormat:@"%3d",1];
					}
					else {
						dayCount=[NSString stringWithFormat:@"%3d",0];
					}
					
				}
				else {
					dayCount=[NSString stringWithFormat:@"%3d",[components day]+1];
				}
				if ([s.type isEqualToString:@"WHITE"]) {
					float currentVal=[[whites objectForKey:dayCount] floatValue];
					currentVal+=[s.estTons floatValue];
					[whites setObject:[NSNumber numberWithFloat:currentVal] forKey:dayCount];
				}
				else {
					float currentVal=[[reds objectForKey:dayCount] floatValue];
					currentVal+=[s.estTons floatValue];
					[reds setObject:[NSNumber numberWithFloat:currentVal] forKey:dayCount];
				}
			}
			
			[self setBackgroundColor:[UIColor whiteColor]];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
				[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
				[delegate viewReadyForDisplay:self];
			});
		});
    }
    return self;
}

-(void) layoutSubviews
{
	[self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	for (UIView *v in self.subviews)
	{
		[v removeFromSuperview];
	}
	self.layer.cornerRadius=5;
	self.layer.shadowOpacity=.5;
	self.layer.shadowOffset=CGSizeMake(0, 10);
	self.layer.shadowRadius=10;
	CGPathRef shadowPath=[UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
	self.layer.shadowPath=shadowPath;
	
	float barWidth=self.frame.size.width/14;
	for (int i=0; i<14; i++) {
		float barHeight=[[reds objectForKey:[NSString stringWithFormat:@"%3d",i]] floatValue]/120*self.frame.size.height;
		UIView *bar=[[UIView alloc] initWithFrame:CGRectMake(i*barWidth, self.frame.size.height-barHeight, barWidth*.8, barHeight)];
		[bar setBackgroundColor:[CrushHelper backGroundTheme]];
		[self addSubview:bar];
		UILabel *redLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, bar.frame.size.width, bar.frame.size.height)];
		[redLabel setTextAlignment:UITextAlignmentCenter];
		[redLabel setTextColor:[UIColor whiteColor]];
		[redLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
		[redLabel setBackgroundColor:[UIColor clearColor]];
		[redLabel setText:[NSString stringWithFormat:@"%3d",[[reds objectForKey:[NSString stringWithFormat:@"%3d",i]] intValue]]];
		[bar addSubview:redLabel];
		[redLabel release];
		[bar release];
		float whiteBarHeight=[[whites objectForKey:[NSString stringWithFormat:@"%3d",i]] floatValue]/120*self.frame.size.height;
		UIView *bar2=[[UIView alloc] initWithFrame:CGRectMake(i*barWidth, self.frame.size.height-barHeight-whiteBarHeight, barWidth*.8, whiteBarHeight)];
		[bar2 setBackgroundColor:[UIColor yellowColor]];
		UILabel *whiteLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, bar2.frame.size.width, bar2.frame.size.height)];
		[whiteLabel setTextAlignment:UITextAlignmentCenter];
		[whiteLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
		[whiteLabel setTextColor:[UIColor blueColor]];
		[whiteLabel setBackgroundColor:[UIColor clearColor]];
		[whiteLabel setText:[NSString stringWithFormat:@"%3d",[[whites objectForKey:[NSString stringWithFormat:@"%3d",i]] intValue]]];
		[bar2 addSubview:whiteLabel];
		[whiteLabel release];
		
		[self addSubview:bar2];
		[bar2 release];
		
		UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width, 80)];
		[title setText:@"SCP Forecast Next 14 Days"];
		[title setBackgroundColor:[UIColor clearColor]];
		[title setTextColor:[CrushHelper backGroundTheme]];
		[title setFont:[UIFont systemFontOfSize:20]];
		[title setTextAlignment: UITextAlignmentCenter];
		[self addSubview:title];
		[title release];
	}
}


- (void)dealloc {
	[whites release];
	[reds release];
    [super dealloc];
}


@end
