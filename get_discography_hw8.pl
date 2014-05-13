#!/usr/bin/perl 
use LWP 5.803;
# Add a header directive indicating that this is encoded in UTF-8 
use XML::Simple;
NoEscape => 1;
binmode(STDOUT, ":utf8");
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
print "Content-type:text/xml; charset:UTF-8", "\n\n"; 

# Check whether LWP module is installed
 if( eval{require LWP::Simple;} )
{
if ($ENV{'REQUEST_METHOD'} eq "GET")
{$buffer =$ENV{'QUERY_STRING'};}
else { read(STDIN, $buffer, $ENV{'QUERY_STRING'}); } 
}
else {
print "You need to install the Perl LWP module!<br>"; 
exit;
}

# Retrieve the content of an URL 
my $j=0;
@nvpairs = split(/&/, $buffer);
foreach $pair(@nvpairs){
($name[$j], $value[$j]) = split(/=/, $pair);
$name[$j]=~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;  
$value[$j]=~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;  
$j++;
}
$url = "http://www.allmusic.com/search";
$url = $url."/".$value[1]."/".$value[0];
$response = LWP::UserAgent->new->get($url);
die "Can't get $url -- ", $response->status_line
 unless $response->is_success;
die "Error!", $response->content_type
 unless $response->content_type eq 'text/html';
$content = $response->content;
my @Image,@Name,@Genre,@Year,@Details,@Title,@Artist,@Sample,@Composer,@Performer;
my $i=0;
if ($value[1] eq "artists"){
open FH, '<', \$content;
while($Line=<FH>){
	 if($Line =~  /<div class="cropped-image" style="(.+?)" ><img src="(.+?)"/){
		   $Image[$i]=$2;
		   }
	if($Line =~  /<a href="(.+?)" data-tooltip="(.+?)">(.+?)<\/a>/){
	     $Details[$i]=$1;
	     $Name[$i]=$3;
	     $Line=<FH>;
	     $Line=<FH>;
	     $Line=<FH>;
	      if($Line =~  /^([ A-Za-z]+\/?-?,?\.?\s?'?[ A-Za-z]+\/?-?,?\.?\s?'?[ A-Za-z]+)$/){
          $Genre[$i]=$1;
          $Genre[$i]=~s/\s+//g;
          $Genre[$i]=~s/&/&amp;/g;
          $Genre[$i]=~s/'/&apos;/g;
         }
         $Line=<FH>;
	     $Line=<FH>;
	     $Line=<FH>;
	     if($Line =~  /(\d{4}s?\s?-?\s?\d?\d?\d?\d?s?)/){
         $Year[$i]=$1;
         $Year[$i]=~ s/\s+//g;
         }
          $i++;
	   }
     }	
$Count=$i;


if($Count eq 0){
print "<results total=\"0\"></results>";
exit;
}
else{
    
     print "<results total=\"$Count\">";
	for($k=0;$k<$Count;$k++){	
			if($Image[$k] eq ""){
				$Image[$k]='N/A';
			}
			if($Genre[$k] eq ""){
				$Genre[$k]='N/A';
			}
			if($Year[$k] eq ""){
				$Year[$k]='N/A';
			}	
		
			print "<result cover=\"$Image[$k]\" name=\"$Name[$k]\" genre=\"$Genre[$k]\" year=\"$Year[$k]\" details=\"$Details[$k]\" />";		
	}
    print "</results>";
    
   }
}



