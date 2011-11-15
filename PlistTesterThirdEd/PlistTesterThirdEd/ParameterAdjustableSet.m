//
//  ParameterAdjustableSet.m
//  ParametersAdjuster
//
//  Created by User Mac on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParameterAdjustableSet.h"


@implementation ParameterAdjustableSet

@synthesize amount;
@synthesize fader;
@synthesize circle;
@synthesize name;
@synthesize dictionaries;
static ParameterAdjustableSet* instance = nil;
+(ParameterAdjustableSet*) getInstance
{
	@synchronized(self)
	{
		if(instance==nil)
		{
			instance = [[ParameterAdjustableSet alloc] init];
		}
		return instance;
	}
}
+(void) disposeInstance
{
	instance.dictionaries = nil;
	[instance release];
	instance = nil;
}
-(void) loadFromPlist:(NSString *)plistName
{
	NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
	self.dictionaries = [NSMutableArray arrayWithContentsOfFile:path];
}
    //using invokation instead of performselector 'cuz getters/setters for native types like int,float, etc. can't get/return type of id
-(void) invokeSetter:(SEL)selector withValue:(void *)argument
{
	NSMethodSignature* signature = [[ParameterAdjustableSet getInstance]  methodSignatureForSelector:selector];
	NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:signature];
	[invoker setTarget:[ParameterAdjustableSet getInstance]];
	[invoker setSelector:selector];
	[invoker setArgument:argument atIndex:2];
	[invoker invoke];
}
-(void) invokeGetter:(SEL)selector toValue:(void **)output
{
	NSMethodSignature* signature = [[ParameterAdjustableSet getInstance]  methodSignatureForSelector:selector];
	NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:signature];
	[invoker setTarget:[ParameterAdjustableSet getInstance]];
	[invoker setSelector:selector];
	[invoker invoke];
	[invoker getReturnValue:output];
}

//saves class variables values to users default
-(void) saveData
{		
	NSString* selectorMask = @"";
	NSString* type;
	void * temp;
	
	for(NSDictionary* var in self.dictionaries)
	{
		
		selectorMask = [var valueForKey:CLASS_NAME];//get variable class name to create a string, containing getter selector's name	
        //getters are of type like class variable name e.g. : count, name, etc.
		type = [var valueForKey:TYPE];
		//check for type of variable to create buffer variable of appropriate type
		if([type isEqualToString:@"BOOL"])
		{
			BOOL result;
			temp = &result;
			
			[[ParameterAdjustableSet getInstance] invokeGetter:NSSelectorFromString(selectorMask) toValue:temp];
			[[NSUserDefaults standardUserDefaults] setBool:result forKey:selectorMask];
		}
		else if([type isEqualToString:@"int"])
		{
			int result;
			temp = &result;
			
			[[ParameterAdjustableSet getInstance] invokeGetter:NSSelectorFromString(selectorMask) toValue:temp];
			[[NSUserDefaults standardUserDefaults] setInteger:result forKey:selectorMask];
		}
		else if([type isEqualToString:@"float"])
		{
			float result;
			temp = &result;
			
			[[ParameterAdjustableSet getInstance] invokeGetter:NSSelectorFromString(selectorMask) toValue:temp];
			[[NSUserDefaults standardUserDefaults] setFloat:result forKey:selectorMask];
		}
		else if([type isEqualToString:@"NSString"])
		{
			NSString * result;
			temp = &result;
			
			[[ParameterAdjustableSet getInstance] invokeGetter:NSSelectorFromString(selectorMask) toValue:temp];
			[[NSUserDefaults standardUserDefaults] setObject:result forKey:selectorMask];
	}
	
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

-(BOOL) loadData
{
	/*NSString * plistN = @"List";
	NSString* path = [[NSBundle mainBundle] pathForResource:plistN ofType:@"plist"];
	self.dictionaries = [NSMutableArray arrayWithContentsOfFile:path];*/
    [self loadFromPlist:@"List"];
	NSString* selectorMask;
    NSString* type;
	for(NSDictionary* var in self.dictionaries)
	{
		selectorMask = @"set";
		selectorMask = [selectorMask stringByAppendingString:[[var valueForKey:CLASS_NAME] capitalizedString]];
		selectorMask = [selectorMask stringByAppendingString:@":"];
        //creates string representing setter selector. setters are like : set + class variable name, with first letter capitalized and  ":" at the end of the string
		type = [var valueForKey:TYPE];
        //check for type of variable to create buffer variable of appropriate type
		if([type isEqualToString:@"BOOL"])
		{
			BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:[var valueForKey:CLASS_NAME]];
			[[ParameterAdjustableSet getInstance] invokeSetter:NSSelectorFromString(selectorMask) withValue:&result];
		}
		else if([type isEqualToString:@"NSString"])
		{
			NSString * result = [[NSUserDefaults standardUserDefaults] stringForKey:[var valueForKey:CLASS_NAME]];
			[[ParameterAdjustableSet getInstance] invokeSetter:NSSelectorFromString(selectorMask) withValue:&result];
		}
		else if([type isEqualToString:@"int"])
		{
			int result = [[NSUserDefaults standardUserDefaults] integerForKey:[var valueForKey:CLASS_NAME]];
			[[ParameterAdjustableSet getInstance] invokeSetter:NSSelectorFromString(selectorMask) withValue:&result];
		}
		else if([type isEqualToString:@"float"] || [type isEqualToString:@"double"])
		{
			float result = [[NSUserDefaults standardUserDefaults] floatForKey:[var valueForKey:CLASS_NAME]];
			[[ParameterAdjustableSet getInstance] invokeSetter:NSSelectorFromString(selectorMask) withValue:&result];
		}
	}
	return YES;
}
@end
