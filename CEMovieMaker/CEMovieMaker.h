//
//  CEMovieMaker.h
//  CEMovieMaker
//
//  Created by Cameron Ehrlich on 9/17/14.
//  Copyright (c) 2014 Cameron Ehrlich. All rights reserved.
//

@import AVFoundation;
@import Foundation;
@import UIKit;

typedef void(^CEMovieMakerCompletion)(NSURL *fileURL);

@interface CEMovieMaker : NSObject

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *bufferAdapter;
@property (nonatomic, strong) NSDictionary *videoSettings;
@property (nonatomic, assign) CMTime frameTime;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) CEMovieMakerCompletion completionBlock;

- (instancetype)initWithSettings:(NSDictionary *)videoSettings;
- (void)createMovieFromImages:(NSArray *)images withCompletion:(CEMovieMakerCompletion)completion;

+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
