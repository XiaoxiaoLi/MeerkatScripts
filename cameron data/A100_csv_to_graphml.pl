#Read the A100 .csv file seperated by tab, 

#create graphml graph
#Dec 13 2013

#input file stored in: csc205 machine, workspace/meerkat and others/cameron data, see Dec 13.2013 email
#input file format
#Last Name	First Name	Current Company	Past Companies	Skills	Interests	Companies Connected to	Investor?

use strict;
use Cwd;#get current directory
my $time1=time();#measures the running time of this script

#for the column "Past Companies"
#A node is a company, an edge is formed when a person has worked for both of these two Companies

#my $input_route = $ARGV[0];#read input file route with user input
my $input_route = "A100 Network Sample.csv";
open(IN,$input_route)or die "unable to open $input_route\n";#open input file handle

my $output_route = ">".$input_route.".graphml";
open(OUT,$output_route)or die "unable to open $output_route\n";#open input file handle

#beginning of the graphml file
my $beginning = q(<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
 
http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">);

my $graph_head = q(<graph id="G" edgedefault="undirected">);

print OUT $beginning."\n";
print OUT $graph_head."\n";
#Read the input file,read the nodes and edges
my $lineNum = 0;
my %nodeName_to_id_hash=();
my %nodes_HoH = ();
my %edges_HoH = ();
while(<IN>){
	chomp;
	my $line = $_;
	if($lineNum!=0){#the first row is the table head, we don't want that
		my @columns = split(/\t/,$line);
		my $lastName = $columns[0];
		my $firstName = $columns[1];
		my $consultant = $firstName."_".$lastName;
		my $pastCompanies_str = $columns[3];#a comma in here seperates the different companines
		my @pastCompanies_arr = split(/,/,$pastCompanies_str);
		for my $i(0..$#pastCompanies_arr){
			my $pastCompany = $pastCompanies_arr[$i];
			$pastCompany = &cleanNodeName($pastCompany);
			#add to nodes
			my $node_id = "n".scalar(keys %nodeName_to_id_hash);
			if(!exists $nodeName_to_id_hash{$pastCompany}){#we haven't seen this node yet	
				$nodeName_to_id_hash{$pastCompany} = $node_id;
				$nodes_HoH{$node_id}{'id'} = $node_id;
				$nodes_HoH{$node_id}{'name'} = $pastCompany;
				$nodes_HoH{$node_id}{'consultant'}=$consultant;
			}else{
				$nodes_HoH{$node_id}{'consultant'}.=", ".$consultant;#add with comma
			}

			#add to edges
			#link this node to previous nodes in this row
			for(my $j=0;$j<$i;$j++){
				my $sourceNodeName = $pastCompanies_arr[$j];
				$sourceNodeName =  &cleanNodeName($sourceNodeName);
				if(exists $nodeName_to_id_hash{$sourceNodeName}){
					my $sourceNode_id = $nodeName_to_id_hash{$sourceNodeName};
					my $targetNode_id = $node_id;
					my $edgeName = $sourceNode_id."_".$targetNode_id;
					if(!exists $edges_HoH{$edgeName}){
						$edges_HoH{$edgeName}{'id'}= "e".scalar(keys %edges_HoH);
						$edges_HoH{$edgeName}{'source'}=$sourceNode_id;
						$edges_HoH{$edgeName}{'target'}=$targetNode_id;
						$edges_HoH{$edgeName}{'weight'}= 1;
						$edges_HoH{$edgeName}{'linkedBy'}= $consultant;
					}else{
						$edges_HoH{$edgeName}{'weight'}+= 1;
						$edges_HoH{$edgeName}{'linkedBy'}.= ", ".$consultant;
					}
				}
			}
		}	
	}
	$lineNum++;
}

#now we have the nodes and edges, print them to graphml
#attributes
#node name
print OUT q(<key id="node_name" for="node" attr.name="nodeName" attr.type="string"/>)."\n";
print OUT q(<key id="node_consultant" for="node" attr.name="consultant" attr.type="string"/>)."\n";

print OUT q(<key id="edge_weight" for="edge" attr.name="weight" attr.type="int"/>)."\n";
print OUT q(<key id="edge_linked_by" for="edge" attr.name="linkedBy" attr.type="string"/>)."\n";

#nodes
foreach my $node (sort keys %nodes_HoH ) {
    print OUT q(<node id=").$nodes_HoH{$node}{'id'}.q(">)."\n";
    print OUT "\t".q(<data key="node_name">).$nodes_HoH{$node}{'name'}.q(</data>)."\n";
    print OUT "\t".q(<data key="node_consultant">).$nodes_HoH{$node}{'consultant'}.q(</data>)."\n";
    print OUT q(</node>)."\n";  
}
#edges
foreach my $edge (sort  keys %edges_HoH ) {
	print OUT q(<edge id=").$edges_HoH{$edge}{'id'}.q(" source=").$edges_HoH{$edge}{'source'}.q(" target=").$edges_HoH{$edge}{'target'}.q(">)."\n";
	print OUT "\t".q(<data key="edge_weight">).$edges_HoH{$edge}{'weight'}.q(</data>)."\n";
	print OUT "\t".q(<data key="edge_linked_by">).$edges_HoH{$edge}{'linkedBy'}.q(</data>)."\n";
	print OUT q(</edge>)."\n";  
}



#end of the graphml file
print OUT q(</graph>)."\n";
print OUT q(</graphml>)."\n";
close IN;
close OUT;

# # test print the nodes HoH
# foreach my $node ( keys %nodes_HoH ) {
#     print "$node: { ";
#     for my $role ( keys %{ $nodes_HoH{$node} } ) {
#         print "$role=$nodes_HoH{$node}{$role} ";
#     }
#     print "}\n";
# }

# # test print the edges HoH
# foreach my $edge ( keys %edges_HoH ) {
#     print "$edge: { ";
#     for my $role ( keys %{ $edges_HoH{$edge} } ) {
#         print "$role=$edges_HoH{$edge}{$role} ";
#     }
#     print "}\n";
# }

#clean the beginning and ending spaces
sub cleanNodeName(){
	my ($str)=@_;
	$str=~s/^\s+//;
	$str=~s/\s+$//;
	return $str;
}