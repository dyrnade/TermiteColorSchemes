create_scheme () {

# Extract color set and add new line
COLORS=$(grep "palette" $1 | cut -f2- -d = | sed "s/\"//g") 
COLORSN=$(echo $COLORS | tr : '\n')

# create file and path
NAME=$(basename $1 | sed "s/.config//")
CFPATH=$PWD/colors
mkdir -p $CFPATH
COLOR_FILE_PATH=$CFPATH/$NAME
touch $COLOR_FILE_PATH

echo "[colors]" > $COLOR_FILE_PATH
# Delete _color and white spaces from main colors.
printf "%s\n" $(grep "_color" $1 | sed 's/_color//g; s/^[ \s+]*//g') >> "$COLOR_FILE_PATH"

# Adds color0..15 in front of colors
IFS=$'\n'
N=0
PARSED_COLOR_SET=$(
for i in $COLORSN;
do
  echo "$i" | sed "s/^/color$N = /" 
  let N+=1
done
)

echo "$PARSED_COLOR_SET" >> "$COLOR_FILE_PATH"
unset $IFS

}

main () {
for file in $PWD/terminator/*.config;
do
  create_scheme "$file"
done
}

main "$@"
