//
//  AnalysisArsc.h
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

#import <Foundation/Foundation.h>

@interface AnalysisArsc: NSObject

- (nonnull instancetype)initWithFile: (NSURL *_Nonnull)url;

- (NSArray<NSString *> *_Nonnull)valueForKey: (NSString *_Nonnull)key;

@end
