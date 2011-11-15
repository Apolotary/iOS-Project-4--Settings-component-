//
//  ParameterAdjustableSet.h
//  ParametersAdjuster
//
//  Created by User Mac on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TYPE @"type"
#define CLASS_NAME @"classVariableName"
#define VARIABLE_NAME @"variableName"

@interface ParameterAdjustableSet : NSObject 
{
	NSMutableArray* dictionaries;//array of dictionaries loaded from plist
    //class varibales. Can be changed at runtime
	int amount;
	BOOL circle;
	float fader;
	NSString* name;
}
+(ParameterAdjustableSet*) getInstance;//singleton
+(void) disposeInstance;
-(void) loadFromPlist:(NSString*) plistName;//loads array of dictionaries from plist
-(void) saveData;//saves current variables values to user defaults
-(BOOL) loadData;//loalds variables values from user defaults
//use this method to invoke setter for properties of native type like int,float, etc
-(void) invokeSetter:(SEL) selector withValue:(void*) argument;
//user this method to invoke getter for properties of native type like int,float, etc. pass variable where you want to store value to output parameter
-(void) invokeGetter:(SEL) selector toValue:(void**) output;

@property(nonatomic, retain) NSMutableArray* dictionaries;
@property(nonatomic, retain) NSString* name;
@property(nonatomic) int amount;
@property(nonatomic) BOOL circle;
@property(nonatomic) float fader;
@end
