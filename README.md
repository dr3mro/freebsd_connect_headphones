## To get bluetooth working I did the following
## First make sure that bluetooth stack is working and your bluetooth is detected ( refere to the handbook)


# here is a snippit from my rc.conf
```
#bt audio
sndiod_enable="YES"
sndiod_flags="-a on"
bluetooth_enable="YES"
sdpd_enable="YES"
hcsecd_enable="YES"
bthidd_enable="YES"
bthidd_config="/etc/bluetooth/bthidd.conf"
bthidd_hids="/var/db/bthidd.hids"
#virtual_oss_enable="YES"
#virtual_oss_configs="dsp"
#virtual_oss_dsp="-T /dev/sndstat -C 2 -c 2 -r 44100 -b 16 -s 1024 -R /dev/null -P /dev/bluetooth/headphone -d dsp -t vdsp.ctl"
```
# uncomment the above lines if you want your bluetooth to be connected on boot and to change to usual speakers just kill virtual_oss process 

#steps:
# Make sure the bluetooth service is running either by rc.conf or by shell
```
service hcsecd onestart
service bluetooth start ubt0 # If this fails, do it again.
```
# pair your headphone then make sure you select it as HID add make sure to name it 'headphone' 
```
sudo bluetooth-config scan
```
# then edit /etc/bluetooth/hcsecd.conf and make sure that the pin is '000'

# Now find your Bluetooth headphones (make sure they're on):
```
hccontrol -n ubt0hci inquiry # Take note of the unique address (BD_ADDR) of your Bluetooth device. Example: "98:52:3d:48:3a:51".
```
# If unsure, find out the human readable name assigned to your remote device:
```
hccontrol -n ubt0hci remote_name_request BD_ADDR # Replace BD_ADDR by the real unique address of your Bluetooth device.
```
# enable pairing
```
sudo hccontrol -n ubt0hci write_authentication_enable 1
sudo hccontrol -n ubt0hci write_encryption_mode 1
```
# Create a connection to your remote device:
```
hccontrol -n ubt0hci create_connection BD_ADDR # Replace BD_ADDR by the real unique address of your Bluetooth device.
```
# you should now see your headphone connected
```
hccontrol -n ubt0hci read_connection_list
```
# now run script as root to create virtual_oss device and enjoy.
