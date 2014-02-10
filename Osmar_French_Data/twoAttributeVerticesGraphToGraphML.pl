# Input format:
# Example :
# 12.32_1.21;78.10_7.3

# Means link between a node with values 12.32 and 1.21  for the 2 attributes and a node with values  78.10 and  7.3 for those 2 attributes.

# turn this to the .graphml file format

use strict;
use Cwd;#get current directory

#my $input_route = $ARGV[0];#read input file route with user input
my $input_route = "test2.csv";
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
my %nodes_HoH = ();
my %edges_HoH = ();

while(<IN>){
	chomp;
	my $line = $_;
	my $edgeName = $line;# a line is an edge 32.151_58.353;27.389_51.944
	my ($src,$dst) = split(/;/,$line);#use 32.151_58.353 as node
	my $srcID = -1;
	my $dstID = -1;
	#store the node ID and attributes
	if(!exists $nodes_HoH{$src}){
		$srcID = "n".scalar(keys %nodes_HoH);
		$nodes_HoH{$src}{'id'}=$srcID;
		my($attr1,$attr2)=split(/_/,$src);
		$nodes_HoH{$src}{'attr1'}=$attr1;
		$nodes_HoH{$src}{'attr2'}=$attr2;
	}else{
		$srcID = $nodes_HoH{$src}{'id'};
	}
	if(!exists $nodes_HoH{$dst}){
		$dstID = "n".scalar(keys %nodes_HoH);
		$nodes_HoH{$dst}{'id'}=$dstID;
		my($attr1,$attr2)=split(/_/,$dst);
		$nodes_HoH{$dst}{'attr1'}=$attr1;
		$nodes_HoH{$dst}{'attr2'}=$attr2;
	}else{
		$dstID = $nodes_HoH{$dst}{'id'};
	}

	#store the edge
	if(!exists $edges_HoH{$edgeName}){
		$edges_HoH{$edgeName}{'id'}= "e".scalar(keys %edges_HoH);
		$edges_HoH{$edgeName}{'source'}=$srcID;
		$edges_HoH{$edgeName}{'target'}=$dstID;
		$edges_HoH{$edgeName}{'weight'}= 1;
	}else{
		$edges_HoH{$edgeName}{'weight'}+= 1;	
	}

}

#now we have the nodes and edges, print them to graphml
#attributes
print OUT q(<key id="attr1" for="node" attr.name="attr1" attr.type="double"/>)."\n";
print OUT q(<key id="attr2" for="node" attr.name="attr2" attr.type="double"/>)."\n";

print OUT q(<key id="edge_weight" for="edge" attr.name="weight" attr.type="int"/>)."\n";

#nodes
foreach my $node (sort keys %nodes_HoH ) {
    print OUT q(<node id=").$nodes_HoH{$node}{'id'}.q(">)."\n";
    print OUT "\t".q(<data key="attr1">).$nodes_HoH{$node}{'attr1'}.q(</data>)."\n";
    print OUT "\t".q(<data key="attr2">).$nodes_HoH{$node}{'attr2'}.q(</data>)."\n";
    print OUT q(</node>)."\n";  
}
#edges
foreach my $edge (sort  keys %edges_HoH ) {
	print OUT q(<edge id=").$edges_HoH{$edge}{'id'}.q(" source=").$edges_HoH{$edge}{'source'}.q(" target=").$edges_HoH{$edge}{'target'}.q(">)."\n";
	print OUT "\t".q(<data key="edge_weight">).$edges_HoH{$edge}{'weight'}.q(</data>)."\n";
	print OUT q(</edge>)."\n";  
}



#end of the graphml file
print OUT q(</graph>)."\n";
print OUT q(</graphml>)."\n";
close IN;
close OUT;