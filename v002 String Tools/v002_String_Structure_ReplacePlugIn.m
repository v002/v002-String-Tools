//
//  v002_String_Structure_ReplacePlugIn.m
//  v002 String Markov Generator
//
//  Created by vade on 7/17/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import "v002_String_Structure_ReplacePlugIn.h"

#define	kQCPlugIn_Name				@"v002 String Structure Replace"
#define	kQCPlugIn_Description		@"v002 String Structure Replace description"
#define	kQCPlugIn_Category          [NSArray arrayWithObject:@"v002"]

@implementation v002_String_Structure_ReplacePlugIn

@dynamic inputString;
@dynamic inputToReplaceStructure;
@dynamic inputReplaceToken;
@dynamic inputReplaceMode;
@dynamic outputString;

+ (NSDictionary*) attributes
{
	return @{QCPlugInAttributeNameKey: kQCPlugIn_Name,
		  QCPlugInAttributeDescriptionKey: kQCPlugIn_Description,
		  @"categories": kQCPlugIn_Category};
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	if([key isEqualToString:@"inputString"])
	{
		return @{QCPortAttributeNameKey: @"String"};
	}
	
	if([key isEqualToString:@"inputToReplaceStructure"])
	{
		return @{QCPortAttributeNameKey: @"Replace Structure"};
	}
	
	if([key isEqualToString:@"inputReplaceToken"])
	{
		return @{QCPortAttributeNameKey: @"Replace String"};
	}

	
	if([key isEqualToString:@"inputReplaceMode"])
	{
		return @{QCPortAttributeNameKey: @"Replace Mode",
		   QCPortAttributeDefaultValueKey : @0,
		   QCPortAttributeMinimumValueKey : @0,
		   QCPortAttributeMaximumValueKey : @1,
		   QCPortAttributeMenuItemsKey : @[@"Replace Structure with String", @"Replace String With Random Structure"]};
	}
	

	if([key isEqualToString:@"outputString"])
	{
		return @{QCPortAttributeNameKey: @"String"};
	}
	
	return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
    return @[@"inputString",
			 @"inputToReplaceStructure",
			 @"inputReplaceToken",
			 @"outputString",
			 ];
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode) timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id) init
{
    self = [super init];
	if(self)
    {
	}
	
	return self;
}
@end


@implementation v002_String_Structure_ReplacePlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
}

- (void) stopExecution:(id <QCPlugInContext>)context
{
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	if([self didValueForInputKeyChange:@"inputString"] ||
	   [self didValueForInputKeyChange:@"inputToReplaceStructure"] ||
	   [self didValueForInputKeyChange:@"inputReplaceToken"]
	   )
	{
		// This is stupid and Naive. Needs to be optimized.
		NSMutableString* mutableInput = [self.inputString mutableCopy];

		for(NSString* stringToReplace in self.inputToReplaceStructure)
		{
			NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
			if(mutableInput)
			{
				if(!self.inputReplaceMode)
				{
					NSString* pattern = [NSString stringWithFormat:@"\\b%@\\b", stringToReplace, nil];
//					NSError *error = nil;
//
//					NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern  // @"\\b1/2\\b"
//																						   options:NSRegularExpressionCaseInsensitive
//																							 error:&error];
//					
//					// Replace the matches
//					NSString *modifiedString = [regex stringByReplacingMatchesInString:mutableInput
//																			   options:0
//																				 range:NSMakeRange(0, [mutableInput length])
//																		  withTemplate:self.inputReplaceToken];
//					
//					if(modifiedString)
//					{
//						[mutableInput release];
//						mutableInput = nil;
//						
//						NSMutableString* mutableModifiedString = [modifiedString mutableCopy];
//						
//						mutableInput = mutableModifiedString;
//					}

					NSRange range = [mutableInput rangeOfString:stringToReplace];
					
					if(range.location == NSNotFound)
						continue;

					[mutableInput replaceOccurrencesOfString:pattern withString:self.inputReplaceToken options:NSRegularExpressionSearch range:NSMakeRange(0, mutableInput.length)];
				}
				else
				{
					NSUInteger randomIndex = [self randomIndexUnder:self.inputToReplaceStructure.count];
					NSString* replaceString = [self.inputToReplaceStructure objectAtIndex:randomIndex];
					
					NSString* pattern = [NSString stringWithFormat:@"\\b%@\\b", self.inputReplaceToken, nil];

					NSRange range = [mutableInput rangeOfString:self.inputReplaceToken];

					if(range.location == NSNotFound)
						continue;
					
					[mutableInput replaceOccurrencesOfString:pattern withString:replaceString options:NSRegularExpressionSearch range:range];
				}
			}
			
			[pool drain];
			
		}
		
		self.outputString = mutableInput;
		
		[mutableInput release];
		mutableInput = nil;
	}
		
	return YES;
}

- (NSUInteger) randomIndexUnder:(NSUInteger) topPlusOne
{
    {
        NSUInteger two31 = 1U << 31;
        NSUInteger maxUsable = (two31 / topPlusOne) * topPlusOne;
        
        while(1)
        {
            NSUInteger num = random();
            if(num < maxUsable)
                return num % topPlusOne;
        }
    }
}

@end
