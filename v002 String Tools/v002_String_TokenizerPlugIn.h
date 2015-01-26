//
//  v002_String_TokenizerPlugIn.h
//  v002 String Markov Generator
//
//  Created by vade on 7/15/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface v002_String_TokenizerPlugIn : QCPlugIn
{
	CFStringTokenizerRef wordTokenizer;
	CFStringTokenizerRef sentenceTokenizer;
	CFStringTokenizerRef paragraphTokenizer;
	CFStringTokenizerRef lineTokenizer;
	
	NSMutableArray* wordArray;
	NSMutableArray* sentenceArray;
	NSMutableArray* paragraphArray;
	NSMutableArray* lineArray;
}

@property (atomic, readwrite, assign) CFStringTokenizerRef wordTokenizer;
@property (atomic, readwrite, assign) CFStringTokenizerRef sentenceTokenizer;
@property (atomic, readwrite, assign) CFStringTokenizerRef paragraphTokenizer;
@property (atomic, readwrite, assign) CFStringTokenizerRef lineTokenizer;

@property (atomic, readwrite, strong) NSMutableArray* wordArray;
@property (atomic, readwrite, strong) NSMutableArray* sentenceArray;
@property (atomic, readwrite, strong) NSMutableArray* paragraphArray;
@property (atomic, readwrite, strong) NSMutableArray* lineArray;


@property (strong) NSString* inputString;

@property (strong) NSString* outputString;
@property (strong) NSArray* outputWords;
@property (strong) NSArray* outputSentences;
@property (strong) NSArray* outputLineEndings;
@property (strong) NSArray* outputParagraphs;

@end