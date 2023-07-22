# 👉TRAINFOBEL🚉🔴
Automation of collecting and publishing information on Twitter regarding SNCB and Belgian railway traffic in general.

## Update:
20230722: Unfortunately, the rules of the twitter api have changed again and now it's almost impossible to use the service without paying, I've modified the script so that it uploads the exports daily to https://trainfobel.pocketvince.com and I guess I'll continue to publish the images on the twitter account.

20230531: create stats report, add argument in reduce_argument, block tweets if made between 11pm and 4am

20230528: twitter export request to start a text analysis to reduce tweets publication and shorten text

20230525: script generate infinite files (todo: create a database containing md5sum results and then delete the file)

20230524: create script to extract each job/disturbance individually in text format, generate md5sum check to find out if a tweet is duplicated by calculating md5sum

20230523: data search, retrieve api key, write script to tweet head file

20230523: improvement of the published text and creation of a stats tool to publish the previous day's disruptions

## Contributing

Readme generator: https://www.makeareadme.com/

## Extra info
Trainfobel was my first twitter bot based on Google Sheets and IFTTT automation.
I realized that a lot of sncb-related twitter bots were doing the same thing, and I finally decided to abandon this bot to make others based on shell & python.
The twitter api having become limited, all services such as Zapier, IFTTT,... have become payware, and there are no more bot dedicated to that on Twitter, I thought, it's the opportunity to start something new with my new knowledge.
https://twitter.com/trainfobel
