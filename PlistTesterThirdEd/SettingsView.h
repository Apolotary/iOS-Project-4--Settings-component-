//
//  SettingsView.h
//  PlistTesterThirdEd
//
//  Created by user on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterAdjustableSet.h"

@interface SettingsView : UIViewController 
{
    IBOutlet UISwitch * circleSwitch;
    IBOutlet UISlider * amountSlider;
    IBOutlet UISlider * velocitySlider;
    IBOutlet UILabel  * amountLabel;
    IBOutlet UILabel  * velocityLabel;
    IBOutlet UIImageView * greenCircle;
    IBOutlet UIImageView * redCircle;
    
    ParameterAdjustableSet * setter;
    
    int amount;
    float fader;
    BOOL circle;
}

@property (nonatomic, retain) UIImageView * greenCircle;
@property (nonatomic, retain) UIImageView * redCircle;
@property (nonatomic, retain) ParameterAdjustableSet * setter;

@property int amount;
@property float fader;
@property BOOL circle;

-(IBAction) amountChanged: (UISlider *) sender;
-(IBAction) velocityChanged: (UISlider *) sender;
-(IBAction) circleChanged: (UISwitch *) sender;

-(IBAction) amountSet;
-(IBAction) velocitySet;
-(IBAction) circleSet;


@end
