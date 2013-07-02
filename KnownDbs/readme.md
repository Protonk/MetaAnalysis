#MetaAnalysis
_KnownDbs_ grabs a list of databases found on the Wikimedia analytics slaves.

__Author:__ Oliver Keyes<br>
__License:__ [MIT](http://opensource.org/licenses/MIT)<br>
__Status:__ Under development

##Contents
The folder contains two files:

* _KnownDbs.r_ is the generation script. It is dependent on (a) access to the analytics slaves and (b) the stated dependencies of the overall package
* _Databases.tsv_ is the output, and consists of a TSV containing the database name, the pertinent slave, the language code for that database, and the type of project (wikiquote, wikisource, etc).

##Caveats/To-do

* There is some degree of duplication, because for Lloyd-knows what reason we have totally empty information schemas sitting on some dbs. Check out the arwiki instances, for example.
* The eventual plan is to pull in ISO-639-3 codes and provide human-readable names. This - matching across two dataframes of unequal length to pull out the contents of a third vector - is proving infuriatingly tricky.
