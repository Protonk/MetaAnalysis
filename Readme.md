#MetaAnalysis
_MetaAnalysis_ is a set of R scripts that can be run over the Wikimedia servers (with some caveats - see "Dependencies", below). Rather than being aimed at deep analysis of a single project, it provides a shallow overview of many projects simultaneously.

Interesting things found using the MetaAnalysis scripts will usually be posted on [my blog](https://blog.ironholds.org) ; if you spot a bug or have any suggestions, drop me a line.

__Author:__ Oliver Keyes<br>
__License:__ [MIT](http://opensource.org/licenses/MIT)<br>
__Status:__ In development

##Contents
At the moment, MetaAnalysis contains 3 components, all still being worked on. Both of these clauses will change. These are:

* _KnownDbs_: a script to retrieve a list of databases from the analytics slaves and match them with the pertinent slave - having a reliable way of doing this is pretty much key to automated multi-project analysis. It also extracts the type of project (wikipedia, wikiquote, wikisource), the language prefix, and matches the language prefix to the ISO-639-3 equivalent to produce human-readable names for each language. Output can be seen in the KnownDbs folder.
* _ProjectActivity_, which pulls in the output of _KnownDbs_ and uses it to get a high-level overview of the activity levels on different projects.
* _GadgetUsage_, which [Greg](https://twitter.com/g_gerg) got me to write. Pulls out oodles of data on gadget usage on different wikiprojects.

##Dependencies
The biggest one is access to the Wikimedia analytics slaves - if you don't have that, this project is unlikely to be helpful to you unless you have a particular fondness for stealing my terrible, terrible code. MetaAnalysis scripts are also dependent on several R packages, specifically:

* [Plyr](https://plyr.had.co.nz/)
* [ggplot2](https://ggplot2.org/)
