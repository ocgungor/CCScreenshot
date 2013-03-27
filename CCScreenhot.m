/*	
 * CCScreenshot.m
 *
 * Created by Oguzhan Cansin Gungor on 24/03/13.
 *
 * Copyright (c) 2013 Aslan-Apps. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *       This product includes software developed by Aslan-Apps.
 * 4. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <AssetsLibrary/AssetsLibrary.h>
#import "CCScreenshot.h"


@implementation CCScreenshot

@synthesize lastscreenshot;

static CCScreenshot *sharedInstance = nil;


+ (CCScreenshot *) screenshot {
    
    if (!sharedInstance) 
        sharedInstance = [[CCScreenshot alloc] init];
        
    return sharedInstance;
}



-(id) init {
    
	if( (self=[super init])) {
#if __has_feature(objc_arc) && __clang_major__ >= 3
        self.lastscreenshot = [[UIImage alloc] init];
#else
        self.lastscreenshot = [[[UIImage alloc] init] autorelease];
#endif
	}
	return self;
}


/*
- (UIImage*) takeScreenshotAsUIImage {

    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:[CCDirector sharedDirector].winSize.width
                                                            height:[CCDirector sharedDirector].winSize.height];
    
    [rtx begin];
    [[[[[CCDirector sharedDirector] runningScene] children] objectAtIndex:0] visit];
    [rtx end];
    
#if COCOS2D_VERSION >= 0x00020000
    self.lastscreenshot = [rtx getUIImage];
#else
    self.lastscreenshot = [rtx getUIImageFromBuffer];
#endif
    
    return self.lastscreenshot;

}
 
 */
- (UIImage*) takeScreenshotAsUIImage {
    
   

    
    
    UIView * eagleView;
  
#if COCOS2D_VERSION >= 0x00020000
    eagleView = (UIView*)[[CCDirector sharedDirector] view];
#else
    eagleView = (UIView*)[[CCDirector sharedDirector] openGLView];
#endif
    
	GLint backingWidth, backingHeight;

	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
	NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
	NSInteger dataLength = width * height * 4;
	GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
	glPixelStorei(GL_PACK_ALIGNMENT, 4);
	glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);

	CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGImageRef iref = CGImageCreate (
                                     width,
                                     height,
                                     8,
                                     32,
                                     width * 4,
                                     colorspace,
                                     kCGBitmapByteOrderDefault,
                                     ref,
                                     NULL,
                                     true,
                                     kCGRenderingIntentDefault
                                     );
    

	NSInteger widthInPoints, heightInPoints;
	if (NULL != UIGraphicsBeginImageContextWithOptions)
	{
		CGFloat scale = eagleView.contentScaleFactor;
		widthInPoints = width / scale;
		heightInPoints = height / scale;
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
	}
    
	CGContextRef cgcontext = UIGraphicsGetCurrentContext();

	CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
	CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	// Clean up
	free(data);
	CFRelease(ref);
	CFRelease(colorspace);
	CGImageRelease(iref);
    
    
    return image;
}


- (CCSprite *) takeScreenshotAsCCSprite {
    return [CCSprite spriteWithTexture: [self takeScreenshotAsCCTexture2D]];
}


- (CCTexture2D *) takeScreenshotAsCCTexture2D{
    
    CCTexture2D *texture; 
    
#if COCOS2D_VERSION >= 0x00020000
    ccResolutionType resolution;
    CGImageRef ref = [self takeScreenshotAsUIImage].CGImage;

    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution];
    #else
        texture = [[[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution] autorelease];
    #endif
#else
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImage] ];
    #else
        texture = [[[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImage] ] autorelease];
    #endif
#endif
    
    return texture;
}



