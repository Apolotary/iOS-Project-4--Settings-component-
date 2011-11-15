//
//  RootViewController.m
//  PlistTesterThirdEd
//
//  Created by user on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize thatTimer, swipeDirectionIsToTheRight,
tapRecognizer, panRecognizer,
previousSwipeDirectionWasToTheRight, arrayOfImgs;

-(void)clearAnArrayOfImages
{
    int counter = [arrayOfImgs count];
    for (int i = counter - 1; i >= 0; --i)
    {
        [arrayOfImgs removeObjectAtIndex:i];
    }
}

-(void)makeAnArrayOfImages:(CGPoint)center
{
    testModel.circleCenter = center;
    [self clearAnArrayOfImages];
    
    UIImage *fillImage;
    UIImageView *img;
    
    [testModel countAngleChange];
    arrayOfImgs = [[NSMutableArray alloc]init];
    CGFloat x, y;
    for (int i = 0; i < testModel.amountOfImgs; ++i)
    {
        if( i % 2 == 0 && addGreen)
        {
            fillImage = [UIImage imageNamed:@"circle_green.png"];
        }
        else
        {
            fillImage = [UIImage imageNamed:@"circle_red.png"];
        }
        x = DEFAULT_RADIUS*cos(testModel.alpha) + center.x;
        y = DEFAULT_RADIUS*sin(testModel.alpha) + center.y;
        img = [[UIImageView alloc] init];
        img.frame = CGRectMake(x, y, fillImage.size.width, fillImage.size.height);
        img.image = fillImage;
        img.center = CGPointMake(x, y);
        [arrayOfImgs addObject:img];
        NSLog(@"currentalpha: %f", testModel.alpha);
        testModel.alpha += testModel.alphaChange;
        [img release];
    }
}

// an optional method for tap recognizer, used for avoiding button-blocking bug
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] && (gestureRecognizer == tapRecognizer))
    {
        return NO;
    }
    return YES;
}

// creating gesture recognizers and keeping links on them for 
// further possible usage in various methods
-(void)createAndInitGestureRecognizers
{
    NSLog(@"GestureRecs created");
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    self.panRecognizer = (UIPanGestureRecognizer *)panGesture;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [panGesture release];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view addGestureRecognizer:singleTapGesture];
    self.tapRecognizer = (UITapGestureRecognizer *)singleTapGesture;
    singleTapGesture.delegate = self;
    [singleTapGesture release];
}


-(void)settingsButtonClicked
{
    SettingsView * tmp = [[SettingsView alloc] init];
    [self.navigationController pushViewController:tmp animated:YES];
    [tmp release];
}

-(void)clearAllImageViews
{
    int counter = [arrayOfImgs count];
    for (int i = 0; i < counter; ++i)
    {
        [[arrayOfImgs objectAtIndex:i] removeFromSuperview];
    }
}

-(void)runButtonEvent
{
    [self clearAllImageViews];
    testModel.amountOfImgs = setter.amount;
    testModel.SWIPE_FADER_MULTIPLIER = setter.fader;
    NSLog(@"amountOfImgs: %d", testModel.amountOfImgs);
    [self makeAnArrayOfImages:self.view.center];
    int counter = [arrayOfImgs count];
    NSLog(@"imgs in array: %d", counter);
    
    for (int i = 0; i < counter; ++i)
    {
        [self.view addSubview:[arrayOfImgs objectAtIndex:i]];
    }
    
    testModel.alpha = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * setButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonClicked)];
    [self.navigationItem setRightBarButtonItem:setButton]; 
    UIBarButtonItem * runButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleBordered target:self action:@selector(runButtonEvent)];
    [self.navigationItem setLeftBarButtonItem:runButton]; 
    [setButton release];
    [runButton release];
    [self createAndInitGestureRecognizers];
    testModel = [TestModel sharedInstance];
    setter = [ParameterAdjustableSet getInstance];
    [[ParameterAdjustableSet getInstance] loadData];
	[[ParameterAdjustableSet getInstance] loadFromPlist:@"List"];
    addGreen = setter.circle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearAllImageViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[ParameterAdjustableSet getInstance] loadData];
	[[ParameterAdjustableSet getInstance] loadFromPlist:@"List"];
    addGreen = setter.circle;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tapRecognizer = nil;
    self.thatTimer = nil;
    self.panRecognizer = nil;
}

-(void)makeAnEffectOfMovingImages
{
    CGPoint newCenter;
    //NSLog(@"Recalling method! Omega is: %f", self.model.omega);
    for(int i = 0; i < testModel.amountOfImgs; ++i)
    {
        [testModel makeAnEffectOfMovingImagesWhere:swipeDirectionIsToTheRight 
                                          andWhere:previousSwipeDirectionWasToTheRight];
        if(testModel.omega <=0)
        {
            [thatTimer invalidate];
            thatTimer = nil;
        }
        
        newCenter.x = cosf(testModel.alpha)*DEFAULT_RADIUS+ testModel.circleCenter.x;
        newCenter.y = sinf(testModel.alpha)*DEFAULT_RADIUS + testModel.circleCenter.y;
        
        [[arrayOfImgs objectAtIndex:i] setCenter:newCenter];
    }
    
    if (swipeDirectionIsToTheRight)
    {
        previousSwipeDirectionWasToTheRight = YES;
    }
    else
    {
        previousSwipeDirectionWasToTheRight = NO;
    }
}

// fading on tap
-(IBAction)handleSingleTapGesture:(UITapGestureRecognizer *)sender
{
    BOOL temp = [testModel makeAnEffectOfFadingVelocityOfMovement];
    NSLog(@"single tap was handled");
    if (temp)
    {
        [thatTimer invalidate];
        thatTimer = nil;
    }
}

-(IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"swipe was handled");
    NSLog(@"alphaChange: %f", testModel.alphaChange);
    CGPoint temp = [panRecognizer velocityInView:self.view];
    if (temp.x < 0)
    {
        swipeDirectionIsToTheRight = NO;
        temp.x *= -1;
    }
    else
    {
        swipeDirectionIsToTheRight = YES;
    }
    // negative distance may cause sqrtf to fail
    
    NSLog(@"velocity of swipe: %f %f",  temp.x, temp.y);
    
    testModel.omegaMultiplier = (temp.x/800);
    testModel.omega = 0.0006*testModel.omegaMultiplier;
    NSLog(@"omega: %f", testModel.omega);
    if(thatTimer == nil)
    {
        thatTimer = [NSTimer timerWithTimeInterval:0.00001
                                            target:self 
                                          selector:@selector(makeAnEffectOfMovingImages)
                                          userInfo:nil 
                                           repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer: thatTimer forMode: NSDefaultRunLoopMode];    
    }
}

- (void)dealloc {
    [thatTimer release];
    [panRecognizer release];
	[tapRecognizer release];
    [testModel release];
    [super dealloc];
}


@end
