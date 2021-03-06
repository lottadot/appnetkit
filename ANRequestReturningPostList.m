//
//  ANRequestReturningPostList.m
//  AppNetKit
//
//  Created by Brent Royal-Gordon on 8/19/12.
//  Copyright (c) 2012 Architechies. All rights reserved.
//

#import "ANRequestReturningPostList.h"

@implementation ANRequestReturningPostList

- (id)initWithSession:(ANSession *)session {
    if((self = [super initWithSession:session])) {
        _sinceID = ANUnspecifiedPostID;
        _beforeID = ANUnspecifiedPostID;
        _count = 0;
        _includeUser = YES;
        _includeAnnotations = YES;
        _includeReplies = YES;
    }
    
    return self;
}

- (NSString*)stringForBoolean:(BOOL)boolean {
    return boolean ? @"True" : @"False";
}

- (NSDictionary *)parameters {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [self stringForBoolean:self.includeUser], @"include_user",
                                    [self stringForBoolean:self.includeAnnotations], @"include_annotations",
                                    [self stringForBoolean:self.includeReplies], @"include_replies",
                                    nil];
    
    if(self.count) {
        [params setObject:[NSString stringWithFormat:@"%d", self.count] forKey:@"count"];
    }
    if(self.beforeID) {
        [params setObject:[NSString stringWithFormat:@"%lld", self.beforeID] forKey:@"before_id"];
    }
    if(self.sinceID) {
        [params setObject:[NSString stringWithFormat:@"%lld", self.sinceID] forKey:@"since_id"];
    }
    
    return params.copy;
}

- (ANRequestMethod)method {
    return ANRequestMethodGet;
}

- (void)sendRequestWithCompletion:(ANPostListRequestCompletion)completion {
    [self sendRequestWithRepresentationCompletion:^(id rep, NSError *error) {
        [self.session completePostListRequest:completion withRepresentation:rep error:error];
    }];
}

@end
