/*	
 * CCScreenshot.m
 *
 * Created by Oguzhan Gungor on 24/03/13.
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


+ (CCScreenshot *) sharedInstance {
    
    if (!sharedInstance) 
        sharedInstance = [[CCScreenshot alloc] init];
        
    return sharedInstance;
}



-(id) init {
    
	if( (self=[super init])) {
        self.lastscreenshot = [[[UIImage alloc] init] autorelease];
	}
	return self;
}



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


- (CCSprite *) takeScreenshotAsCCSprite {
    return [CCSprite spriteWithTexture: [self takeScreenshotAsCCTexture2D]];
}


- (CCTexture2D *) takeScreenshotAsCCTexture2D{
    
    CCTexture2D *texture; 
    
#if COCOS2D_VERSION >= 0x00020000
    ccResolutionType resolution;
    CGImageRef ref = [self takeScreenshotAsUIImage].CGImage;

    texture = [[[CCTexture2D alloc] initWithCGImage:ref resolutionType:resolution]autorelease];
#else
    texture = [[[CCTexture2D alloc] initWithImage:[self takeScreenshotAsUIImage] ] autorelease];
#endif
    
    return texture;
}




@end