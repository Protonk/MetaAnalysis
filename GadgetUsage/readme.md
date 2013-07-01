#MetaAnalysis
_GadgetUsage_ is a script to yank data around gadgets being used on various wikimedia projects, via the user_properties table.

__Author:__ Oliver Keyes<br>
__License:__ [MIT](http://opensource.org/licenses/MIT)<br>
__Status:__ Stable

##Contents
The folder contains four files:

* _GadgetUsage.r_ is the generation script. It is dependent on (a) access to the analytics slaves and (b) the [list of databases](https://github.com/Ironholds/MetaAnalysis/tree/master/KnownDbs)
* _gadget_data.tsv_ is the raw data, consisting of an aggregate number of users for each preference on each wiki, with preference, wiki and wiki type (source, wiki, versity, etc) defined.
* _gadgets_by_wikis.tsv_ is a rework of the data to look at what gadgets are used on multiple wikis, and how many wikis that is. It also includes an aggregate of the number of users across those wikis using the gadget.
* _wikis_by_gadgets.tsv_ is a rework that looks at the number of distinct gadgets on each individual wiki. Unsuprisingly there's a power law.

##Caveats

* This is based on preference data - it may or may not include data for those gadgets set as defaults.
* Similarly, if in some weird bizzarro universe a gadget is set to multiple preference values, it'll appear twice.
* Until SUL finalisation is finished there's no way to distinguish user and user instance. UserA, who has a preference enabled on arwiki and afwiki, appears as 2 users.

