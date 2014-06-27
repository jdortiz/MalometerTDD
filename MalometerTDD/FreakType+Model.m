//
//  FreakType+Model.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 27/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType+Model.h"


NSString *const freakTypeEntityName = @"FreakType";


@implementation FreakType (Model)

#pragma mark - Convenience constructor

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:freakTypeEntityName
                                         inManagedObjectContext:moc];
    freakType.name = name;
    return freakType;
}

@end
