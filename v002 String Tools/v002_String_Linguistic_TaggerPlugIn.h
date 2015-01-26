//
//  v002_String_Linguistic_Tagger.h
//  v002 String Markov Generator
//
//  Created by vade on 7/14/13.
//  Copyright (c) 2013 v002. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface v002_String_Linguistic_TaggerPlugIn : QCPlugIn
{
	NSLinguisticTagger* linguisticTagger;
	NSLinguisticTaggerOptions linguisticOptions;
}

@property (atomic, readwrite, strong) NSLinguisticTagger* linguisticTagger;
@property (atomic, readwrite, assign) NSLinguisticTaggerOptions linguisticOptions;


@property (copy) NSString* inputString;

@property (copy) NSArray* outputNames;
@property (copy) NSArray* outputPlaces;
@property (copy) NSArray* outputOrganizations;

@property (copy) NSArray* outputNouns;
@property (copy) NSArray* outputVerbs;
@property (copy) NSArray* outputAdjectives;
@property (copy) NSArray* outputAdverbs;
@property (copy) NSArray* outputPronouns;
@property (copy) NSArray* outputParticles;



@end
