#MetaAnalysis
_KnownDbs_ grabs a list of databases found on the Wikimedia analytics slaves.

__Authors:__ Oliver Keyes<br> Yuvi Panda
__License:__ [MIT](http://opensource.org/licenses/MIT)<br>
__Status:__ Stable

##Contents
The folder contains two files:

* _KnownDbs.r_ is the generation script. It is dependent on (a) access to the analytics slaves and (b) the stated dependencies of the overall package
* _Databases.tsv_ is the output, and consists of a TSV containing the database name, the pertinent analytics slave, the language code for that database, the type of project (wikiquote, wikisource, etc), and, when available, an ISO-639-3-compatible human-readable name.

##Credit
@yuvipanda for making the regexes finally work, @Ironholds for everything else
