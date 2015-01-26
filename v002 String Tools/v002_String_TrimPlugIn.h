//
//  v002_String_TrimPlugIn.h
//  v002 String Markov Generator
//
//  Created by vade on 7/15/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface v002_String_TrimPlugIn : QCPlugIn

@property (copy) NSString* inputString;
@property (assign) NSUInteger inputCharacterSet;
@property (copy) NSString* outputString;

@end