- (UIImage *)create3DImageWithText:(NSString *)_text
                              Font:(UIFont*)_font
                   ForegroundColor:(UIColor*)_foregroundColor
                       ShadowColor:(UIColor*)_shadowColor
                      outlineColor:(UIColor*)_outlineColor
                             depth:(int)_depth {
    
    CGSize expectedSize = [_text sizeWithFont:_font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    expectedSize.height+=_depth+5;
    expectedSize.width+=_depth+5;
    
    UIColor *_newColor;
    
    UIGraphicsBeginImageContextWithOptions(expectedSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *_colorsArray = [[NSMutableArray alloc] initWithCapacity:_depth];
    
    CGFloat *components =  (CGFloat *)CGColorGetComponents(_foregroundColor.CGColor);
    
    [_colorsArray insertObject:_foregroundColor atIndex:0];
    
    int _colorStepSize = floor(100/_depth);
    
    for (int i=0; i<_depth; i++) {
        
        for (int k=0; k<3; k++) {
            if (components[k]>(_colorStepSize/255.f)) {
                components[k]-=(_colorStepSize/255.f);
            }
        }
        _newColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:CGColorGetAlpha(_foregroundColor.CGColor)];
        
        [_colorsArray insertObject:_newColor atIndex:0];
    }
    
    for (int i=0; i<_depth; i++) {
        
        _newColor = (UIColor*)[_colorsArray objectAtIndex:i];
        
        CGContextSaveGState(context);
        
        CGContextSetShouldAntialias(context, YES);
        
        if (i+1==_depth) {
            CGContextSetLineWidth(context, 1);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            
            CGContextSetTextDrawingMode(context, kCGTextStroke);
            [_outlineColor set];
            [_text drawAtPoint:CGPointMake(i, i) withFont:_font];
        }
        
        [_newColor set];
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        if (i==0) {
            CGContextSetShadowWithColor(context, CGSizeMake(-2, -2), 4.0f, _shadowColor.CGColor);
        }
        else if (i+1!=_depth){
            CGContextSetShadowWithColor(context, CGSizeMake(-1, -1), 3.0f, _newColor.CGColor);
        }
        
        [_text drawAtPoint:CGPointMake(i, i) withFont:_font];
        CGContextRestoreGState(context);
    }
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/3 ));

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#if __has_feature(objc_arc) && __clang_major__ >= 3
#else
    [_colorsArray release];
#endif
    return finalImage;
}

- (UIImage *)rotate:(UIImage *)image radians:(float)rads
{
    CGImageRef imgRef = image.CGImage;
    

    
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, rads);
    CGContextDrawImage(ctx, (CGRect){{}, size}, imgRef);
    
    UIImage *imagea = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imagea;
}

- (UIImage *) takeScreenshotAsUIImageWith3DText:(NSString *) text
                                   withFontName:(NSString *) fontName
                                   withFontSize:(int) fontSize
                           withForeGroundColour:(UIColor *) foregroundColour
                               withShadowColour:(UIColor *) shadowColour
                              withOutlineColour:(UIColor *) outlineColour
                                      withDepth:(int) depth
                                   withPosition:(CGPoint) position {
    UIImage *image = [self takeScreenshotAsUIImage];
    
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext(size);
    
    CGPoint thumbPoint = CGPointMake(0, 0);
    [image drawAtPoint:thumbPoint];
    UIImage* starred = [self create3DImageWithText:text
                                              Font:[UIFont fontWithName:fontName size: (CC_CONTENT_SCALE_FACTOR() == 2) ? fontSize * 2 : fontSize]
                                   ForegroundColor:foregroundColour
                                       ShadowColor:shadowColour
                                      outlineColor:outlineColour
                                             depth:depth];
    

        
    [starred drawAtPoint:position];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
#if __has_feature(objc_arc) && __clang_major__ >= 3
    self.lastscreenshot = result;
#else
    self.lastscreenshot = [result retain];
#endif
    return self.lastscreenshot;
}




- (CCSprite *) takeScreenshotAsCCSpriteWith3DText:(NSString *) title
                                     withFontName:(NSString *) fontName
                                     withFontSize:(int) fontSize
                             withForeGroundColour:(UIColor *) foregroundColour
                                 withShadowColour:(UIColor *) shadowColour
                                withOutlineColour:(UIColor *) outlineColour
                                        withDepth:(int) depth
                                     withPosition:(CGPoint) position{
    
    return [CCSprite spriteWithTexture: [self takeScreenshotAsCCTexture2DWith3DText:title
                                                                       withFontName:fontName
                                                                       withFontSize:fontSize
                                                               withForeGroundColour:foregroundColour
                                                                   withShadowColour:shadowColour
                                                                  withOutlineColour:outlineColour
                                                                          withDepth:depth
                                                                       withPosition:position]];

    
}



- (CCTexture2D *) takeScreenshotAsCCTexture2DWith3DText:(NSString *) title
                                           withFontName:(NSString *) fontName
                                           withFontSize:(int) fontSize
                                   withForeGroundColour:(UIColor *) foregroundColour
                                       withShadowColour:(UIColor *) shadowColour
                                      withOutlineColour:(UIColor *) outlineColour
                                              withDepth:(int) depth
                                           withPosition:(CGPoint) position {
    
    CCTexture2D *texture;
    
#if COCOS2D_VERSION >= 0x00020000
    ccResolutionType resolution;
    CGImageRef ref = [self takeScreenshotAsUIImageWith3DText:title
                                                withFontName:fontName
                                                withFontSize:fontSize
                                        withForeGroundColour:foregroundColour
                                            withShadowColour:shadowColour
                                           withOutlineColour:outlineColour
                                                   withDepth:depth
                                                withPosition:position].CGImage;
    
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution];
    #else
        texture = [[[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution] autorelease];
    #endif
    
    
#else
    
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImageWith3DText:title
                                                                             withFontName:fontName
                                                                             withFontSize:fontSize
                                                                     withForeGroundColour:foregroundColour
                                                                         withShadowColour:shadowColour
                                                                        withOutlineColour:outlineColour
                                                                                withDepth:depth
                                                                             withPosition:position]];
    #else
        texture = [[[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImageWith3DText:title
                                                                             withFontName:fontName
                                                                             withFontSize:fontSize
                                                                     withForeGroundColour:foregroundColour
                                                                         withShadowColour:shadowColour
                                                                        withOutlineColour:outlineColour
                                                                                withDepth:depth
                                                                             withPosition:position]] autorelease];
    #endif
    
