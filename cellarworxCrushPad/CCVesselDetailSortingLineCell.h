//
//  CCTankDetailSortingLineCell.h
//  Crush
//
//  Created by Kevin McQuown on 7/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCVesselDetailSortingLineCell : UITableViewCell {

	IBOutlet UILabel *vesselNameLabel;
	IBOutlet UILabel *so2Label;
	IBOutlet UILabel *binCountLabel;
	IBOutlet UILabel *progessStatusLabel;
	
}
@property (nonatomic, retain) IBOutlet UILabel *vesselNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *so2Label;
@property (nonatomic, retain) IBOutlet UILabel *binCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *progessStatusLabel;

@end
