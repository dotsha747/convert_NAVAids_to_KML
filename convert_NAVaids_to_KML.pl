#! /usr/bin/perl

# parse X-Plane's Waypoints.txt and generates KML.

use Data::Dumper;
use XML::LibXML;

# navigraph version
my $inNav = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/Navaids.txt";
my $inWPT = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/Waypoints.txt";
my $outdir = "/usr/local/myKMLs/";


# main program

system ("mkdir -p $outdir");



# NavAids Format
# CE,CALEDONIAN,205.000,0,0,110,3.29508,101.45192,0,WM,0
# VBA,BATU ARANG,114.700,1,1,195,3.32481,101.45692,359,WM,0

# 0 Navaid Identifier
# 1 Navaid Name
# 2 Frequency
# 3 VOR flag (1 if VOR)
# 4 DME flag (1 of DME available)
# 5 Range in nm
# 6 Latitude
# 7 Longitude
# 8 Elevation in feet
# 9 Country Code


open (INF, $inNav) || die "Unable to open $inNav\n";

my %nav;


my $dom = XML::LibXML::Document->new("1.0", "UTF-8");
my $root = $dom->createElement ("kml");
$root->setAttribute ("xmlns", "http://www.opengis.net/kml/2.2");
$root->setAttribute ("xmlns:gx", "http://www.google.com/kml/ext/2.2");
$dom->setDocumentElement ($root);

my $doc = $dom->createElement("Document");
$root->addChild ($doc);

my $name = $dom->createElement("name");
$name->appendTextNode ("NAVAids");
$doc->appendChild ($name);

# VOR style

my $style = $dom->createElement("Style");
$style->setAttribute ("id", "VOR");
$doc->appendChild ($style);

my $iconStyle = $dom->createElement("IconStyle");
$style->appendChild ($iconStyle);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.80");
$iconStyle->appendChild ($scale);

my $color = $dom->createElement("color");
$color->appendTextNode("CF00FFFF");
$iconStyle->appendChild ($color);

my $icon = $dom->createElement("Icon");
$iconStyle->appendChild ($icon);

my $href = $dom->createElement("href");
$href->appendTextNode ("Pictogram_VOR.png");
$icon->appendChild ($href);

my $labelStyle = $dom->createElement("LabelStyle");
$style->appendChild($labelStyle);

my $color = $dom->createElement("color");
$color->appendTextNode("BFFFFFFF");
$labelStyle->appendChild ($color);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.60");
$labelStyle->appendChild ($scale);

# VOR/DME style

my $style = $dom->createElement("Style");
$style->setAttribute ("id", "VORDME");
$doc->appendChild ($style);

my $iconStyle = $dom->createElement("IconStyle");
$style->appendChild ($iconStyle);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.80");
$iconStyle->appendChild ($scale);

my $color = $dom->createElement("color");
$color->appendTextNode("CF00FFFF");
$iconStyle->appendChild ($color);

my $icon = $dom->createElement("Icon");
$iconStyle->appendChild ($icon);

my $href = $dom->createElement("href");
$href->appendTextNode ("Pictogram_VOR-DME.png");
$icon->appendChild ($href);

my $labelStyle = $dom->createElement("LabelStyle");
$style->appendChild($labelStyle);

my $color = $dom->createElement("color");
$color->appendTextNode("BFFFFFFF");
$labelStyle->appendChild ($color);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.60");
$labelStyle->appendChild ($scale);

# NDB style

my $style = $dom->createElement("Style");
$style->setAttribute ("id", "NDB");
$doc->appendChild ($style);

my $iconStyle = $dom->createElement("IconStyle");
$style->appendChild ($iconStyle);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.80");
$iconStyle->appendChild ($scale);

my $color = $dom->createElement("color");
$color->appendTextNode("CF00FFFF");
$iconStyle->appendChild ($color);

my $icon = $dom->createElement("Icon");
$iconStyle->appendChild ($icon);

my $href = $dom->createElement("href");
$href->appendTextNode ("Pictogram_NDB.png");
$icon->appendChild ($href);

my $labelStyle = $dom->createElement("LabelStyle");
$style->appendChild($labelStyle);

