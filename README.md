CEMovieMaker
============

CEMovieMaker is a quick and dirty way to create a movie from and array of UIImages.

Usage:

```objective-c
@interface ViewController ()

@property (nonatomic, strong) CEMovieMaker *movieMaker;

@end

- (IBAction)process:(id)sender
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    UIImage *icon1 = [UIImage imageNamed:@"icon1"];
    UIImage *icon2 = [UIImage imageNamed:@"icon2"];
    UIImage *icon3 = [UIImage imageNamed:@"icon3"];
    
    NSDictionary *settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecH264 withHeight:icon1.size.width andWidth:icon1.size.height];
    self.movieMaker = [[CEMovieMaker alloc] initWithSettings:settings];
    for (NSInteger i = 0; i < 10; i++) {
        [frames addObject:icon1];
        [frames addObject:icon2];
        [frames addObject:icon3];
    }

    [self.movieMaker createMovieFromImages:[frames copy] withCompletion:^(BOOL success, NSURL *fileURL){
        if (success) {
            [self viewMovieAtUrl:fileURL];
        }
    }];
}

- (void)viewMovieAtUrl:(NSURL *)fileURL
{
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [playerController.view setFrame:self.view.bounds];
    [self presentMoviePlayerViewControllerAnimated:playerController];
    [playerController.moviePlayer prepareToPlay];
    [playerController.moviePlayer play];
    [self.view addSubview:playerController.view];
}
```
