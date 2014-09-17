//
//  CEMovieMaker.m
//  CEMovieMaker
//
//  Created by Cameron Ehrlich on 9/17/14.
//  Copyright (c) 2014 Cameron Ehrlich. All rights reserved.
//

#import "CEMovieMaker.h"

@implementation CEMovieMaker

- (instancetype)initWithSettings:(NSDictionary *)videoSettings;
{
    self = [self init];
    if (self) {
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/export.mov"];

        
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
            if (error) {
                NSLog(@"Error: %@", error.debugDescription);
            }
            NSLog(@"Removed file at fileURL");
        }
        
        _fileURL = [NSURL fileURLWithPath:tempPath];
        _assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL
                                                     fileType:AVFileTypeQuickTimeMovie error:&error];
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
        NSParameterAssert(self.assetWriter);
        
        _videoSettings = videoSettings;
        _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                               outputSettings:videoSettings];
        NSParameterAssert(self.writerInput);
        NSParameterAssert([self.assetWriter canAddInput:self.writerInput]);
        
        [self.assetWriter addInput:self.writerInput];
        
        NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        
        _bufferAdapter = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.writerInput sourcePixelBufferAttributes:bufferAttributes];
        _frameTime = CMTimeMake(1, 20);
    }
    return self;
}

- (void)createMovieFromImages:(NSArray *)images withCompletion:(CEMovieMakerCompletion)completion;
{
    self.completionBlock = completion;
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    buffer = [self newPixelBufferFromCGImage:[[images objectAtIndex:0] CGImage]];
    CVPixelBufferPoolCreatePixelBuffer (NULL, self.bufferAdapter.pixelBufferPool, &buffer);
    
    [self.bufferAdapter appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue =  dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 1;
    
    NSInteger frameNumber = [images count];
    __block BOOL success = YES;

    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i == frameNumber) {
                NSLog(@"Wrote final frame.");
                break;
            }
            if ([self.writerInput isReadyForMoreMediaData]) {
                
                CVPixelBufferRef sampleBuffer = [self newPixelBufferFromCGImage:[[images objectAtIndex:i] CGImage]];
                NSLog(@"inside for loop %ld",(long)i);
                
                CMTime lastTime = CMTimeMake(i, self.frameTime.timescale);
                
                CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                
                if (sampleBuffer) {
                    [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                    i++;
                    CFRelease(sampleBuffer);
                } else {
                    break;
                }
            }
        }

        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(success, self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    int frameWidth = [[self.videoSettings objectForKey:AVVideoWidthKey] intValue];
    int frameHeight = [[self.videoSettings objectForKey:AVVideoHeightKey] intValue];
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 4 * frameWidth,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withHeight:(int)height andWidth:(int)width
{
    NSDictionary *videoSettings = @{AVVideoCodecKey : AVVideoCodecH264,
                                    AVVideoWidthKey : @(width),
                                    AVVideoHeightKey : @(height)};
    
    return videoSettings;
}

@end