my $color = $dom->createElement("color");
$color->appendTextNode("BFFFFFFF");
$labelStyle->appendChild ($color);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.60");
$labelStyle->appendChild ($scale);


# GS style

my $style = $dom->createElement("Style");
$style->setAttribute ("id", "GS");
$doc->appendChild ($style);

my $iconStyle = $dom->createElement("IconStyle");
$style->appendChild ($iconStyle);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.60");
$iconStyle->appendChild ($scale);

my $color = $dom->createElement("color");
$color->appendTextNode("CF00FFFF");
$iconStyle->appendChild ($color);

my $icon = $dom->createElement("Icon");
$iconStyle->appendChild ($icon);

my $href = $dom->createElement("href");
$href->appendTextNode ("Pictogram_GS.png");
$icon->appendChild ($href);

my $labelStyle = $dom->createElement("LabelStyle");
$style->appendChild($labelStyle);

my $color = $dom->createElement("color");
$color->appendTextNode("BFFFFFFF");
$labelStyle->appendChild ($color);

my $scale = $dom->createElement("scale");
$scale->appendTextNode("0.60");
$labelStyle->appendChild ($scale);

# loop

while (my $line = <INF>) {

	$line =~ s///;
	chomp ($line);

	my @d = split (/,/, $line);

	my $code = $d[0];
	my $name = $d[1];
	my $type = $d[3];
	my $lat = $d[6];
	my $lon = $d[7];

	my $placemark = $dom->createElement("Placemark");

	my $name = $dom->createElement("name");
	$name->appendTextNode ($d[0]);
	$placemark->appendChild ($name);

	my $desc = $dom->createElement("description");
	$desc->appendTextNode ("$d[1] ($d[2] Mhz)");
	$placemark->appendChild ($desc);


	my $region = $dom->createElement("Region");
	$placemark->appendChild ($region);

	my $llb = $dom->createElement("LatLonAltBox");
	$region->appendChild ($llb);

	my $n = $dom->createElement("north");
	$n->appendTextNode ($d[6] + 0.7);
	$llb->appendChild ($n);

	my $s = $dom->createElement("south");
	$s->appendTextNode ($d[6] - 0.7);
	$llb->appendChild ($s);

	my $e = $dom->createElement("east");
	$e->appendTextNode ($d[7] + 0.7);
	$llb->appendChild ($e);

	my $w = $dom->createElement("west");
	$w->appendTextNode ($d[7] - 0.7);
	$llb->appendChild ($w);

	my $lod = $dom->createElement("Lod");
	$region->appendChild ($lod);

	my $mlp = $dom->createElement ("minLodPixels");
	$mlp->appendTextNode ("128");
	$lod->appendChild ($mlp);

	my $su = $dom->createElement("styleUrl");

	if ($d[3] ne '1') {
		if ($d[4] ne '1') {
			$su->appendTextNode("NDB");
		} else {
			$su->appendTextNode("GS");
		}
	} else {
		if ($d[4] ne '1') {
			$su->appendTextNode("VOR");
		} else {
			$su->appendTextNode("VORDME");
		}
	}
	$placemark->appendChild ($su);

	my $point = $dom->createElement ("Point");
	$placemark->appendChild ($point);

	my $coords = $dom->createElement("coordinates");
	$coords->appendTextNode ("$d[7],$d[6]");
	$point->appendChild ($coords);

	$doc->appendChild ($placemark);

}

close (INF);

open (OUTF, ">" . $outdir  . "NAVAids.kml");

print OUTF $dom->toString (1);

close (OUTF);



# NavAids Format
# AGOSA,3.14472,101.21917,WM
# name,lat,lon,?
#
# 0 - Name
# 1 - Latitude
# 2 - Longitude
# 3 - Country

my %wpt;

open (INF, $inWPT) || die "Unable to open $inWPT\n";

while (my $line = <INF>) {

	$line =~ s///;
	chomp ($line);

	my @d = split (/,/, $line);

	my $code = $d[0];
	my $lat = $d[1];
	my $lon = $d[2];
	my $region = $d[3];

	push (@{$wpt{$region}}, [$code, $lat, $lon]);

}

