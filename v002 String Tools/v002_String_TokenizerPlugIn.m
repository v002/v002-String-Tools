//
//  v002_String_TokenizerPlugIn.m
//  v002 String Markov Generator
//
//  Created by vade on 7/15/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import "v002_String_TokenizerPlugIn.h"

#define	kQCPlugIn_Name				@"v002 String Tokenizer"
#define	kQCPlugIn_Description		@"v002 String Tokenizer description"
#define	kQCPlugIn_Category          [NSArray arrayWithObject:@"v002"]

@interface v002_String_TokenizerPlugIn ()


@end

@implementation v002_String_TokenizerPlugIn

@synthesize wordTokenizer;
@synthesize sentenceTokenizer;
@synthesize paragraphTokenizer;
@synthesize lineTokenizer;

@synthesize wordArray;
@synthesize sentenceArray;
@synthesize paragraphArray;
@synthesize lineArray;


@dynamic inputString;

@dynamic outputString;
@dynamic outputWords;
@dynamic outputSentences;
@dynamic outputLineEndings;
@dynamic outputParagraphs;


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
	
	if([key isEqualToString:@"outputWords"])
	{
		return @{QCPortAttributeNameKey: @"Words"};
	}
	
	if([key isEqualToString:@"outputSentences"])
	{
		return @{QCPortAttributeNameKey: @"Sentences"};
	}
	
	if([key isEqualToString:@"outputLineEndings"])
	{
		return @{QCPortAttributeNameKey: @"Line Endings"};
	}
	
	if([key isEqualToString:@"outputParagraphs"])
	{
		return @{QCPortAttributeNameKey: @"Paragraphs"};
	}
	
	return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
    return @[@"inputString",
			 @"outputWords",
			 @"outputSentences",
			 @"outputLineEndings",
			 @"outputParagraphs",
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


- (void) dealloc
{
	
	[wordArray release];
	wordArray  = nil;
	
	[sentenceArray release];
	sentenceArray = nil;

	[paragraphArray release];
	paragraphArray = nil;

	[lineArray release];
	lineArray = nil;

	if(wordTokenizer)
		CFRelease(wordTokenizer);
	
	wordTokenizer = NULL;
	
	if(sentenceTokenizer)
		CFRelease(sentenceTokenizer);
	sentenceTokenizer = NULL;
	
	if(sentenceTokenizer)
		CFRelease(sentenceTokenizer);
	sentenceTokenizer = NULL;
	
	if(lineTokenizer)
		CFRelease(lineTokenizer);
	lineTokenizer = NULL;
	
	[super dealloc];
}

@end


@implementation v002_String_TokenizerPlugIn (Execution)

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
    if([self didValueForInputKeyChange:@"inputString"])
    {
		[self buildTokenArrays:self.inputString];
		
		self.outputWords = self.wordArray;
		self.outputSentences = self.sentenceArray;
		self.outputLineEndings = self.lineArray;
		self.outputParagraphs = self.paragraphArray;
	}

	return YES;
}

