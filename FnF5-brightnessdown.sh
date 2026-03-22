#!/bin/bash 

# Set the static decrement value.  Keep in mind that this will 
# be done twice. 
DecVal=500 

# Set the Minimum we will accept. 
MinVal=0 

# Get the current brightness value. 
#CurrVal=$(cat /sys/class/backlight/intel_backlight/brightness); 
read -r CurrVal < "/sys/class/backlight/amdgpu_bl0/brightness"

# Set the new value minus the decrement value. 
NewVal=$(($CurrVal - $DecVal)); 
echo $NewVal 

# Set it to the threshold of the min value. 
ThresholdVal=$(($NewVal>$MinVal?$NewVal:$MinVal)) 
echo $ThresholdVal 

# Set the new value directly. 
echo -n $ThresholdVal > /sys/class/backlight/amdgpu_bl0/brightness 

logger "[ACPI] brightnessdown |$CurrVal| |$NewVal| |$ThresholdVal|"
