//
//  v002_String_Structure_ReplacePlugIn.h
//  v002 String Markov Generator
//
//  Created by vade on 7/17/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import <Quartz/Quartz.h>


@interface v002_String_Structure_ReplacePlugIn : QCPlugIn

@property (strong) NSString* inputString;
@property (strong) NSArray* inputToReplaceStructure;
@property (strong) NSString* inputReplaceToken;

@property (assign) NSUInteger inputReplaceMode;


@property (strong) NSString* outputString;

@end
