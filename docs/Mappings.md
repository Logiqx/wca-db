# Mapping User ID to WCA ID

## Background

It can sometimes be useful to know the link between user IDs and WCA IDs, even for people who have yet to officially "claim" their WCA ID. This can be determined through a number of implicit links, such as via competition registrations and competition results.

One example is if you wish to identify when or where friends / acquaintances are next due to complete.

Another possible official use is it to identify potential duplicate WCA IDs due to them being associated with the same user ID.




## Approach

Five steps identify specific types of link between user accounts and WCA profiles:

1. Claimed WCA ID - confirmed by delegate
2. Competition registrations - associated competition results can be linked back to WCA profiles
3. Claimed WCA ID - not yet confirmed by delegate
4. Name matches - country specific
5. Name matches - worldwide

The ID(s) discovered by the earlier steps take precedence over the later steps although all findings are recorded since they can still be useful.

Figures in this document were accurate as of mid-June 2019.



## Steps

### 1. Claimed WCA ID (confirmed by delegate)

~51,500 of the ~129,500 WCA IDs have been claimed by a user account.

This is the most straightforward type of link - "users.wca_id" contains the claimed WCA ID.

It is worth noting that no two user accounts can concurrently have the same "confirmed" WCA ID.



### 2. Competition registrations and associated results

The database contains a total of ~200,000 registrations.

~57,000 of the ~129,500 WCA IDs have registered for a competition using a user account.

The "registrations" table includes the user ID of every registration but not the associated WCA ID. In many cases a user account used for registration will have already claimed a WCA ID but the ones which haven't claimed a WCA ID can still be used to determine an implicit link via the competition results.

By comparing the names that registered for a competition against the names in the results it is possible to establish reliable links between user IDs (registrations) and WCA IDs (results).

Hypothetical example: The user John Smith registered for UKC 2018. The user John Smith has not claimed a WCA ID but the results for UKC 2018 do contain a John Smith. Since there was only one John Smith registered for the competition it can be deduced that the John Smith in the results is the John Smith that registered. The principle can be applied to all ~200,000 registrations in the database to discover a large number of extremely reliable links from user account to WCA ID, despite them never making a "claim".

The only caveat with this approach is that it should not be used when two or more people compete at the same competition with the same name. Berkeley Fall 2017 illustrates this very scenario since two people called Ryan Lee competed and got official results (2013LEER01 and 2015LEER02). It is easiest / safest to ignore people who have the same name as another competitor at the same competition. The numbers involved are so miniscule that there is little benefit in trying to do anything clever for these special cases as it is quite likely to be error prone.

Linking registrations to results takes about 30 seconds on my machine but it results in ~16,000 additional links between WCA ID and user ID.

These links are extremely trustworthy and IMHO can be considered >99.9% reliable. The other great thing about these links is that additional registration data will become available in the future to establish further links!




### 3. Claimed WCA ID (not yet confirmed by delegate)

There are ~600 WCA IDs with an "unconfirmed" user account, awaiting confirmation by a delegate.

These are similar to the regular case where a WCA ID has been claimed by a user account but in this instance it is still awaiting delegate confirmation.

It should be noted that unlike "confirmed" user accounts which cannot share the same WCA ID, multiple "unconfirmed" user accounts can reference the same WCA ID:

- 2014ERDE01 Arsen Onat Erdem (Turkey)
  - 21620 - awaiting confirmation for 2014ERDE01
  - 21621 - awaiting confirmation for 2014ERDE01

My SQL script stores all such user IDs in the field "unconfirmed_ids" but it will pick the latest (21621) as the recommended user ID - stored in "user_id".

There are sometimes instances where people try to claim the wrong ID so my SQL script also checks that the names match. The script gives precedence to "confirmed" user accounts and "registration" derived links over "unconfirmed" accounts.

It is also worth noting that user accounts can be awaiting confirmation for a WCA ID that has already been linked + confirmed for another user account:

- 2009CRUZ04 Victor Dela Cruz Jr. (Philippines)
  - 63388 - confirmed for 2009CRUZ04 
  - 32034 - awaiting confirmation for 2009CRUZ04 
  - 63386 - awaiting confirmation for 2009CRUZ04 

Since 63388 has already been "confirmed" it takes precedence over 32034 and 63386. If there was no confirmed account then 63386 would take precedence over 32034.

The "unconfirmed" claims provide an additional 386 links. It's not a high number of additional links but they can be regarded as pretty reliable!




### 4. Name matches (country specific)

There are ~19,500 WCA IDs without a linked user account but where there is a user account with the same name and country. Many of these will have already been discovered by steps 2 (registrations) and 3 (unconfirmed claims) but the remainder can be discovered by name matching.

Where the are no "confirmed", "registered" or "unconfirmed" user accounts the application of name + country matching can be useful:

- 2010LIVN01 Tamir Livneh (Israel)
  - 146584 - same name and country; Tamir Livneh (Israel)
  - 147547 - same name and country; Tamir Livneh (Israel)

My SQL script will store all such user IDs in the field "country_ids" but it will pick the highest (147547) as the recommended user ID - stored in "user_id".

It is worth noting that there may be "confirmed" or "unconfirmed" user accounts in addition to unlinked user accounts for a specific name / person:

