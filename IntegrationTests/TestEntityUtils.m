//
//  TestSZEntityUtils.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/7/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import "TestEntityUtils.h"

@implementation TestEntityUtils

- (void)testEntityWrappers {
    NSString *entityKey = [self testURL:[NSString stringWithFormat:@"%s/entity_target", sel_getName(_cmd)]];
    SZEntity *entity = [SZEntity entityWithKey:entityKey name:@"Entity target"];
    NSString *testType = @"testType";
    entity.type = testType;
    
    // Add entity
    id<SZEntity> createdEntity = [self addEntity:entity];
    
    GHAssertEqualStrings([createdEntity type], testType, @"Bad type");
    
    // Get entities (app-wide)
    NSArray *entities = [self getEntities];
    [self assertObject:createdEntity inCollection:entities];

    // Get entities (app-wide)
    entities = [self getEntitiesWithSorting:SZResultSortingPopularity];
    GHAssertNotNil(entities, @"Should have found popular entities");

    // Get entities (by id)
    entities = [self getEntitiesWithIds:[NSArray arrayWithObject:[NSNumber numberWithInteger:[createdEntity objectID]]]];
    [self assertObject:createdEntity inCollection:entities];

    // Get entity (specifically, by key)
    id<SZEntity> fetchedEntity = [self getEntityWithKey:entityKey];
    GHAssertEquals([fetchedEntity objectID], [createdEntity objectID], @"Bad id");
}

@end
