# ParseRevealer

**Parse Revealer** is a pentesting utility for Mac OS X that helps with analysis of [Parse] account used in an application under test. More info on attacking Parse is available in this [article] ([russian version]).

It has the following capabilities at the moment:
- Validity checking of Parse Application ID and Client Key.
- Getting the list of access permissions for custom Parse classes.
- Revealing the structure of custom Parse classes with 'Find' permission set to 'YES',
- Exporting all the revealed data to .txt.

**WARNING:** Parse Revealer can leave a trace in Parse classes - it adds new fields and objects when testing the corresponding permissions, so be careful.

### Installation
The installation is simple - build and run the application in Xcode.

### Usage
1. Enter the **applicationId and clientKey** derived from the target app.
2. Enter **the names of Parse classes**, also derived from the target, and click 'Save'.
![Basic Setup](http://habrastorage.org/files/971/b3d/809/971b3d809f2c4f7b8fb259c1b69b8f71.png)
3. Go to the 'ACL Revealing' tab and **click 'Reveal'**. After a few seconds you'll see the list of access permissions for all saved classes.
![ACL Revealing](http://habrastorage.org/files/054/6da/28c/0546da28c26c41d78c3ef4e701cec870.png)
4. Go to the 'Structure Revealing' tab, also **click 'Reveal'**, and enjoy the structure of your classes.
![Structure Revealing](http://habrastorage.org/files/9ea/766/853/9ea766853a9c41b8b5c607e70f39c0d3.png)
5. On the last tab you can **export all the revealed data** to *txt* format.
![Export](http://habrastorage.org/files/df2/fd5/20c/df2fd520c487443697ad11d5fcdf09d4.png)

### Version
0.2

### Author
[Egor Tolstoy] - [@igrekde].

### License
*ParseRevealer* is available under the MIT license. See the LICENSE file for more info.

### Todo's
- Browse through objects in a specified class,
- Create, update and delete objects in a specified class,
- Dump all the classes to different file formats,
- Stable work with objects-defined ACLs.

[Parse]:http://parse.com
[article]:http://highaltitudehacks.com/2015/01/24/ios-application-security-part-38-attacking-apps-using-parse/
[russian version]:http://etolstoy.ru/parse-ios-security/
[Egor Tolstoy]:http://etolstoy.ru
[@igrekde]:http://twitter.com/igrekde