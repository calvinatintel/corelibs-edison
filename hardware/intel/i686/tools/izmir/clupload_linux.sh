#!/bin/sh

# clupload script to invoke lsz 
# Copyright (C) 2014 Intel Corporation
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

echo "starting download script"
echo "Args to shell:" $*
#
# ARG 1: Path to lsz executable.
# ARG 2: Elf File to download
# ARG 3: TTY port to use.
#
#path may contain \ need to change all to /
path_to_exe=$1
fixed_path=${path_to_exe//\\/\/}
#
tty_port_id=$3
echo "Serial Port PORT" $com_port_id 
echo "Using tty Port" $tty_port_id 
#
echo "Sending Command String to move to download if not already in download mode"
echo "~sketch downloadEdison" > $tty_port_id
#Give the host time to stop the process and wait for download
sleep 1
#
#Move the existing sketch on target.
echo "Deleting existing sketch on target"
"$fixed_path/lsz" --escape -c "mv -f /sketch/sketch.elf /sketch/sketch.elf.old" < $tty_port_id > $tty_port_id
#
# Execute the target download command
#
#Download the file.
host_file_name=$2
"$fixed_path/lsz" --escape --binary --overwrite $host_file_name < $tty_port_id  > $tty_port_id
#
#mv the downloaded file to /sketch/sketch.elf 
target_download_name="${host_file_name##*/}" 
echo "Moving downloaded file to /sketch/sketch.elf on target"
"$fixed_path/lsz" --escape -c "mv $target_download_name /sketch/sketch.elf; chmod +x /sketch/sketch.elf" < $tty_port_id > $tty_port_id
#
#
