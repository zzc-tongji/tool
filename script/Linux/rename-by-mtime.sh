#!/bin/sh

if [ -n "$1" ]; then
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: rename-by-mtime.sh [-h|--help] => Show help info."
    echo "   or: rename-by-mtime.sh             => Rename all file(s) in current directory as '%Y%m%d_%H%M%S_%N(3)' with UTC time zone"
    echo "   or: rename-by-mtime.sh <TZ>        => Rename all file(s) in current directory as '%Y%m%d_UTC%z_%H%M%S_%N' with time zone <TZ> (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)."
    echo ""
    exit
  fi
  p="Rename all file(s) in current directory as '%Y%m%d_UTC%z_%H%M%S_%N(3)' (TZ=$1). Continue? <y/n>";
else
  p="Rename all file(s) in current directory as '%Y%m%d_%H%M%S_%N(3)' (TZ=UTC). Continue? <y/n>";
fi
echo $p;
read a;
if [ "$a" != "y" ] && [ "$a" != "Y" ] && [ "$a" != "yes" ] && [ "$a" != "YES" ]; then
  exit 1;
fi

for f in *; do
  ext=${f##*.}
  #
  if [ -n "$1" ]; then
    n=`TZ=$1 date -r "$f" +"%Y%m%d_UTC%z_%H%M%S_%N"`;
  else
    n=`TZ=UTC date -r "$f" +"%Y%m%d_%H%M%S_%N"`;
  fi
  n=${n%??????};
  #
  if [ "$f" != "${f%.*}" ]; then
    n="${n}.${ext}"
  fi
  mv -f "$f" "$n";
  echo "$f => $n";
done
echo "Done.";
echo
