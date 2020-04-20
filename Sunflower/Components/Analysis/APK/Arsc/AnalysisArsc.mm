//
//  AnalysisArsc.m
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

#import "AnalysisArsc.h"
#include "ResourcesParser.hpp"
#include "ResourcesParserInterpreter.hpp"

@implementation AnalysisArsc
{
    NSURL *url;
}

- (instancetype)initWithFile: (NSURL *)url {
    self = [super init];
    if (self) {
        self->url = url;
    }
    return self;
}

- (NSArray<NSString *> *)valueForKey: (NSString *)key {
    ResourcesParser parser = ResourcesParser([url.path UTF8String]);
    ResourcesParserInterpreter interpreter = ResourcesParserInterpreter(&parser);
    std::vector<std::string> vector = interpreter.getParserStringValue([key UTF8String]);
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < vector.size(); i++) {
        NSString *string = [NSString stringWithUTF8String:vector[i].c_str()];
        if (![string isEqualToString:@""]) {
            [array addObject:string];
        }
    }
    return array.copy;
}

@end
