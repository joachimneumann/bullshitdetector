## preparation
In XCode: create scheme "CI" for release
see if this works:
xcodebuild -project bullshit\ detector.xcodeproj -scheme "CI" -sdk iphonesimulator clean analyze
xcodebuild -scheme CI -project bullshit\ detector.xcodeproj build


xcodebuild  -project bullshit\ detector.xcodeproj \
            -scheme CI \
            -destination "platform=iOS Simulator,OS=12.1,name=iPhone 8"

xcodebuild -project bullshit\ detector.xcodeproj \
           -scheme CI \
           -sdk iphoneos \
           -configuration AppStoreDistribution archive \
           -archivePath $PWD/build/CLI.xcarchive

## Apple Worldwide Developer Relations Certification Authority
Download from:
https://developer.apple.com/certificationauthority/AppleWWDRCA.cer

I am using `https://travis-ci.com` --> add `--com` to the commands

`travis login --com` (use github username and password + 2fa)

cd into project folder (with .travis.yml file)
`travis encrypt "APPLE_SIGNING_PASSWORD={YOUR_PASSWORD_HERE}" -add --com`
This added to `.travis.yml`:
```
dd:
  secure: bE.....
```

In your repository at https://travis-ci.com go the the repository settings and
add an Environment Variable for testing (with `display value in build logs`)
APPLE_PASSWORD with value my_apple_password
Then add `; echo $APPLE_PASSWORD` to the script in `.travis.yml`.

Then commit and push, wait for the logs and meke sure you can see `my_apple_password` in the build logs