close (INF);

foreach my $region (keys %wpt) {

	my $dom = XML::LibXML::Document->new("1.0", "UTF-8");
	my $root = $dom->createElement ("kml");
	$root->setAttribute ("xmlns", "http://www.opengis.net/kml/2.2");
	$root->setAttribute ("xmlns:gx", "http://www.google.com/kml/ext/2.2");
	$dom->setDocumentElement ($root);

	my $doc = $dom->createElement("Document");
	$root->addChild ($doc);

	my $name = $dom->createElement("name");
	$name->appendTextNode ("$region Fixes");
	$doc->appendChild ($name);

	# fix1

	my $style = $dom->createElement("Style");
	$style->setAttribute ("id", "fix1");
	$doc->appendChild ($style);

	my $iconStyle = $dom->createElement("IconStyle");
	$style->appendChild ($iconStyle);

	my $scale = $dom->createElement("scale");
	$scale->appendTextNode("0.70");
	$iconStyle->appendChild ($scale);

	my $color = $dom->createElement("color");
	$color->appendTextNode("CF00FFFF");
	$iconStyle->appendChild ($color);


	my $icon = $dom->createElement("Icon");
	$iconStyle->appendChild ($icon);

	my $href = $dom->createElement("href");
	$href->appendTextNode ("http://maps.google.com/mapfiles/kml/shapes/triangle.png");
	$icon->appendChild ($href);

	my $labelStyle = $dom->createElement("LabelStyle");
	$style->appendChild($labelStyle);

	my $color = $dom->createElement("color");
	$color->appendTextNode("BFFFFFFF");
	$labelStyle->appendChild ($color);

	my $scale = $dom->createElement("scale");
	$scale->appendTextNode("0.60");
	$labelStyle->appendChild ($scale);

	# fix2

	my $style = $dom->createElement("Style");
	$style->setAttribute ("id", "fix2");
	$doc->appendChild ($style);

	my $iconStyle = $dom->createElement("IconStyle");
	$style->appendChild ($iconStyle);

	my $scale = $dom->createElement("scale");
	$scale->appendTextNode("0.70");
	$iconStyle->appendChild ($scale);

	my $color = $dom->createElement("color");
	$color->appendTextNode("CF00FFFF");
	$iconStyle->appendChild ($color);


	my $icon = $dom->createElement("Icon");
	$iconStyle->appendChild ($icon);

	my $href = $dom->createElement("href");
	$href->appendTextNode ("http://maps.google.com/mapfiles/kml/shapes/triangle.png");
	$icon->appendChild ($href);

	my $labelStyle = $dom->createElement("LabelStyle");
	$style->appendChild($labelStyle);

	my $color = $dom->createElement("color");
	$color->appendTextNode("CFFFFFFF");
	$labelStyle->appendChild ($color);

	my $scale = $dom->createElement("scale");
	$scale->appendTextNode("0.70");
	$labelStyle->appendChild ($scale);

	# loop

	foreach $wpt (@{ $wpt{$region}}) {
	
		my $placemark = $dom->createElement("Placemark");

		my $name = $dom->createElement("name");
		$name->appendTextNode ($wpt->[0]);
		$placemark->appendChild ($name);

		my $region = $dom->createElement("Region");
		$placemark->appendChild ($region);

		my $llb = $dom->createElement("LatLonAltBox");
		$region->appendChild ($llb);

		my $n = $dom->createElement("north");
		$n->appendTextNode ($wpt->[1] + 0.7);
		$llb->appendChild ($n);

		my $s = $dom->createElement("south");
		$s->appendTextNode ($wpt->[1] - 0.7);
		$llb->appendChild ($s);

		my $e = $dom->createElement("east");
		$e->appendTextNode ($wpt->[2] + 0.7);
		$llb->appendChild ($e);

		my $w = $dom->createElement("west");
		$w->appendTextNode ($wpt->[2] - 0.7);
		$llb->appendChild ($w);

		my $lod = $dom->createElement("Lod");
		$region->appendChild ($lod);

		my $mlp = $dom->createElement ("minLodPixels");
		$mlp->appendTextNode ("256");
		$lod->appendChild ($mlp);

		my $su = $dom->createElement("styleUrl");

		if ($wpt->[0] =~ /\d/) {
			$su->appendTextNode("#fix1");
		} else {
			$su->appendTextNode("#fix2");
		}
		$placemark->appendChild ($su);

		my $point = $dom->createElement ("Point");
		$placemark->appendChild ($point);

		my $coords = $dom->createElement("coordinates");
		$coords->appendTextNode ("$wpt->[2],$wpt->[1]");
		$point->appendChild ($coords);

		$doc->appendChild ($placemark);

	};


	open (OUTF, ">" . $outdir  . "fixes_" . $region . ".kml");

	print OUTF $dom->toString (1);

	close (OUTF);

}


