//
//  SettingsView.m
//  PlistTesterThirdEd
//
//  Created by user on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"


@implementation SettingsView

@synthesize greenCircle, redCircle, amount, fader, circle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonClicked
{
    setter.amount = amount;
    setter.circle = circle;
    setter.fader = fader;
    [setter saveData];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Done", nil) message:@"Settings were changed and saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    [self backButtonClicked];
}

-(IBAction) amountSet
{
    float tmp = amount;
    amountSlider.value = tmp/10;
    [amountLabel setText:[NSString stringWithFormat:@"%d", amount]];
}

-(IBAction) velocitySet
{
    velocitySlider.value = fader * 10000000;
    [velocityLabel setText:[NSString stringWithFormat:@"%1.2f * 10^(-7)", fader * 10000000]];
}

-(IBAction) circleSet
{
    if (circle)
    {
        greenCircle.image = [UIImage imageNamed:@"circle_green"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
        circleSwitch.on = circle;
    }
    else
    {
        greenCircle.image = [UIImage imageNamed:@"circle_red"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
        circleSwitch.on = circle;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:backButton]; 
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClicked)];
    [self.navigationItem setRightBarButtonItem:doneButton]; 
    [self.navigationController.navigationItem setTitle:@"Settings"];
    [backButton release];
    [doneButton release];
    if ([circleSwitch isOn])
    {
        greenCircle.image = [UIImage imageNamed:@"circle_green"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
    }
    else
    {
        greenCircle.image = [UIImage imageNamed:@"circle_red"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
    }

    setter = [ParameterAdjustableSet getInstance];
    
    [[ParameterAdjustableSet getInstance] loadData];
	[[ParameterAdjustableSet getInstance] loadFromPlist:@"List"];
    
    amount = setter.amount;
    circle = setter.circle;
    fader = setter.fader;
    
    [self amountSet];
    [self velocitySet];
    [self circleSet];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction) amountChanged: (UISlider *) sender
{
    amount = sender.value * 10;
    [amountLabel setText:[NSString stringWithFormat:@"%d", amount]];
}

-(IBAction) velocityChanged: (UISlider *) sender
{
    fader = sender.value;
    [velocityLabel setText:[NSString stringWithFormat:@"%1.2f * 10^(-7)", fader]];
    fader /= 10000000;
}

-(IBAction) circleChanged: (UISwitch *) sender
{
    if ([sender isOn])
    {
        greenCircle.image = [UIImage imageNamed:@"circle_green"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
        circle = YES;
    }
    else
    {
        greenCircle.image = [UIImage imageNamed:@"circle_red"];
        redCircle.image = [UIImage imageNamed:@"circle_red"];
        circle = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
