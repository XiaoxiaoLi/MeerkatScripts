# The data from Mansoureh 2001Monthly_300node.meerkat has only edges while .meerkat file needs vertices with integar IDs.
# Transform it to the .meerkat format
use strict;
use Cwd;#get current directory

#my $input_route = $ARGV[0];#read input file route with user input
my $input_route = "2001Monthly_300node.meerkat.old";
open(IN,$input_route)or die "unable to open $input_route\n";#open input file handle

my $output_route = ">2001Monthly_300node.meerkat";
open(OUT,$output_route)or die "unable to open $output_route\n";#open input file handle

#ivars
# one for each time frame
my %all_vertices = ();#key is email address, value is ID , stores all the vetices in this file
my %vertices = ();#vertices that are the src or dst of the edges in this time frame. key is email address, value is ID(same as in %all_vertices)
my @edges = (); #srcID\tdstID edges of this time frame

my $readingEdgesFlag = 0;#if we are reading edges.

while(<IN>){
	chomp;
	my $line=$_;
	if ($line ne ""){
		if($line eq "*Edges"){
			$readingEdgesFlag =1;
			next;
		}

		if($line eq "*End"){
			$readingEdgesFlag =0;

			#print the vertices and edges
			print OUT "\n*Vertices\n";
			foreach my $key (sort { $vertices{$a} <=> $vertices{$b} } (keys %vertices)){
				my $value = $vertices{$key};
				print OUT "$value {Email=".$key."}\n";
			}

			print OUT "\n*Edges\n";
			foreach my $edge(@edges){
				print OUT $edge."\n";
			}


			#clear them for the next time frame
			%vertices = ();
			@edges = ();
		}
		if($readingEdgesFlag==0){
			print OUT $line."\n";
		}else{#read the edges, get the vertices, store vertices and edges
			my ($src,$dst)=split(/\t/,$line);
			my $srcID = -1;
			my $dstID = -1;
			# store the src vertex
			if(!exists $all_vertices{$src}){
				$srcID = scalar(keys %all_vertices)+1;#ID starts with 1
				$all_vertices{$src} = $srcID;
			}else{
				$srcID = $all_vertices{$src};
			}
			$vertices{$src} = $srcID;
			# store the dst vertex
			if(!exists $all_vertices{$dst}){
				$dstID = scalar(keys %all_vertices)+1;#ID starts with 1
				$all_vertices{$dst} = $dstID;
			}else{
				$dstID = $all_vertices{$dst};
			}
			$vertices{$dst} = $dstID;
			push(@edges,$srcID."\t".$dstID);
		}
	}
}

close IN;
close OUT;