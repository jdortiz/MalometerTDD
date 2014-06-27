//
//  FreakType+Model.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 27/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType.h"


extern NSString *const freakTypeEntityName;


@interface FreakType (Model)

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (FreakType *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;

@end
