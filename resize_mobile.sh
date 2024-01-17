#!/bin/bash

# To make a backup of the evidence, copy this script to the folder and execute it.

for file in $(find ./ -name '*.png'); do

    h=$(identify -format "%[fx:h]" $file)

    # If the height is greater than 700, resize and fill with white.
    if [[ $h -gt 700 ]]; then
        echo 'Resizing to 800x600 >> '$file
        convert -border 2x2 $file $file
        montage -background '#FFFFFF' -geometry '800x600' $file $file
    fi

done