- (void) buildTokenArrays:(NSString*)string
{
	// reset all of our internal arrays
	self.wordArray = [NSMutableArray array];
	self.sentenceArray = [NSMutableArray array];
	self.paragraphArray = [NSMutableArray array];
	self.lineArray = [NSMutableArray array];
	
	CFLocaleRef locale = CFLocaleCopyCurrent();
	CFRange stringRange = CFRangeMake(0, string.length);

	// Build our various tokenizer if we need to, otherwise re-assign them.
	// Word
	if(!self.wordTokenizer)
	{
		self.wordTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, ( CFStringRef)(string), stringRange, kCFStringTokenizerUnitWord, locale);
		CFStringTokenizerGoToTokenAtIndex(self.wordTokenizer, 0);
	}
	else
	{
		CFStringTokenizerSetString(self.wordTokenizer, ( CFStringRef)(string), stringRange);
		CFStringTokenizerGoToTokenAtIndex(self.wordTokenizer, 0);
	}

	// Sentence
	if(!self.sentenceTokenizer)
	{
		self.sentenceTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, ( CFStringRef)(string), stringRange, kCFStringTokenizerUnitSentence, locale);
		CFStringTokenizerGoToTokenAtIndex(self.sentenceTokenizer, 0);
	}
	else
	{
		CFStringTokenizerSetString(self.sentenceTokenizer, ( CFStringRef)(string), stringRange);
		CFStringTokenizerGoToTokenAtIndex(self.sentenceTokenizer, 0);
	}

	// Paragraph
	if(!self.paragraphTokenizer)
	{
		self.paragraphTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, ( CFStringRef)(string), stringRange, kCFStringTokenizerUnitParagraph, locale);
		CFStringTokenizerGoToTokenAtIndex(self.paragraphTokenizer, 0);
	}
	else
	{
		CFStringTokenizerSetString(self.paragraphTokenizer, ( CFStringRef)(string), stringRange);
		CFStringTokenizerGoToTokenAtIndex(self.paragraphTokenizer, 0);
	}

	// Line
	if(!self.lineTokenizer)
	{
		self.lineTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, ( CFStringRef)(string), stringRange, kCFStringTokenizerUnitLineBreak, locale);
		CFStringTokenizerGoToTokenAtIndex(self.lineTokenizer, 0);
	}
	else
	{
		CFStringTokenizerSetString(self.lineTokenizer, ( CFStringRef)(string), stringRange);
		CFStringTokenizerGoToTokenAtIndex(self.lineTokenizer, 0);
	}
	// Fill our arrays with the tokenizers output.
	
	// Word
	CFStringTokenizerTokenType tokenType = CFStringTokenizerAdvanceToNextToken(self.wordTokenizer);
	
	while(kCFStringTokenizerTokenNone != tokenType)
	{
		CFRange range = CFStringTokenizerGetCurrentTokenRange(self.wordTokenizer);
		
		NSRange tokenRange = NSMakeRange( range.location == kCFNotFound ? NSNotFound : range.location, range.length );
		
		[self.wordArray addObject:[string substringWithRange:tokenRange]];
		
		tokenType = CFStringTokenizerAdvanceToNextToken(self.wordTokenizer);
	}
	
	tokenType = CFStringTokenizerAdvanceToNextToken(self.sentenceTokenizer);
	
	while(kCFStringTokenizerTokenNone != tokenType)
	{
		CFRange range = CFStringTokenizerGetCurrentTokenRange(self.sentenceTokenizer);
		
		NSRange tokenRange = NSMakeRange( range.location == kCFNotFound ? NSNotFound : range.location, range.length );
		
		[self.sentenceArray addObject:[string substringWithRange:tokenRange]];
		
		tokenType = CFStringTokenizerAdvanceToNextToken(self.sentenceTokenizer);
	}
	
	tokenType = CFStringTokenizerAdvanceToNextToken(self.paragraphTokenizer);
	
	while(kCFStringTokenizerTokenNone != tokenType)
	{
		CFRange range = CFStringTokenizerGetCurrentTokenRange(self.paragraphTokenizer);
		
		NSRange tokenRange = NSMakeRange( range.location == kCFNotFound ? NSNotFound : range.location, range.length );
		
		[self.paragraphArray addObject:[string substringWithRange:tokenRange]];

		tokenType = CFStringTokenizerAdvanceToNextToken(self.paragraphTokenizer);
	}
	
	tokenType = CFStringTokenizerAdvanceToNextToken(self.lineTokenizer);
	
	while(kCFStringTokenizerTokenNone != tokenType)
	{
		CFRange range = CFStringTokenizerGetCurrentTokenRange(self.lineTokenizer);
		
		NSRange tokenRange = NSMakeRange( range.location == kCFNotFound ? NSNotFound : range.location, range.length );
		
		[self.lineArray addObject:[string substringWithRange:tokenRange]];
		
		tokenType = CFStringTokenizerAdvanceToNextToken(self.lineTokenizer);
	}
	
	if(locale)
		CFRelease(locale);
}

@end

