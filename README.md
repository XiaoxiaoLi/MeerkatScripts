## Trivial Meerkat Scripts

Scripts (non-privacy issues) for different data sources. May be confusing to put in the main code repository.

#### Cameron wants to run the [A100] (http://www.thea100.org/) file on Meerkat

See Dec 13 2013 email with Cameron for the intput data.

Input file is `.xlsx`, in excel, save as->`csv`, deliminate with Tab key.

Wrote a [perl script - A100_csv_to_graphml.pl]  (https://github.com/XiaoxiaoLi/MeerkatScripts/blob/master/cameron%20data/A100_csv_to_graphml.pl) to convert that into `.graphml`. A node is a company, an edge is formed when a person has worked in both of these companies in the 'Past Companies' column.

#### IAE data InstituteConsultationSurveyReport_20131101-Answers.xlsx conversion to MeerkatED standard format.

See Dec 10 2013 email titled "Fwd: FW: output of small business survey in CSV" for the input data.

Input file is `.xlsx`, in excel, save as->`csv`, deliminate with Tab key.

Wrote a [perl script - InstituteConsultationCSV2MeerkatEDStandardFormat.pl] (https://github.com/XiaoxiaoLi/MeerkatScripts/blob/master/IAE/InstituteConsultation/InstituteConsultationCSV2MeerkatEDStandardFormat.pl) to convert that input file to MeerkatED standard format.

#### Mansoureh wants to run an .meerkat file with the old format in the current Meerkat

See Dec 9 2013 email 'Meerkat Meeting' for the input file '2011Monthly_300node.meerkat'

This file does not define vertices. It defines edges like such

    *Vertices
    email1  email2

whereas the new .meerkat format needs to define Vertices for each time frame. I wrote a [perl script - onlyEdgeToVerticesAndEdges.pl](https://github.com/XiaoxiaoLi/MeerkatScripts/blob/master/Mansoureh%202001%20monthy%20data/onlyEdgeToVerticesAndEdges.pl) to transform that to the new data format. We define the vertices based on the edges in each time frame. The vertex with the same email address will have the same ID across all the time frames. If a vertex did not appear in this time frame, it will not be declared in this time frame.

#### Osmar's Jeu de donnees data

See Feb 10 2014 email titled 'Fwd: Jeu de données' for the data. 

Input format:

12.32_1.21;78.10_7.3

Means link between a node with values 12.32 and 1.21  for the 2 attributes and a node with values  78.10 and  7.3 for those 2 attributes.

I wrote a [script](https://github.com/XiaoxiaoLi/MeerkatScripts/blob/master/Osmar_French_Data/twoAttributeVerticesGraphToGraphML.pl) to convert that file format into .graphml format. vertex attributes: id, attr1, attr2; and edge attributes: id, weight.

All the weight seem to be 1.

