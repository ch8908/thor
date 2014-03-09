//
//  NSArray+Util.m
//  nemo
//
//  Created by liq on 11/9/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@implementation NSArray(NSArray_Util)

/**
 * return an NSMutableArray
 */
- (NSArray*) map:(id (^)(id obj, NSUInteger index)) mapper
{
    NSMutableArray* mapped = [NSMutableArray arrayWithCapacity:self.count];

    for (int i = 0; i < self.count; i++)
    {
        [mapped addObject:mapper([self objectAtIndex:i], i)];
    }
    return mapped;
}

- (NSArray* /*Array of Array*/) partition:(NSUInteger) count
{
    NSMutableArray* partitions = [NSMutableArray array];

    NSMutableArray* sub = [NSMutableArray array];
    [partitions addObject:sub];
    for (id item in self)
    {
        [sub addObject:item];
        if (sub.count == count)
        {
            sub = [NSMutableArray array];
            [partitions addObject:sub];
        }
    }
    return partitions;
}


- (NSArray*) filter:(BOOL (^)(id obj, NSUInteger index)) predicate
{
    NSIndexSet* matched = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return predicate(obj, idx);
    }];

    return [self objectsAtIndexes:matched];
}

- (void) forEach:(void (^)(id obj, NSUInteger index)) onElement
{
    for (int i = 0; i < self.count; i++)
    {
        onElement([self objectAtIndex:i], i);
    }
}

- (id) findFirst:(BOOL (^)(id obj, NSUInteger index)) predicate
{
    NSIndexSet* matched = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        BOOL found = predicate(obj, idx);
        if (found)
        {
            *stop = YES;
        }
        return found;
    }];

    if (matched.count == 0)
    {
        return nil;
    }
    return [self objectAtIndex:matched.firstIndex];
}

- (NSArray*) orderByAnotherArray:(NSArray*) baseArray
{
    NSMutableArray* result = [NSMutableArray array];

    [baseArray forEach:^(id baseElement, NSUInteger index) {
        id found = [self findFirst:^BOOL(id obj, NSUInteger subIndex) {
            return [obj isEqual:baseElement];
        }];

        if (found)
        {
            [result addObject:found];
        }
    }];

    NSArray* deferResult = [self filter:^BOOL(id obj, NSUInteger index) {
        return ![baseArray containsObject:obj];
    }];

    return [result arrayByAddingObjectsFromArray:deferResult];
}

@end

@implementation NSMutableArray(NSArray_Util)

- (void) nm_reverse
{
    const NSUInteger arrayCount = [self count];
    if (arrayCount == 0 || arrayCount == 1)
    {
        return;
    }
    NSInteger i = 0;
    NSInteger j = arrayCount - 1;
    while (i < j)
    {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];

        i++;
        j--;
    }
}

- (void) nm_shuffle
{
    static BOOL seeded = NO;
    if (!seeded)
    {
        seeded = YES;
        srandom((unsigned int) time(NULL));
    }

    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
