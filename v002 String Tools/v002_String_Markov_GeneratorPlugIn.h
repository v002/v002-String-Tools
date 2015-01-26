//
//  v002_String_Markov_GeneratorPlugIn.h
//  v002 String Markov Generator
//
//  Created by vade on 7/13/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface v002_String_Markov_GeneratorPlugIn : QCPlugIn
{
	NSMutableDictionary* suffixDictionary;
	NSMutableArray* prefixStack;
	NSMutableArray* wordArray;
}

@property (atomic, readwrite, strong) NSMutableDictionary* suffixDictionary;
@property (atomic, readwrite, strong) NSMutableArray* prefixStack;
@property (atomic, readwrite, strong) NSMutableArray* wordArray;

@property (strong) NSString* inputString;
@property (strong) NSString* inputKeyword;
@property (assign) NSUInteger inputOrder;
@property (assign) NSUInteger inputLength;
@property (assign) BOOL inputReCalculate;

@property (copy) NSString* outputString;

@end