# Airways

my $dom = XML::LibXML::Document->new("1.0", "UTF-8");
my $root = $dom->createElement ("kml");
$root->setAttribute ("xmlns", "http://www.opengis.net/kml/2.2");
$root->setAttribute ("xmlns:gx", "http://www.google.com/kml/ext/2.2");
$dom->setDocumentElement ($root);

my $doc = $dom->createElement("Document");
$root->addChild ($doc);

my $name = $dom->createElement("name");
$name->appendTextNode ("Airways");
$doc->appendChild ($name);

my $desc = $dom->createElement("description");
$desc->appendTextNode ("Airways converted from Navigraph data");
$doc->appendChild ($desc);

my $style = $dom->createElement("Style");
$style->setAttribute ("id", "ATSLine");
$doc->appendChild ($style);

my $lineStyle = $dom->createElement ("LineStyle");
$style->appendChild ($lineStyle);

my $width = $dom->createElement ("width");
$width->appendTextNode ("2");
$lineStyle->appendChild ($width);

my $color = $dom->createElement ("color");
$color->appendTextNode ("3f7Fffff");
$lineStyle->appendChild ($color);

my $lv = $dom->createElement ("gx:labelVisiblity");
$lv->appendTextNode("4");
$lineStyle->appendChild ($lv);

# navigraph version
my $infile = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/ATS.txt";
my $outfile = "/tmp/airways.kml";


# loop

open (INF, $infile) || die "Unable to open $infile\n";
open (OUTF, ">" . $outdir  . "Airways.kml") || die "Unable to open ${outdir}Airways.kml";

# -1 = expecting header, n = expecting count more lines.
my $l = -1;
my $nowname;
my @nowpoints;

my $place;

while (my $line = <INF>) {

  $line =~ s/^M//;
  chomp ($line);

  if ($l == -1) {
    # line is a header
    my (@d) = split (/,/, $line);
    $nowname = $d[1];
    $l = $d[2];

    $place = $dom->createElement ("Placemark");
    $doc->appendChild ($place);

    $name = $dom->createElement ("name");
    $name->appendTextNode ($nowname);
    $place->appendChild ($name);

    $desc = $dom->createElement ("description");
    $desc->appendTextNode ("airway $nowname");
    $place->appendChild ($desc);

    $style = $dom->createElement ("styleUrl");
    $style->appendTextNode ("#ATSLine");
    $place->appendChild ($style);

    $coords = "";

    #print "Got $nowname with $l points [$line]\n";

  } elsif ($l > 0) {

    $l--;
    my (@d) = split (/,/, $line);
    my $lat = $d[2];
    my $lon = $d[3];

    $coords .= "$lon,$lat\n";

  } else {

    # blank line
    $l--;


    $ls = $dom->createElement ("LineString");
    $place->appendChild ($ls);

    $extrude = $dom->createElement ("extrude");
    $extrude->appendTextNode ("1");
    $ls->appendChild ($extrude);

    $tesselate = $dom->createElement ("tesselate");
    $tesselate->appendTextNode ("1");
    $ls->appendChild ($tesselate);

    $am = $dom->createElement ("altitudeMode");
    $am->appendTextNode("clampToGround");
    $ls->appendChild ($am);

    $co = $dom->createElement ("coordinates");
    $co->appendTextNode ($coords);
    $ls->appendChild ($co);


  }
}

close (INF);
print OUTF $dom->toString (1);
close (OUTF);



