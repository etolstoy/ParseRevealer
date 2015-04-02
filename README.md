# ParseRevealer

**Parse Revealer** is a pentesting utility for Mac OS X that helps with analysis of [Parse] account used in an application under test. More info on attacking Parse is available in this [article].

![App screenshot](http://habrastorage.org/files/cb5/e53/478/cb5e534788e145188a96cca09fdeecd1.png)

It has the following capabilities at the moment:
- Validity checking of Parse Application ID and Client Key.
- Getting the list of access permissions for custom Parse classes.

**WARNING:** Parse Revealer can leave a trace in Parse classes - it adds new fields and objects when testing the corresponding permissions, so be careful.

### Installation
The installation is simple - build and run the application in XCode.

### Version
0.1

### Todo's
- Show full structure of custom classes,
- Browse through objects in a specified class,
- Create, update and delete objects in a specified class.

[Parse]:http://parse.com
[article]:http://highaltitudehacks.com/2015/01/24/ios-application-security-part-38-attacking-apps-using-parse/
