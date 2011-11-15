//
//  RootViewController.h
//  PlistTesterThirdEd
//
//  Created by user on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h"
#import "TestModel.h"
#import "ParameterAdjustableSet.h"

@interface RootViewController : UIViewController <UIGestureRecognizerDelegate>
{
    NSMutableArray *        arrayOfImgs;
    TestModel *             testModel;
    NSTimer *               thatTimer;
    
    UITapGestureRecognizer *tapRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    
    BOOL swipeDirectionIsToTheRight; // that's actually a PanGesture direction
    BOOL previousSwipeDirectionWasToTheRight; 
    ParameterAdjustableSet * setter;
    
    BOOL addGreen;
}

@property (nonatomic, retain) NSTimer *         thatTimer;
@property (nonatomic, retain) NSMutableArray *  arrayOfImgs;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;

@property BOOL swipeDirectionIsToTheRight;
@property BOOL previousSwipeDirectionWasToTheRight;

-(void)runButtonEvent;
-(void)makeAnEffectOfMovingImages;

-(IBAction)handlePanGesture:(UIPanGestureRecognizer *)      sender;
-(IBAction)handleSingleTapGesture:(UIGestureRecognizer *)   sender;
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)            gestureRecognizer 
      shouldReceiveTouch:(UITouch *)                       touch;

-(void)viewDidLoad;
-(void)viewDidUnload;

@end
