//
//  v002_String_Linguistic_Tagger.m
//  v002 String Markov Generator
//
//  Created by vade on 7/14/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import "v002_String_Linguistic_TaggerPlugIn.h"

#define	kQCPlugIn_Name				@"v002 String Lexical Parser"
#define	kQCPlugIn_Description		@"v002 String Lexical Parser description"

@interface v002_String_Linguistic_TaggerPlugIn ()
@end

@implementation v002_String_Linguistic_TaggerPlugIn

@synthesize linguisticTagger;
@synthesize linguisticOptions;


@dynamic inputString;

@dynamic outputNames;
@dynamic outputPlaces;
@dynamic outputOrganizations;

@dynamic outputNouns;
@dynamic outputVerbs;
@dynamic outputAdjectives;
@dynamic outputAdverbs;
@dynamic outputPronouns;
@dynamic outputParticles;

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
	
	if([key isEqualToString:@"outputNames"])
	{
		return @{QCPortAttributeNameKey:@"Names"};
	}

	if([key isEqualToString:@"outputPlaces"])
	{
		return @{QCPortAttributeNameKey:@"Places"};
	}

	if([key isEqualToString:@"outputOrganizations"])
	{
		return @{QCPortAttributeNameKey:@"Organizations"};
	}

	if([key isEqualToString:@"outputNouns"])
	{
		return @{QCPortAttributeNameKey:@"Nouns"};
	}

	if([key isEqualToString:@"outputVerbs"])
	{
		return @{QCPortAttributeNameKey:@"Verbs"};
	}
	
	if([key isEqualToString:@"outputAdjectives"])
	{
		return @{QCPortAttributeNameKey:@"Adjectives"};
	}
	
	if([key isEqualToString:@"outputAdverbs"])
	{
		return @{QCPortAttributeNameKey:@"Adverbs"};
	}

	if([key isEqualToString:@"outputPronouns"])
	{
		return @{QCPortAttributeNameKey:@"Pronouns"};
	}
	
	if([key isEqualToString:@"outputParticles"])
	{
		return @{QCPortAttributeNameKey:@"Particles"};
	}
	
	return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
    return @[@"outputNames",
			 @"outputPlaces",
			 @"outputOrganizations",
			 @"outputNouns",
			 @"outputVerbs",
			 @"outputAdjectives",
			 @"outputAdverbs",
			 @"outputPronouns",
			 @"outputParticles"];
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
		self.linguisticOptions = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitOther | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
		self.linguisticTagger = [[[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeNameTypeOrLexicalClass] options:self.linguisticOptions] autorelease];
	}
	
	return self;
}

- (void) dealloc
{
	[linguisticTagger release];
	linguisticTagger = nil;
	
	[super dealloc];
}

@end

@implementation v002_String_Linguistic_TaggerPlugIn (Execution)

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
		self.linguisticTagger.string = self.inputString;
		NSMutableSet* names = [NSMutableSet set];
		NSMutableSet* places = [NSMutableSet set];
		NSMutableSet* organizations = [NSMutableSet set];
		
		NSMutableSet* nouns = [NSMutableSet set];
		NSMutableSet* verbs = [NSMutableSet set];
		NSMutableSet* adjectives = [NSMutableSet set];
		NSMutableSet* adverbs = [NSMutableSet set];
		NSMutableSet* pronouns = [NSMutableSet set];
		NSMutableSet* particles = [NSMutableSet set];
		
		[self.linguisticTagger enumerateTagsInRange:NSMakeRange(0, self.inputString.length)
											 scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
											options:self.linguisticOptions
										 usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
		{
			NSString *token = [self.inputString substringWithRange:tokenRange];

			// Were allowed to use pointer equality to speed things up.
			if(tag == NSLinguisticTagPersonalName)
			{
				[names addObject:token];
			}
			
			else if(tag == NSLinguisticTagPlaceName)
			{
				[places addObject:token];
			}
			
			else if(tag == NSLinguisticTagOrganizationName)
			{
				[organizations addObject:token];
			}
			
			else if(tag == NSLinguisticTagNoun)
			{
				[nouns addObject:token];
			}
			
			else if(tag == NSLinguisticTagVerb)
			{
				[verbs addObject:token];
			}
			
			else if(tag == NSLinguisticTagAdjective)
			{
				[adjectives addObject:token];
			}

			else if(tag == NSLinguisticTagAdverb)
			{
				[adverbs addObject:token];
			}
			
			else if(tag == NSLinguisticTagPronoun)
			{
				[pronouns addObject:token];
			}
			
			else if(tag == NSLinguisticTagParticle)
			{
				[particles addObject:token];
			}
		}];

		self.outputNames = [names allObjects];
		self.outputPlaces = [places allObjects];
		self.outputOrganizations = [organizations allObjects];
		
		self.outputNouns = [nouns allObjects];
		self.outputVerbs = [verbs allObjects];
		self.outputAdjectives = [adjectives allObjects];
		self.outputAdverbs = [adverbs allObjects];
		self.outputPronouns = [pronouns allObjects];
		self.outputParticles = [particles allObjects];
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
