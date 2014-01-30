# Transforms the 'InstituteConsultationSurveyReport_20131101-Answers.csv' into MeerkatED standard format

use strict;
use Cwd;#get current directory
use Data::Dumper;

#my $input_route = $ARGV[0];#read input file route with user input
my $input_route = "InstituteConsultationSurveyReport_20131101-Answers.csv";
open(IN,$input_route)or die "unable to open $input_route\n";#open input file handle

my $output_route = ">".$input_route.".MeerkatED";
open(OUT,$output_route)or die "unable to open $output_route\n";#open input file handle

my $filterSilentPeopleFlag = 0;

my $lineNum = 0;
my @data;
while(<IN>){
	chomp;
	my $line = $_;
	my @columns = split(/\t/,$line);
	# If we include everyone, even if the ones who hasn't spoke.
	if (!$filterSilentPeopleFlag){
		for (my $i=0;$i<=$#columns;$i++){
			my $cell = $columns[$i];
			$data[$lineNum][$i] = $cell;
		}
		$lineNum++;
	}
	
}
close IN;
# Finished storing the matrix data


#print Dumper(\@data);#visualize the 2-dim array

# Print the data in MeerkatED's standard format

# Course
my $courseName = "InstituteConsultationSurvey";
print OUT "*COURSE\n$courseName\n\n";

# Date format
print OUT "*DATE_FORMAT\ndd-MM-yyyy HH:mm\n\n";

# Students
# in this data, the persons don't have first name, they do have organization (column3). We'll use that as first name for now.
print OUT "*STUDENTS\n";
for(my $i=1;$i<=$#data;$i++){#each row is a person
	my $id = $i-1;#student ID starts with 0
	my $organizationAsFirstName = $data[$i][3];
	print OUT "$id".", ".$organizationAsFirstName."\n";
}
print OUT "*END\n";

# Forum
print OUT "*FORUM\n$courseName\n\n";

# Discussion and MESSAGEs
my $messageID = 0;
for (my $i=4;$i<=6;$i++){#this data row0, column 4 to 6 are questions, each column is a discussion
	print OUT "*DISCUSSION\n$data[0][$i]\n\n";
	for (my $j=1;$j<=$#data;$j++){
		my $cell = $data[$j][$i];
		my $studentID = $j-1;
		my $organization = $data[$j][3];
		my $time = $data[$j][1];
		if($cell ne ""){#don't want empty messages
			print OUT "*MESSAGE $messageID\n";
			print OUT "by $studentID\n";
			print OUT "at $time\n\n";
			print OUT "someone from $organization\n";#use this as title
			print OUT "$cell\n";
			print OUT "*END\n";
			$messageID++;
		}
	}
}

close OUT;