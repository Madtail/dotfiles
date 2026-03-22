#!/bin/bash

# Set the static increment value.  Keep in mind that this will 
# be done twice. 
IncVal=500 

# Get the Maximum value for use. 
#MaxVal=$(cat /sys/class/backlight/intel_backlight/max_brightness); 
read -r MaxVal < "/sys/class/backlight/amdgpu_bl0/max_brightness"

# Get the current brightness value. 
#CurrVal=$(cat /sys/class/backlight/intel_backlight/brightness); 
read -r CurrVal < "/sys/class/backlight/amdgpu_bl0/brightness"

# Set the new value minus the decrement value. 
NewVal=$(($CurrVal + $IncVal)); 
echo $NewVal 

# Set it to the threshold of the max value. 
ThresholdVal=$(($NewVal<$MaxVal?$NewVal:$MaxVal)) 
echo $ThresholdVal 

# Set the new value directly. 
echo -n $ThresholdVal > /sys/class/backlight/amdgpu_bl0/brightness 

logger "[ACPI] brightnessup |$CurrVal| |$NewVal| |$ThresholdVal|"
