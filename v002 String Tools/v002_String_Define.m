//
//  v002_String_Define.m
//  v002 String Tools
//
//  Created by vade on 1/27/15.
//  Copyright (c) 2015 v002. All rights reserved.
//

#import "v002_String_Define.h"

#define	kQCPlugIn_Name				@"v002 String Define"
#define	kQCPlugIn_Description		@"v002 String Define Description"
#define	kQCPlugIn_Category          [NSArray arrayWithObject:@"v002"]

@implementation v002_String_Define

@dynamic inputDictionary;
@dynamic inputString;
@dynamic outputDefintions;

@synthesize currentDictionary;

+ (NSDictionary*) attributes
{
    return @{QCPlugInAttributeNameKey: kQCPlugIn_Name,
             QCPlugInAttributeDescriptionKey: kQCPlugIn_Description,
             @"categories": kQCPlugIn_Category};
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
    NSArray* availableDictionaries = [TTTDictionary availableDictionaries];

    NSMutableArray* dictNames = [[NSMutableArray new] autorelease];
    for(TTTDictionary* entry in availableDictionaries)
    {
        [dictNames addObject:entry.name];
    }
    
    if([key isEqualToString:@"inputDictionary"])
    {
        return @{QCPortAttributeMenuItemsKey : dictNames,
                 QCPortAttributeMinimumValueKey : @(0),
                 QCPortAttributeMaximumValueKey : @(dictNames.count - 1),
                 QCPortAttributeDefaultValueKey : @(0),
                 QCPortAttributeNameKey: @"Dictionary"};
    }

    if([key isEqualToString:@"inputString"])
    {
        return @{QCPortAttributeNameKey: @"String"};
    }

    if([key isEqualToString:@"outputDefintions"])
    {
        return @{QCPortAttributeNameKey: @"Definitions"};
    }
    
    return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
    return @[@"inputDictionary",
             @"inputString",
             @"outputDefinitions"
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
    [super dealloc];
}

@end

@implementation v002_String_Define (Execution)

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
    if([self didValueForInputKeyChange:@"inputDictionary"]
       || [self didValueForInputKeyChange:@"inputString"])
    {
        // get the TTT Dictionary for the index
        NSArray* availableDictionaries = [TTTDictionary availableDictionaries];
        
        self.currentDictionary = [availableDictionaries objectAtIndex:self.inputDictionary];
        
        NSArray* entries = [self.currentDictionary entriesForSearchTerm:self.inputString];
        
        NSMutableArray* array = [[NSMutableArray new] autorelease];
        
        for(TTTDictionaryEntry* entry in entries)
        {
            [array addObject:entry.text];
        }
        
        self.outputDefintions = array;
        
//        self.outputSting = DCSCopyTextDefinition(NULL, (CFStringRef)self.inputString, NSMakeRange(0, self.inputString.length -1));
    }
    
    return YES;
}

@end