if ($value[1] eq "albums"){
open FH, '<', \$content;
while($Line=<FH>){
	   #print $i;
	   #print $Line;
	
    
	if($Line =~  /<div class="cropped-image" style="(.+?)" ><img src="(.+?)"/){
		   $Image[$i]=$2;
		   }
	if($Line =~  /<a href="(.+?)" data-tooltip="(.+?)">(.+?)<\/a>\s*<\/div>/){
	     $Title[$i]=$3;
	     $Details[$i]=$1;
          $Line=<FH>;
          $Line=<FH>;
          $Line=<FH>;
          if($Line =~  /<a href="(.+?)">(.+?)<\/a>\s*<\/div>/){
          $Artist[$i]=$2;
          $Artist[$i]=~s/<a href="(.+?)">//g;
          $Artist[$i]=~s/<\/a>//g;
          $Artist[$i]=~s/&/&amp;/g;
          $Artist[$i]=~s/'/&apos;/g;
          $Artist[$i]=~s/"/&quot;/g;
 
          }
          $Line=<FH>;
          $Line=<FH>;
          $Line=<FH>;
          $Line=<FH>;
	     if($Line =~  /(\d{4}s?\s?-?\s?\d?\d?\d?\d?s?)\s*<br\/>/){
	      $Year[$i]=$1;
	      $Year[$i]=~ s/\s+//g;
         }
          $Line=<FH>;
	      if($Line =~  /^([ A-Za-z]+\/?-?,?\.?\s?'?[ A-Za-z]+\/?-?,?\.?\s?'?[ A-Za-z]+)$\s*<\/div>/){
         $Genre[$i]=$1;
         $Genre[$i]=~s/\s+//g;
         $Genre[$i]=~s/&/&amp;/g;
         $Genre[$i]=~s/'/&apos;/g;
         }
          $i++;
	   }
     }	
$Count=$i;


if($Count eq 0){
print "<results total=\"0\"></results>";

}
else{

        print "<results total=\"$Count\">";
	for($k=0;$k<$Count;$k++){	
			if($Image[$k] eq ""){
				$Image[$k]='N/A';
			}
			if($Genre[$k] eq ""){
				$Genre[$k]='N/A';
			}
			if($Year[$k] eq ""){
				$Year[$k]='N/A';
			}			
	        if($Artist[$k] eq ""){
			$Artist[$k]='Various Artists';
		    
			}		
			print "<result cover=\"$Image[$k]\" title=\"$Title[$k]\" artist=\"$Artist[$k]\" genre=\"$Genre[$k]\" year=\"$Year[$k]\" details=\"$Details[$k]\" />";		
	}
	print "</results>";
	
   }
}


if ($value[1] eq "songs"){
open FH, '<', \$content;
while($Line=<FH>){
	 if($Line =~  /<a title="(.+?)"/){
		   $Title[$i]=$1;
		   $Title[$i]=~s/&/&amp;/g;
		   $Title[$i]=~s/'/&apos;/g;
		   $Line=<FH>;
		 if($Line =~  /\s*href="(.+?)"/){
		   $Details[$i]="http://www.allmusic.com".$1;
		   $Details[$i] =~s/&/&amp;/g;
		   }
		   }
	if($Line =~  /<a href="(.+?)" title="play sample"><\/a>/){
	     $Sample[$i]=$1;
	    $Sample[$i]=~s/&/&amp;/g;
	    
	    }
	    
	if($Line =~  /<a href="(.+?)">(.+?)<\/a>\s*<br\/><span class="performer">by <a href="(.+?)">(.+?)<\/a><\/span>/){
          $Performer[$i]=$4;
          $Performer[$i]=~s/<a href="(.+?)">//g;
          $Performer[$i]=~s/<\/a>//g;
         $Performer[$i]=~s/&/&amp;/g;
          $Performer[$i]=~s/'/&apos;/g;
           $Performer[$i]=~s/"/&quot;/g;
          $Line=<FH>;
          $Line=<FH>;
          $Line=<FH>;
          $Line=<FH>;
        if($Line =~  /<br\/>Composed by <a href="(.+?)">(.+?)<\/a>\s*<\/div>/){
         $Composer[$i]=$2;
         $Composer[$i]=~s/<a href="(.+?)">//g;
         $Composer[$i]=~s/<\/a>//g;
         $Composer[$i]=~s/&/&amp;/g;
         $Composer[$i]=~s/'/&apos;/g;
        $Composer[$i]=~s/"/&quot;/g;
         }
          $i++;
         }    
     }	
$Count=$i;


if($Count eq 0){
print "<results total=\"0\"></results>";

}
else{
  
        print "<results total=\"$Count\">\n";
	for($k=0;$k<$Count;$k++){	
			if($Sample[$k] eq ""){
				$Sample[$k]='N/A';
				
			}
			
			   print "<result sample=\"$Sample[$k]\"\n ";
			   
			if($Composer[$k] eq ""){
				$Composer[$k]='N/A';
			}
		print "title=\"$Title[$k]\"\n performer=\"$Performer[$k]\"\n composer=\"$Composer[$k]\"\n details=\"$Details[$k]\"/>\n";		
	}
	print "</results>";
	
   }
}


