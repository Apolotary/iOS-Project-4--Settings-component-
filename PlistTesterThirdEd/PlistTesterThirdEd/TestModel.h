// alpha -- angle used for calculating the center of image
// omega -- acceleration in radians
// omegaMultiplier & alphaChange -- variables which depend from outer values
// used for calculating changes in omega and alpha

#import <Foundation/Foundation.h>
#define DEFAULT_RADIUS 100
#define TAP_FADER_MULTIPLIER 1.0

@interface TestModel : NSObject 
{
    CGPoint circleCenter;
    float   omegaMultiplier;
    float   omega;                  // in radians
    float   lastAcceleration;       // in radians
    float   alpha;                  // in radians
    float   alphaChange;            // in radians
    int     amountOfImgs;   
    float   SWIPE_FADER_MULTIPLIER;
}

@property CGPoint circleCenter;
@property int     amountOfImgs;
@property float   alphaChange;
@property float   alpha;
@property float   omega;
@property float   omegaMultiplier;
@property float   lastAcceleration;
@property float   SWIPE_FADER_MULTIPLIER;

+(TestModel *) sharedInstance;
-(void)countAngleChange;
-(void)makeAnEffectOfMovingImagesWhere:(BOOL)swipeDirectionIsToTheRight 
                              andWhere:(BOOL)previousSwipeDirectionWasToTheRight;
-(BOOL)makeAnEffectOfFadingVelocityOfMovement;

@end
