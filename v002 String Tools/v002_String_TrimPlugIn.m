//
//  v002_String_TrimPlugIn.m
//  v002 String Markov Generator
//
//  Created by vade on 7/15/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import "v002_String_TrimPlugIn.h"

#define	kQCPlugIn_Name				@"v002 String Trim"
#define	kQCPlugIn_Description		@"v002 String Trim Description"


@implementation v002_String_TrimPlugIn

@dynamic inputString;
@dynamic inputCharacterSet;
@dynamic outputString;

+ (NSArray*) characterSetArray
{
	return  [NSArray arrayWithObjects:[NSCharacterSet whitespaceCharacterSet],
			 [NSCharacterSet whitespaceAndNewlineCharacterSet],
			 [NSCharacterSet newlineCharacterSet],
			 [NSCharacterSet controlCharacterSet],
			 [NSCharacterSet punctuationCharacterSet],
			 [NSCharacterSet symbolCharacterSet],
//			 [NSCharacterSet controlCharacterSet],
			 [NSCharacterSet decimalDigitCharacterSet],
			 [NSCharacterSet alphanumericCharacterSet],
			 [NSCharacterSet decomposableCharacterSet],
			 [NSCharacterSet illegalCharacterSet],
			 nil];

}

+ (NSArray*) characterSetNameArray
{
	return  [NSArray arrayWithObjects:@"White Space",
			 @"White Space and New Lines",
			 @"New Lines",
			 @"Control Characters",
			 @"Punctuation Characters",
			 @"Symbol Characters",
			 @"Decimal Numbers",
			 @"Alphanumeric Characters",
			 @"Valid Characters",
			 @"Illegal Characters", nil];
	
}

+ (NSDictionary *)attributes
{
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	if([key isEqualToString:@"inputString"])
	{
		return @{QCPortAttributeNameKey:@"String"};
	}
	
	if([key isEqualToString:@"inputCharacterSet"])
	{
		return @{QCPortAttributeNameKey:@"Character Set",
		   QCPortAttributeMinimumValueKey : @0,
		   QCPortAttributeDefaultValueKey : @0,
		   QCPortAttributeMaximumValueKey : @([v002_String_TrimPlugIn characterSetArray].count - 1),
		   QCPortAttributeMenuItemsKey : [v002_String_TrimPlugIn characterSetNameArray]
		   };
	}

	if([key isEqualToString:@"outputString"])
	{
		return @{QCPortAttributeNameKey:@"String"};
	}

	return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
    return @[@"inputString",
			 @"inputCharacterSet",
			 @"outputString"];
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	
	return self;
}

@end

@implementation v002_String_TrimPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	if([self didValueForInputKeyChange:@"inputString"] ||
	   [self didValueForInputKeyChange:@"inputCharacterSet"])
	{
		NSCharacterSet* set = [[v002_String_TrimPlugIn characterSetArray] objectAtIndex:self.inputCharacterSet];
		
		self.outputString = [[self.inputString componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@" "];
	}
	
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
}

@end