#endif
    
    return texture;
}









- (UIImage *)takeScreenshotAsUIImageWith2DText: (NSString *)text fontName:(NSString*) fontName fontSize:(int) fontSize withRed:(int) red withGreen:(int) green withBlue:(int) blue withPosition:(CGPoint) position
{
    
    UIImage *img = [self takeScreenshotAsUIImage];
    
    int w = img.size.width;
    int h = img.size.height;
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 255.0, 0.0, 1.0, 1);
    
    char* ptext	= (char *)[text cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, (const char*)[fontName UTF8String], fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, red, green, blue, 1);
    
    
    CGContextShowTextAtPoint(context, position.x, position.y, ptext, strlen(ptext));
    
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    self.lastscreenshot = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return self.lastscreenshot;
}


- (CCSprite *)takeScreenshotAsCCSpriteWith2DText:(NSString *)text
                                        fontName:(NSString*) fontName
                                        fontSize:(int) fontSize
                                         withRed:(int) red
                                       withGreen:(int) green
                                        withBlue:(int) blue
                                    withPosition:(CGPoint) position {
    
    return [CCSprite spriteWithTexture: [self takeScreenshotAsCCTexture2DWith2DText:text
                                                                       fontName:fontName
                                                                       fontSize:fontSize
                                                                        withRed:red
                                                                      withGreen:green
                                                                       withBlue:blue
                                                                       withPosition:position]];

    
    
}
- (CCTexture2D *)takeScreenshotAsCCTexture2DWith2DText:(NSString *)text
                                              fontName:(NSString*) fontName
                                              fontSize:(int) fontSize
                                               withRed:(int) red
                                             withGreen:(int) green
                                              withBlue:(int) blue
                                          withPosition:(CGPoint) position{
    
    CCTexture2D *texture;
    
#if COCOS2D_VERSION >= 0x00020000
    ccResolutionType resolution;
    CGImageRef ref = [self takeScreenshotAsUIImageWith2DText:text
                                                    fontName:fontName
                                                    fontSize:fontSize
                                                     withRed:red
                                                   withGreen:green
                                                    withBlue:blue
                                                withPosition:position].CGImage;
    
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution];

    #else
        texture = [[[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution] autorelease];
    #endif
    
#else
    
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        texture = [[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImageWith2DText:text
                                                                                 fontName:fontName
                                                                                 fontSize:fontSize
                                                                                  withRed:red
                                                                                withGreen:green
                                                                                 withBlue:blue
                                                                             withPosition:position]];
    
    #else
        texture = [[[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImageWith2DText:text
                                                                                 fontName:fontName
                                                                                 fontSize:fontSize
                                                                                  withRed:red
                                                                                withGreen:green
                                                                                 withBlue:blue
                                                                             withPosition:position]] autorelease];
    #endif
    
#endif
    
    return texture;
}





- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message {
    
	UIAlertView* alert= [[UIAlertView alloc] initWithTitle: title message: message
                                                   delegate: nil
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
	[alert show];
#if __has_feature(objc_arc) && __clang_major__ >= 3
    
#else
    [alert release];
#endif
}

- (void) saveScreenshotToCameraRoll {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageWriteToSavedPhotosAlbum(self.lastscreenshot, self, nil, nil);

        
        /*
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageToSavedPhotosAlbum:[self.lastscreenshot CGImage]
                                  orientation:(ALAssetOrientation)[self.lastscreenshot imageOrientation]
                              completionBlock:^(NSURL *assetURL, NSError *error){
                                  if (error)
                                      [self showAlertWithTitle:@"Error!" message:error.localizedDescription];
                                  else
                                      [self showAlertWithTitle:title message:message];
                                  
                              }];
        
#if __has_feature(objc_arc) && __clang_major__ >= 3
        
#else
        [library release];
#endif
        */
    });
}



- (void) dealloc {
#if __has_feature(objc_arc) && __clang_major__ >= 3

#else
    [super dealloc];
#endif
}


@end