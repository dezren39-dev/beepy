## Getting Started

1. Use the [Raspberry Pi Imager tool](https://www.raspberrypi.com/software/) to flash an SD card with the latest image
    - **Click the gear icon to also setup WiFi and SSH**
      - THIS IS VERY IMPORTANT!!!
      - DO NOT use the default FULL image. THIS WILL NOT WORK.
      - Select the __Raspberry Pi OS -->*Lite*<-- (32-bit)__ image
        - Open the images menu. 
        - The __Lite__ image is in a submenu just below the main raspbian image
      - Make a note of user/hostname/settings you choose, hopefully this will allow you to connect.
        - Make sure you've got your wifi name and password exactly right and you have your user & hostname. 
1. SSH into the pi, use the username and hostname you configured, be on the same local network
    - `ssh` user@hostname
      - Hopefully your hostname lets you connect.
      - Otherwise you will need to get the device ip address. (example: user@192.168.42.39)
        - Either query your DHCP server and find the beepy device thing in the list.
        - Or find your network subnet and begin checking IP addresses:
          - user@192.168.1.[1..254]
    - Say Yes To Fingerprint thing something about security.
    - now you are inside of the little box thing
1. update the kernel
    ```
    sudo apt-get update && sudo apt-get install raspberrypi-kernel
    ```
1. reboot
    ```
    sudo shutdown -r now
    ```
1. `ssh` into the device again like you did before.
   1. to get out of the previous `ssh` session you just rebooted
      1. you _may_ need to hit ctrl+c or cmd+c or something
   1. it may take a little bit of time so retry a few times and be patient 
1. Run the setup script:
    ```
    curl -s https://raw.githubusercontent.com/dezren39-dev/beepy/main/raspberrypi/setup.sh | sudo bash
    ```
1. **OPTIONAL OPTIMIZATIONS**
- This script provides opinionated optimizations to boot & shutdown.
  - alternatively, you can look around at the scripts right here [./](./)
  - these scripts are all independent of each other, use `/bin/sh` shell
  - you can likely run any individual script just like the rest of the examples you see here
    - but ya know, be careful, ABSOLUTELY NO WARRANTY on the software and all that. 
- Run the optimize script:
    ```
    curl -s https://raw.githubusercontent.com/dezren39-dev/beepy/main/raspberrypi/optimize.sh | sudo bash
    ```

## Details

- In ```/boot/cmdline.txt```, edit ```fbcon=font:VGA8x8``` to change the font/size. See [fbcon](https://www.kernel.org/doc/Documentation/fb/fbcon.txt) for more details. <!-- TODO: someone could make a script for this. -->
- Long holding the "End Call" key (~3 seconds) will trigger KEY_POWER and safely shutdown the pi
- Holding the "End Call" button during power up will put the keyboard into bootloader mode; it will now appear as a USB storage device and you can drag'n'drop the new firmware (\*.uf2) into the drive and it will reboot with the new firmware