- 2014GAAL01 Helmi Gaaloul (Tunisia)
  - 5303 - awaiting confirmation for 2014GAAL01 
  - 53159 - awaiting confirmation for 2014GAAL01 
  - 39218 - same name and country; Helmi Gaaloul (Tunisia)

In such cases the "unconfirmed" accounts (identified in the step 3) take precedence so 53159 would be chosen as the most likely match. 5303 and 53159 would be stored in "unconfirmed_ids" and 39218 would be stored in "country_ids".

IMPORTANT: It cannot always be assumed that name + country returns a specific person because some people have identical names, especially in certain ethnicities and countries (e.g. China).

Name + country matching should only be used if there is exactly one person in the WCA with the name. In most instances there is only one person with a given name in a given country and so the user account is almost certainly the correct one.

Matching name and country provides an additional ~4,200 links.

Final note: My original SQL script checked name + gender + country. I found that a lot of unspecified genders (blank or u) were causing valid matches to be excluded and after further investigation, I concluded that just using name + country was a more effective approach to matching.




### 5. Name matches (worldwide)

In addition to the above there are ~200 additional WCA IDs where there is a name match (woldwide).

Due to the relatively low number of these matches and the risk of them being the wrong person, it is advisable to ignore these matches!

My SQL script records the worldwide name matches in "world_ids" but it does not copy them into "user_id".

If desired they can potentially be checked manually for anyone of special interest.



## Sanity Checks

After running the five steps, checking for user accounts associated with multiple WCA accounts shows the following:

| WCA ID | Name  | Gender   | Country | Status | userId | regIds     |
| ---------- | ------------------- | ---- | ------- | ---------- | ------: | -----------: |
| 2017SHAR33 | Aryan Sharma        | m    | India   | Registered | 138431 | 138431      |
| 2019SHAR04 | Aryan Sharma        | m    | India   | Registered | 138431 | 138431      |
| 2018HEBR02 | Brian He            | m    | USA     | Registered | 69111  | 69111       |
| 2018HEBR03 | Brian He            | m    | Canada  | Registered | 69111  | 69111       |
| 2018NAUE01 | Elizabeth M. Nauert | f    | USA     | Confirmed  | 102194 | 102194      |
| 2018NAUE03 | Elizabeth M. Nauert | f    | USA     | Registered | 102194 | 102194      |
| 2017ANHL03 | Lê Đức Anh          | m    | Vietnam | Confirmed  | 54632  | 54632       |
| 2018ANHL01 | Lê Đức Anh          | m    | Vietnam | Registered | 54632  | 54632       |
| 2017HUNG21 | Nguyễn Mạnh Hùng    | m    | Vietnam | Registered | 68358  | 68358       |
| 2017HUNG22 | Nguyễn Mạnh Hưng    | m    | Vietnam | Confirmed  | 68358  | 68358       |
| 2017MINH52 | Nguyễn Nhật Minh    | m    | Vietnam | Confirmed  | 64896  | 64896       |
| 2017MINH53 | Nguyễn Nhật Minh    | m    | Vietnam | Registered | 64896  | 64896       |
| 2017HUYN10 | Nguyen Quang Huy    | m    | Vietnam | Registered | 58682  | 58682       |
| 2018HUYN04 | Nguyen Quang Huy    | m    | Vietnam | Registered | 58682  | 58682       |
| 2017DATN01 | Nguyễn Thành Đạt    | m    | Vietnam | Confirmed  | 57194  | 98462,57194 |
| 2018DATN01 | Nguyễn Thành Đạt    | m    | Vietnam | Registered | 57194  | 57194       |
| 2017KIET03 | Trần Tuấn Kiệt      | m    | Vietnam | Registered | 58832  | 58832       |
| 2018KIET10 | Trần Tuấn Kiệt      | m    | Vietnam | Registered | 58832  | 58832       |
| 2016MINH07 | Vũ Nhật Minh        | m    | Vietnam | Confirmed  | 14389  | 14389       |
| 2018MINH09 | Vũ Nhật Minh        | m    | Vietnam | Registered | 14389  | 14389       |
| 2016DOSH01 | Yash Doshi          | m    | India   | Registered | 9260   | 9260        |
| 2016DOSH03 | Yash Doshi          | m    | India   | Registered | 9260   | 9260        |

In all instances this appears to be due to the person signing up to competitions using an (unlinked) user account and being given a new WCA ID. In some cases the account subsequently claimed a WCA ID.

I don't believe these are a flaw in the logic and expect most of these WCA profiles to be merged, eventually.



## Summary

The five steps produce the following number of links between user accounts and WCA IDs:

|Step |Status | Count |
| --- | --- | ---: |
| - | Non-existent | 57,642 |
| 1  | Confirmed   | 51,444 |
| 2 | Registered  | 15,939 |
| 3 | Unconfirmed | 386   |
| 4    | Possible (Country) | 4,127 |
| 5 | Possible (World) | 161 |
|  | **TOTAL** | **129,538** |

Steps 1, 2 and 3 produce very reliable links and can be used with a high level of confidence.

Step 4 produces pretty reliable results 

Step 5 should not be relied upon!

