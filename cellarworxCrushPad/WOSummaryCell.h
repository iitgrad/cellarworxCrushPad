//
//  WOSummaryCell.h
//  CCC2
//
//  Created by Kevin McQuown on 5/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCActivity;
@interface WOSummaryCell : UITableViewCell {

	IBOutlet UILabel *woType;
	IBOutlet UILabel *woStartDate;
	IBOutlet UILabel *woEndDate;
	IBOutlet UITextView *woDescription;
	IBOutlet UILabel *staff;
	IBOutlet UILabel *gallons;
	IBOutlet UIImageView *icon;
    
    IBOutlet UILabel *lotNumber;
    IBOutlet UILabel *lotDescription;
	
	IBOutlet UILabel *leftLabel;
	IBOutlet UILabel *middleLabel;
	IBOutlet UILabel *rightLabel;
    IBOutlet UILabel *multiLotLabel;
	
	CCActivity *theActivity;
	
}

@property (nonatomic, retain) UILabel *woType;
@property (nonatomic, retain) UILabel *woStartDate;
@property (nonatomic, retain) UILabel *woEndDate;
@property (nonatomic, retain) UITextView *woDescription;
@property (nonatomic, retain) UILabel *staff;
@property (nonatomic, retain) UILabel *gallons;
@property (nonatomic, retain) UILabel *lotNumber;
@property (nonatomic, retain) UILabel *lotDescription;

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *middleLabel;
@property (nonatomic, retain) UILabel *rightLabel;
@property (nonatomic, retain) UILabel *multiLotLabel;
@property (nonatomic, retain) UIImageView *icon;

@property (nonatomic, assign) CCActivity *theActivity;

@end

