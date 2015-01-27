//
//  v002_String_Define.h
//  v002 String Tools
//
//  Created by vade on 1/27/15.
//  Copyright (c) 2015 v002. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "DictionaryKit.h"

@interface v002_String_Define : QCPlugIn
{
    @private
    TTTDictionary* currentDictionary;
}
@property (assign) NSUInteger inputDictionary;
@property (copy) NSString* inputString;
@property (copy) NSArray* outputDefintions;

@property (atomic, readwrite, retain) TTTDictionary* currentDictionary;



@end
