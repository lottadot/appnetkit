AppNetKit
=========

AppNetKit is an Objective-C library for communicating with the App.net Stream API. It is completely asynchronous, using blocks to notify you of completions.

AppNetKit covers the Token, Users, and Posts parts of the App.net API—all the portions available as of late August 2012.

Synopsis
------

    ANSession.defaultSession.accessToken = myOAuthToken;
    
    // Get the latest posts in the user's incoming post stream...
    [ANSession.defaultSession postsInStreamWithCompletion:^(NSArray * posts, NSError * error) {
        if(!posts) {
            [self showError:error];
            return;
        }
        
        // Grab the most recent post.
        ANPost * latestPost = posts[0];
        
        // Compose a reply...
        ANPost * newPost = [[ANPost alloc] initWithSession:ANSession.defaultSession];
        newPost.text = [NSString stringWithFormat:@"@%@ Me too!", latestPost.user.username];
        newPost.replyToID = latestPost.ID;
        
        // And post it.
        [newPost createWithCompletion:^(ANPost * post, NSError * error) {
            if(!post) {
                [self showError:error];
            }
        }];
    }];


Quick Tour
=========

ANAuthenticator
-------------

This is an OAuth helper singleton. Set the client ID and redirect URL, then use the other methods to help you generate OAuth URLs and parse out the accessToken from the response.

ANSession
--------

Basis of the API. Set the accessToken, then use the other methods to access parts of the API. +[ANSession defaultSession] is a convenience method for the common case where you're using only one session for the whole app; you can also allocate several different ANSessions and use them separately.

ANSession also manages UIApplication's network activity indicator. This should probably be configurable in various ways, not the least because it's the only way in which this library depends on iOS-specific APIs.

ANResource, ANUser, and ANPost
----------------------------

ANResource represents anything the server sends as a JSON object. ANUser and ANPost are subclasses for the Stream API's User and Post objects, respectively.

ANRequest and subclasses
---------------------

ANRequest subclasses represent specific API requests. You don't normally have to use them--ANSession has APIs for common requests--but they are public API, and using them directly can give you finer control than ANSession allows.

Author
======

Brent Royal-Gordon, Architechies <brent@architechies.com>.

Bugs
====

A lot of the code in this library has never actually been run as I write this, so it's likely to have plenty of bugs. If you want to write unit tests to exercise all this code, I'll be happy to pull them in. (Packaging this mess as an Xcode project might be a good idea, too...)

Also note that my own development is for iOS 6; I don't believe there are any iOS 6-only APIs in AppNetKit, but it's possible a call or two snuck in. Again, patches are welcome.

If you find a problem, file an issue or write a patch and send it to me (preferably as a pull request, but I'm not picky).

Copyright
========

(C) 2012 Architechies.

License is TBD, but probably something like MIT or new BSD. Feel free to use this in a commercial app; you won't have to open-source your own work.
