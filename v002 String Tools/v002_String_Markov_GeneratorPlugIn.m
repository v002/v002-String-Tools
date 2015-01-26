//
//  v002_String_Markov_GeneratorPlugIn.m
//  v002 String Markov Generator
//
//  Created by vade on 7/13/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "v002_String_Markov_GeneratorPlugIn.h"

#define	kQCPlugIn_Name				@"v002 String Markov Generator"
#define	kQCPlugIn_Description		@"v002 String Markov Generator description"

@interface v002_String_Markov_GeneratorPlugIn ()

@end

@implementation v002_String_Markov_GeneratorPlugIn

@synthesize suffixDictionary;
@synthesize prefixStack;
@synthesize wordArray;


@dynamic inputString;
@dynamic inputKeyword;
@dynamic inputOrder;
@dynamic inputLength;
@dynamic inputReCalculate;
@dynamic outputString;

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
	
	if([key isEqualToString:@"inputKeyword"])
	{
		return @{QCPortAttributeNameKey : @"Key Word" , QCPortAttributeDefaultValueKey : @""};
	}


	if([key isEqualToString:@"inputOrder"])
	{
		return @{QCPortAttributeNameKey:@"Order",
		   QCPortAttributeMinimumValueKey: @1,
		   QCPortAttributeDefaultValueKey: @2,
		   };
	}
	
	if([key isEqualToString:@"inputLength"])
	{
		return @{QCPortAttributeNameKey:@"Word Count",
		   QCPortAttributeMinimumValueKey: @1,
		   QCPortAttributeDefaultValueKey: @100,
		   };
	}
	
	if([key isEqualToString:@"inputReCalculate"])
	{
		return @{QCPortAttributeNameKey:@"Regenerate"};
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
			 @"inputKeyword",
			 @"inputOrder",
			 @"inputLength",
			 @"inputReCalculate",
			 @"outputString",
			 ];
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
		self.suffixDictionary = [NSMutableDictionary dictionary];
		self.prefixStack = [NSMutableArray array];
	}
	
	return self;
}


@end

@implementation v002_String_Markov_GeneratorPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	if([self didValueForInputKeyChange:@"inputString"])
	{
		[self buildWordArray:self.inputString];
		[self buildMarkovChainUsingSeedString:self.inputString];
		self.outputString = [self generateTextOfLength:self.inputLength keyWord:self.inputKeyword];
	}
		
	if([self didValueForInputKeyChange:@"inputOrder"]
	   || [self didValueForInputKeyChange:@"inputLength"]
	   || [self didValueForInputKeyChange:@"inputKeyword"]
	   )
	{
		[self buildMarkovChainUsingSeedString:self.inputString];
	
		self.outputString = [self generateTextOfLength:self.inputLength keyWord:self.inputKeyword];
	}
	
	// Reclaculate if requested, or any of our inputs change
	if(self.inputReCalculate)
	{
		self.outputString = [self generateTextOfLength:self.inputLength  keyWord:self.inputKeyword];
	}

	
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
}

- (void) buildWordArray:(NSString*)string
{
//	// Decompose into words, using CFStringTokenizer since its way more accurate than other methods.
//	CFLocaleRef locale = CFLocaleCopyCurrent();
//	
//	CFStringTokenizerRef wordTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, (CFStringRef)(string), CFRangeMake(0, string.length), kCFStringTokenizerUnitWord, locale);
//	
//	CFStringTokenizerTokenType tokenType = kCFStringTokenizerTokenNone;
//	
//	self.wordArray = [NSMutableArray array];
//	
//	while(kCFStringTokenizerTokenNone != (tokenType = CFStringTokenizerAdvanceToNextToken(wordTokenizer)))
//	{
//		CFRange range = CFStringTokenizerGetCurrentTokenRange(wordTokenizer);
//		
//		NSRange tokenRange = NSMakeRange(range.location == kCFNotFound ? NSNotFound : range.location, range.length );
//		
//		if (tokenRange.location != NSNotFound)
//		{
//			NSString* word = [string substringWithRange:tokenRange];
//			
//			[self.wordArray addObject:word];
//		}
//	}
//	
//	CFRelease(wordTokenizer);
//	CFRelease(locale);
	
//	NSMutableCharacterSet* mutableCharacterSet = [[NSMutableCharacterSet alloc] init];
//	[mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	[mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
	self.wordArray = [[[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy] autorelease];

//	[mutableCharacterSet release];
}

- (void) resetPrefix
{
	self.prefixStack = [NSMutableArray array];
	
	if(self.prefixStack.count >= self.inputOrder)
	{
		for(NSUInteger i = 0; i < self.inputOrder; ++i)
		{
			[self.prefixStack replaceObjectAtIndex:i withObject:@" "];
		}
	}
}

- (void) buildMarkovChainUsingSeedString:(NSString*)string
{
	[self resetPrefix];
	
	// reset suffix dictionary
	self.suffixDictionary = [NSMutableDictionary dictionary];

	// Now, for each word, we add it to our markov chain
	for(NSString* word in self.wordArray)
	{
		if(word.length)
			[self addString:word];
	}
}

- (void) addString:(NSString*)string
{
	NSString* key = [self.prefixStack componentsJoinedByString:@" "];
	
	if([self.suffixDictionary objectForKey:key])
	{
		NSMutableArray* value = [self.suffixDictionary objectForKey:key];
		if(value)
		{
			[value addObject:string];
			[self.suffixDictionary setObject:value forKey:key];
		}
	}
	else
		[self.suffixDictionary setObject:[NSMutableArray arrayWithObject:string] forKey:key];
	
	if(self.prefixStack.count)
		[self.prefixStack removeObjectAtIndex:0];
	
	[self.prefixStack addObject:string];
}

- (NSString*) generateTextOfLength:(NSUInteger)length keyWord:(NSString*)keyWord
{
	// Clear Prefix
	[self resetPrefix];
	
	if(keyWord.length)
	{
		NSArray* allKeys = [self.suffixDictionary allKeys];
		NSMutableArray* potentialKeys = [NSMutableArray array];
		
		[allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
		 {
			 NSString* key = (NSString*)obj;
			 if([key rangeOfString:keyWord].length)
			 {
				 [potentialKeys addObject:key];
//				 *stop = YES;
			 }
		 }];
		
		if(potentialKeys.count)
		{
			NSUInteger randomMax = potentialKeys.count - 1;
			NSUInteger randomIndex = [self randomIndex:randomMax];
			NSString* randomKey = [potentialKeys objectAtIndex:randomIndex];

			[self.prefixStack addObject:randomKey];
		}
	}

	
	NSMutableString* outputString = [NSMutableString string];
	
	for(NSUInteger i = 0; i < length; ++i)
	{
		@autoreleasepool
		{
			NSString* key = [self.prefixStack componentsJoinedByString:@" "];
			NSArray* value = nil;
			
			// Find the first appropriate key that contains our key word, from our suffix dict, to seed our initial value
			value = [self.suffixDictionary objectForKey:key];
			
			if(value && value.count)
			{
				
				NSUInteger randomMax = value.count - 1;
				NSUInteger randomIndex = [self randomIndex:randomMax];
			
				NSString* randomString = [value objectAtIndex:randomIndex];
				
				if([randomString isEqualToString:@" "])
					break;
				
				[outputString appendFormat:@" %@",randomString, nil];
//				[outputString appendString:randomString];
				
				if(self.prefixStack.count)
					[self.prefixStack removeObjectAtIndex:0];
				
				[self.prefixStack addObject:randomString];
			}
		}
	}
	
//	NSLog(@"outputString: %@", outputString);
	
	return outputString;
}

- (NSUInteger) randomIndex:(NSUInteger) max
{
	unsigned now = time(NULL);
    srand(now);

	u_int32_t rawRand = (arc4random() % ((unsigned)RAND_MAX + 1));
	float normalizedRand = (double)rawRand/(double)RAND_MAX;
	
    return (NSUInteger)(normalizedRand * max);
}

@end
